set check_function_bodies = off;

create type "public"."eligible_aid_result" as ("aid_id" uuid, "name" character varying(100), "description" text, "max_amount" numeric(12,2), "default_amount" numeric(12,2), "funding_organization" character varying(100), "required_documents" text[]);

CREATE OR REPLACE FUNCTION public.check_aid_eligibility(simulation_id uuid)
 RETURNS SETOF eligible_aid_result
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    simulation_record RECORD;
    work_types work_type[];
BEGIN
    -- Récupérer les informations de simulation
    SELECT 
        s.*,
        array_agg(awt.work_type) as selected_work_types
    INTO simulation_record
    FROM aid_simulation s
    LEFT JOIN aid_simulation_work_types awt ON s.id = awt.simulation_id
    WHERE s.id = simulation_id
    GROUP BY s.id;

    -- Vérifier si la simulation existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Simulation not found';
    END IF;

    -- Retourner les aides éligibles
    RETURN QUERY
    SELECT 
        ad.id as aid_id,
        ad.name,
        ad.description,
        ad.max_amount,
        ad.default_amount,
        ad.funding_organization,
        ad.required_documents
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
             OR simulation_record.occupancy_status::text = ANY(ad.occupancy_status_required))

        -- Vérification des types de travaux
        -- Au moins un type de travaux sélectionné doit être dans les types autorisés
        AND (ad.allowed_work_types IS NULL 
             OR ad.allowed_work_types && simulation_record.selected_work_types);

END;
$function$
;

