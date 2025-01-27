drop function if exists "public"."check_aid_eligibility"(simulation_id uuid);

drop function if exists "public"."get_aid_eligibility_summary"(simulation_id uuid);

drop type "public"."aid_eligibility_result";
create type "public"."aid_eligibility_result" as ("aid_id" uuid, "name" character varying(100), "description" text, "max_amount" numeric(12,2), "default_amount" numeric(12,2), "adjusted_amount" numeric(12,2), "funding_organization" character varying(100), "required_documents" text[], "conditions_note" text, "eligibility_status" text);


set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_aid_eligibility(p_simulation_id uuid)
 RETURNS SETOF aid_eligibility_result
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    simulation_record RECORD;
    calculated_amount numeric(12,2);
BEGIN
    -- Récupération des informations de simulation
    SELECT 
        s.*,
        array_agg(awt.work_type) as selected_work_types,
        a.department
    INTO simulation_record
    FROM aid_simulation s
    LEFT JOIN aid_simulation_work_types awt ON s.id = awt.simulation_id
    LEFT JOIN users u ON s.email = u.email
    LEFT JOIN addresses a ON u.address_id = a.id
    WHERE s.id = p_simulation_id
    GROUP BY s.id, a.department;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Simulation not found';
    END IF;

    RETURN QUERY
    WITH amount_calculation AS (
        SELECT 
            ad.id,
            ad.name,
            ad.description,
            CAST(ad.max_amount AS numeric(12,2)) as max_amount,
            CAST(ad.default_amount AS numeric(12,2)) as default_amount,
            ad.funding_organization,
            ad.required_documents,
            CAST(
                CASE
                    WHEN ad.name = 'Aide départementale Maine-et-Loire' 
                        AND simulation_record.department = '49'
                        AND simulation_record.energy_label IN ('f_or_g')
                    THEN
                        CASE 
                            WHEN simulation_record.biosourced_materials 
                            THEN CAST(ad.default_amount + 500 AS numeric(12,2))
                            ELSE ad.default_amount
                        END
                    WHEN ad.name = 'Aide Mieux chez Moi' 
                        AND simulation_record.department = '49'
                    THEN ad.default_amount
                    WHEN ad.name = 'Aide amélioration énergétique Saumur'
                        AND simulation_record.department = '49'
                    THEN LEAST(ad.max_amount, ad.default_amount)
                    ELSE ad.default_amount
                END AS numeric(12,2)
            ) as adjusted_amount
        FROM aid_details ad
        WHERE
            (ad.min_income IS NULL OR simulation_record.fiscal_income >= ad.min_income)
            AND (ad.max_income IS NULL OR simulation_record.fiscal_income <= ad.max_income)
            AND (ad.building_age_over_15 IS NULL 
                 OR ad.building_age_over_15 = simulation_record.building_age_over_15)
            AND (ad.occupancy_status_required IS NULL 
                 OR simulation_record.occupancy_status::text = ANY(ad.occupancy_status_required::text[]))
            AND (ad.allowed_work_types IS NULL 
                 OR ad.allowed_work_types && simulation_record.selected_work_types)
            AND (
                (ad.name NOT LIKE 'Aide%département%' OR simulation_record.department = '49')
                AND
                (ad.name NOT LIKE '%Saumur%' OR simulation_record.department = '49')
                AND
                (ad.name NOT LIKE '%Angers%' OR simulation_record.department = '49')
            )
    )
    SELECT 
        ac.id,
        ac.name,
        ac.description,
        ac.max_amount,
        ac.default_amount,
        ac.adjusted_amount,
        ac.funding_organization,
        ac.required_documents,
        CASE
            WHEN ac.name = 'Aide départementale Maine-et-Loire' 
                AND simulation_record.biosourced_materials 
            THEN 'Bonus matériaux biosourcés inclus (+500€)'
            WHEN EXISTS (
                SELECT 1 
                FROM aid_details ad 
                WHERE ad.id = ac.id AND ad.min_energy_gain IS NOT NULL
            )
            THEN format('Gain énergétique minimum requis : %s%%', 
                (SELECT min_energy_gain FROM aid_details WHERE id = ac.id)
            )
            ELSE NULL
        END as conditions_note,
        CASE
            WHEN ac.name = 'Eco-PTZ' 
            THEN 'Éligible - Prêt à taux zéro disponible jusquà 50 000€'
            WHEN ac.name = 'MaPrimeRenov'
            THEN 'Éligible - Montant variable selon vos revenus et les travaux envisagés'
            WHEN ac.name = 'Certificats d''Économies d''Énergie'
            THEN 'Éligible - Prime calculée selon les économies d''énergie réalisées'
            WHEN ac.name = 'Aide départementale Maine-et-Loire' 
                AND simulation_record.biosourced_materials
            THEN 'Éligible - Montant de base + bonus matériaux biosourcés'
            WHEN ac.default_amount > 0
            THEN format('Éligible - Montant estimé : %s€', ac.adjusted_amount)
            WHEN ac.max_amount > 0
            THEN format('Éligible - Montant maximum : %s€', ac.max_amount)
            ELSE 'Éligible - Montant à définir selon dossier'
        END as eligibility_status
    FROM amount_calculation ac;

END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_aid_eligibility_summary(p_simulation_id uuid)
 RETURNS TABLE(total_possible_amount numeric, total_adjusted_amount numeric, eligible_aids_count integer, all_required_documents text[])
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
    RETURN QUERY
    WITH RECURSIVE 
    eligible_aids AS (
        SELECT * FROM check_aid_eligibility(p_simulation_id)
    ),
    unnested_docs AS (
        SELECT DISTINCT unnest(required_documents) as doc
        FROM eligible_aids
    )
    SELECT 
        COALESCE(SUM(CASE WHEN max_amount > 0 THEN max_amount ELSE default_amount END), 0)::numeric(12,2),
        COALESCE(SUM(adjusted_amount), 0)::numeric(12,2),
        COUNT(*)::integer,
        array_agg(doc)
    FROM eligible_aids, unnested_docs
    GROUP BY (SELECT 1);  -- Un groupe unique pour avoir un seul résultat

END;
$function$
;

