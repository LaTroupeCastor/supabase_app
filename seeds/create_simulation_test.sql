-- Tests des différents profils de revenus
INSERT INTO public.aid_simulation (
    current_step,
    current_sub_step,
    session_token,
    expiration_date,
    department,
    email,
    anah_aid_last_5_years,
    biosourced_materials,
    building_age_over_15,
    energy_diagnostic_done,
    energy_label,
    occupancy_status,
    work_type,
    fiscal_income,
    first_name,
    last_name
) VALUES 
-- Revenus très modestes
(
    3, 2, 'test-revenus-tres-modestes',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test1@example.com', false, true, true, true,
    'F_G', 'owner_occupant', ARRAY['isolation'::work_type, 'heating'::work_type, 'ventilation'::work_type], 'very_low',
    'Jean', 'Dupont'
),
-- Revenus modestes
(
    3, 2, 'test-revenus-modestes',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test2@example.com', false, false, true, true,
    'A_B_C_D_E', 'owner_occupant', ARRAY['isolation'::work_type, 'windows'::work_type], 'low',
    'Marie', 'Martin'
),
-- Revenus élevés
(
    3, 2, 'test-revenus-eleves',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test3@example.com', false, false, true, true,
    'A_B_C_D_E', 'owner_occupant', ARRAY['heating'::work_type, 'ventilation'::work_type], 'very_high',
    'Pierre', 'Durand'
);

-- Tests des différents statuts d'occupation
INSERT INTO public.aid_simulation (
    current_step,
    current_sub_step,
    session_token,
    expiration_date,
    department,
    email,
    anah_aid_last_5_years,
    biosourced_materials,
    building_age_over_15,
    energy_diagnostic_done,
    energy_label,
    occupancy_status,
    work_type,
    fiscal_income,
    first_name,
    last_name
) VALUES 
-- Propriétaire bailleur
(
    3, 2, 'test-proprietaire-bailleur',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test4@example.com', false, false, true, true,
    'F_G', 'owner_lessor', ARRAY['isolation'::work_type, 'heating'::work_type, 'windows'::work_type], 'medium',
    'Sophie', 'Petit'
),
-- Locataire
(
    3, 2, 'test-locataire',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test5@example.com', false, false, false, true,
    'A_B_C_D_E', 'tenant', ARRAY['ventilation'::work_type, 'windows'::work_type], 'low',
    'Lucas', 'Moreau'
),
-- Copropriétaire
(
    3, 2, 'test-copropriete',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test6@example.com', false, false, true, true,
    'A_B_C_D_E', 'co_owner', ARRAY['windows'::work_type, 'isolation'::work_type], 'medium',
    'Emma', 'Leroy'
);

-- Tests des différents types de travaux
INSERT INTO public.aid_simulation (
    current_step,
    current_sub_step,
    session_token,
    expiration_date,
    department,
    email,
    anah_aid_last_5_years,
    biosourced_materials,
    building_age_over_15,
    energy_diagnostic_done,
    energy_label,
    occupancy_status,
    work_type,
    fiscal_income,
    first_name,
    last_name
) VALUES 
-- Test isolation
(
    3, 2, 'test-isolation',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test10@example.com', false, true, true, true,
    'A_B_C_D_E', 'owner_occupant', ARRAY['isolation'::work_type, 'windows'::work_type, 'ventilation'::work_type], 'medium',
    'Alice', 'Robert'
),
-- Test chauffage
(
    3, 2, 'test-chauffage',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test11@example.com', false, false, true, true,
    'F_G', 'owner_occupant', ARRAY['heating'::work_type, 'isolation'::work_type], 'medium',
    'Hugo', 'Simon'
),
-- Test ventilation
(
    3, 2, 'test-ventilation',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test12@example.com', false, false, true, true,
    'A_B_C_D_E', 'owner_occupant', ARRAY['ventilation'::work_type, 'heating'::work_type], 'low',
    'Laura', 'Lambert'
);

-- Tests géographiques et cas particuliers
INSERT INTO public.aid_simulation (
    current_step,
    current_sub_step,
    session_token,
    expiration_date,
    department,
    email,
    anah_aid_last_5_years,
    biosourced_materials,
    building_age_over_15,
    energy_diagnostic_done,
    energy_label,
    occupancy_status,
    work_type,
    fiscal_income,
    first_name,
    last_name
) VALUES 
-- Hors Maine-et-Loire
(
    3, 2, 'test-hors-49',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '44', 'test7@example.com', false, true, true, true,
    'F_G', 'owner_occupant', ARRAY['isolation'::work_type, 'heating'::work_type, 'windows'::work_type, 'ventilation'::work_type], 'medium',
    'Thomas', 'Roux'
),
-- Bâtiment récent
(
    3, 2, 'test-batiment-recent',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test8@example.com', false, false, false, true,
    'A_B_C_D_E', 'owner_occupant', ARRAY['isolation'::work_type, 'heating'::work_type], 'medium',
    'Julie', 'Bernard'
),
-- Tous critères maximaux - Bâtiment ancien (MaPrimeRenov)
(
    3, 2, 'test-tous-criteres-max-ancien',                                                                                                                                
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),                                                                                                                     
    '49', 'test9@example.com', false, true, true, true,                                                                                                           
    'F_G', 'owner_occupant', ARRAY['heating'::work_type, 'isolation'::work_type, 'ventilation'::work_type], 'very_low',                                                                                                                
    'Nicolas', 'Dubois'
),
-- Tous critères maximaux - Bâtiment récent (CEE)
(
    3, 2, 'test-tous-criteres-max-recent',                                                                                                                                
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),                                                                                                                     
    '49', 'test10@example.com', false, true, false, true,                                                                                                           
    'F_G', 'owner_occupant', ARRAY['heating'::work_type, 'windows'::work_type, 'ventilation'::work_type], 'very_low',                                                                                                                
    'Thomas', 'Martin'
);
