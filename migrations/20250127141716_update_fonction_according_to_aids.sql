drop function if exists "public"."get_aid_eligibility_summary"(simulation_id uuid);
drop function if exists "public"."check_aid_eligibility"(simulation_id uuid);

set check_function_bodies = off;

create type "public"."aid_eligibility_result" as ("aid_id" uuid, "name" character varying(100), "description" text, "max_amount" numeric(12,2), "default_amount" numeric(12,2), "adjusted_amount" numeric(12,2), "funding_organization" character varying(100), "required_documents" text[], "conditions_note" text);

CREATE OR REPLACE FUNCTION public.check_aid_eligibility(simulation_id uuid)
 RETURNS SETOF aid_eligibility_result
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    simulation_record RECORD;
    work_types work_type[];
    base_amount decimal(12,2);
    final_amount decimal(12,2);
    conditions text;
BEGIN
    -- Récupérer les informations de simulation
    SELECT 
        s.*,
        array_agg(awt.work_type) as selected_work_types,
        a.department  -- Ajout du département depuis l'adresse
    INTO simulation_record
    FROM aid_simulation s
    LEFT JOIN aid_simulation_work_types awt ON s.id = awt.simulation_id
    LEFT JOIN users u ON s.email = u.email
    LEFT JOIN addresses a ON u.address_id = a.id
    WHERE s.id = simulation_id
    GROUP BY s.id, a.department;

    -- Vérifier si la simulation existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Simulation not found';
    END IF;

    RETURN QUERY
    WITH eligible_aids AS (
        SELECT 
            ad.id,
            ad.name,
            ad.description,
            ad.max_amount,
            ad.default_amount,
            ad.funding_organization,
            ad.required_documents,
            CASE
                -- Calcul du montant ajusté pour l'aide départementale
                WHEN ad.name = 'Aide départementale Maine-et-Loire' 
                    AND simulation_record.department = '49'
                    AND simulation_record.energy_label IN ('f_or_g')
                THEN
                    CASE 
                        WHEN simulation_record.biosourced_materials THEN ad.default_amount + 500
                        ELSE ad.default_amount
                    END
                
                -- Calcul pour Aide Mieux chez Moi (Angers)
                WHEN ad.name = 'Aide Mieux chez Moi' 
                    AND simulation_record.department = '49'
                THEN ad.default_amount
                
                -- Calcul pour Aide Saumur
                WHEN ad.name = 'Aide amélioration énergétique Saumur'
                    AND simulation_record.department = '49'
                THEN LEAST(ad.max_amount, ad.default_amount)
                
                ELSE ad.default_amount
            END as adjusted_amount,
            CASE
                WHEN ad.name = 'Aide départementale Maine-et-Loire' 
                    AND simulation_record.biosourced_materials 
                THEN 'Bonus matériaux biosourcés inclus (+500€)'
                WHEN ad.min_energy_gain IS NOT NULL 
                THEN format('Gain énergétique minimum requis : %s%%', ad.min_energy_gain)
                ELSE NULL
            END as conditions_note
        FROM aid_details ad
        WHERE
            -- Vérification du revenu
            (ad.min_income IS NULL OR simulation_record.fiscal_income >= ad.min_income)
            AND (ad.max_income IS NULL OR simulation_record.fiscal_income <= ad.max_income)
            
            -- Vérification de l'âge du bâtiment
            AND (ad.building_age_over_15 IS NULL 
                 OR ad.building_age_over_15 = simulation_record.building_age_over_15)

            -- Vérification du statut d'occupation
            AND (ad.occupancy_status_required IS NULL 
                 OR simulation_record.occupancy_status = ANY(ad.occupancy_status_required))

            -- Vérification des types de travaux
            AND (ad.allowed_work_types IS NULL 
                 OR ad.allowed_work_types && simulation_record.selected_work_types)

            -- Vérification spécifique pour les aides locales
            AND (
                (ad.name NOT LIKE 'Aide%département%' OR simulation_record.department = '49')
                AND
                (ad.name NOT LIKE '%Saumur%' OR simulation_record.department = '49')
                AND
                (ad.name NOT LIKE '%Angers%' OR simulation_record.department = '49')
            )
    )
    SELECT 
        id,
        name,
        description,
        max_amount,
        default_amount,
        adjusted_amount,
        funding_organization,
        required_documents,
        conditions_note
    FROM eligible_aids;

END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_aid_eligibility_summary(simulation_id uuid)
 RETURNS TABLE(total_possible_amount numeric, total_adjusted_amount numeric, eligible_aids_count integer, all_required_documents text[])
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
    RETURN QUERY
    WITH eligible_aids AS (
        SELECT * FROM check_aid_eligibility(simulation_id)
    )
    SELECT 
        COALESCE(SUM(CASE WHEN max_amount > 0 THEN max_amount ELSE default_amount END), 0),
        COALESCE(SUM(adjusted_amount), 0),
        COUNT(*)::integer,
        array_agg(DISTINCT unnest(required_documents))
    FROM eligible_aids;
END;
$function$
;


