-- 1. D'abord, créons une simulation complète
WITH new_simulation AS (
    INSERT INTO aid_simulation (
        occupancy_status,
        building_age_over_15,
        fiscal_income,
        energy_label,
        anah_aid_last_5_years,
        living_area,
        biosourced_materials,
        energy_diagnostic_done,
        email,
        current_step,
        department,
        session_token,
        expiration_date
    ) VALUES (
        'owner_occupant',
        true,
        35000,
        'f_or_g',
        false,
        120,
        true,
        false,
        'test@example.com',
        1,
        49,
        'session-' || gen_random_uuid(),
        current_timestamp + (2000 ||' minutes')::interval
    ) RETURNING id
)

-- Ajout des types de travaux pour cette simulation
INSERT INTO aid_simulation_work_types (simulation_id, work_type)
SELECT 
    new_simulation.id,
    work_type
FROM new_simulation, unnest(ARRAY['isolation', 'heating']::work_type[]) as work_type;

-- 2. Vérifier l'éligibilité pour une simulation spécifique
SELECT 
    name,
    description,
    adjusted_amount,
    max_amount,
    default_amount,
    funding_organization,
    conditions_note,
    eligibility_status,
    required_documents
FROM check_aid_eligibility('simulation-id-here');

-- 3. Obtenir un résumé pour une simulation
SELECT * FROM get_aid_eligibility_summary('simulation-id-here');
