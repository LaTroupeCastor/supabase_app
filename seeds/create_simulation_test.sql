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
    'F_G', 'owner_occupant', 'global_renovation', 'very_low',
    'Jean', 'Dupont'
),
-- Revenus modestes
(
    3, 2, 'test-revenus-modestes',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test2@example.com', false, false, true, true,
    'E', 'owner_occupant', 'isolation', 'low',
    'Marie', 'Martin'
),
-- Revenus élevés
(
    3, 2, 'test-revenus-eleves',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test3@example.com', false, false, true, true,
    'C_D', 'owner_occupant', 'heating', 'very_high',
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
    'F_G', 'owner_lessor', 'global_renovation', 'medium',
    'Sophie', 'Petit'
),
-- Locataire
(
    3, 2, 'test-locataire',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test5@example.com', false, false, false, true,
    'E', 'tenant', 'ventilation', 'low',
    'Lucas', 'Moreau'
),
-- Copropriétaire
(
    3, 2, 'test-copropriete',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test6@example.com', false, false, true, true,
    'C_D', 'co_owner', 'windows', 'medium',
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
    'E', 'owner_occupant', 'isolation', 'medium',
    'Alice', 'Robert'
),
-- Test chauffage
(
    3, 2, 'test-chauffage',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test11@example.com', false, false, true, true,
    'F_G', 'owner_occupant', 'heating', 'medium',
    'Hugo', 'Simon'
),
-- Test ventilation
(
    3, 2, 'test-ventilation',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test12@example.com', false, false, true, true,
    'C_D', 'owner_occupant', 'ventilation', 'low',
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
    'F_G', 'owner_occupant', 'global_renovation', 'medium',
    'Thomas', 'Roux'
),
-- Bâtiment récent
(
    3, 2, 'test-batiment-recent',
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
    '49', 'test8@example.com', false, false, false, true,
    'C_D', 'owner_occupant', 'global_renovation', 'medium',
    'Julie', 'Bernard'
),
-- Tous critères maximaux - Bâtiment ancien (MaPrimeRenov)
(
    3, 2, 'test-tous-criteres-max-ancien',                                                                                                                                
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),                                                                                                                     
    '49', 'test9@example.com', false, true, true, true,                                                                                                           
    'F_G', 'owner_occupant', 'heating', 'very_low',                                                                                                                
    'Nicolas', 'Dubois'
),
-- Tous critères maximaux - Bâtiment récent (CEE)
(
    3, 2, 'test-tous-criteres-max-recent',                                                                                                                                
    (CURRENT_TIMESTAMP + INTERVAL '24 hours'),                                                                                                                     
    '49', 'test10@example.com', false, true, false, true,                                                                                                           
    'F_G', 'owner_occupant', 'heating', 'very_low',                                                                                                                
    'Thomas', 'Martin'
);
