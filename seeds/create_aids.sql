-- Donner les droits d'accès
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;

-- Insertions complètes des aides
INSERT INTO aid_details (
    name,
    description,
    default_amount,
    max_amount,
    min_income,
    max_income,
    min_energy_gain,
    building_age_over_15,
    allowed_work_types,
    funding_organization,
    required_documents,
    occupancy_status_required,
    cumulative,
    more_info_url
) VALUES 
-- 1. MaPrimeRenov
(
    'MaPrimeRenov',
    'Aide financière de l''État pour la rénovation énergétique des logements. Accessible à tous les propriétaires occupants et bailleurs.',
    0,
    20000,
    NULL,
    NULL,
    NULL,
    true,
    ARRAY['isolation', 'heating', 'ventilation', 'windows', 'global_renovation']::work_type[],
    'État',
    ARRAY['Avis d''imposition', 'Devis d''artisan RGE', 'Justificatif de propriété'],
    ARRAY['owner_occupant', 'owner_lessor']::occupancy_status_type[],
    true,
    'https://www.maprimerenov.gouv.fr/'
),

-- 2. Certificats d'Économies d'Énergie (CEE)
(
    'Certificats d''Économies d''Énergie',
    'Prime versée par les fournisseurs d''énergie pour des travaux de rénovation énergétique.',
    2500,
    5000,
    NULL,
    NULL,
    NULL,
    false,
    ARRAY['isolation', 'heating', 'ventilation', 'windows']::work_type[],
    'Fournisseurs d''énergie',
    ARRAY['Devis d''artisan RGE', 'Factures des travaux'],
    ARRAY['owner_occupant', 'owner_lessor', 'tenant']::occupancy_status_type[],
    true,
    'https://www.ecologie.gouv.fr/dispositif-des-certificats-deconomies-denergie'
),

-- 3. Aide départementale - Maine-et-Loire
(
    'Aide départementale Maine-et-Loire',
    'Aide du département pour la rénovation énergétique des logements classés F ou G.',
    1500,
    3500,
    NULL,
    NULL,
    35,
    true,
    ARRAY['isolation', 'heating', 'ventilation', 'windows', 'global_renovation']::work_type[],
    'Département Maine-et-Loire',
    ARRAY['Avis d''imposition', 'DPE avant travaux', 'Devis d''artisan'],
    ARRAY['owner_occupant']::occupancy_status_type[],
    true,
    'https://www.maine-et-loire.fr/aides-et-services/logement-et-habitat/ameliorer-son-logement'
),

-- 4. Aide Mieux chez Moi
(
    'Aide Mieux chez Moi',
    'Aide d''Angers Loire Métropole pour la rénovation énergétique ou l''adaptation au vieillissement.',
    0,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    ARRAY['isolation', 'heating', 'ventilation', 'windows', 'global_renovation']::work_type[],
    'Angers Loire Métropole',
    ARRAY['Justificatif de domicile', 'Devis d''artisan', 'Diagnostic énergétique'],
    ARRAY['owner_occupant', 'owner_lessor']::occupancy_status_type[],
    true,
    'https://www.angersloiremetropole.fr/mon-quotidien/logement-et-habitat/'
),

-- 5. Aide à l'amélioration énergétique Saumur
(
    'Aide amélioration énergétique Saumur',
    'Aide de la Communauté d''Agglomération Saumur Val de Loire.',
    0,
    1000,
    NULL,
    NULL,
    NULL,
    true,
    ARRAY['isolation', 'heating', 'ventilation', 'windows', 'global_renovation']::work_type[],
    'Saumur Val de Loire',
    ARRAY['Devis d''artisan RGE', 'Justificatif de domicile'],
    ARRAY['owner_occupant', 'owner_lessor']::occupancy_status_type[],
    true,
    'https://www.saumurvaldeloire.fr/logement'
),

-- 6. Eco-prêt à taux zéro
(
    'Eco-PTZ',
    'Prêt à taux zéro pour financer des travaux de rénovation énergétique.',
    0,
    50000,
    NULL,
    NULL,
    NULL,
    true,
    ARRAY['isolation', 'heating', 'ventilation', 'windows', 'global_renovation']::work_type[],
    'État',
    ARRAY['Plan de financement', 'Devis d''artisan RGE', 'Justificatif de propriété'],
    ARRAY['owner_occupant', 'owner_lessor']::occupancy_status_type[],
    true,
    'https://www.economie.gouv.fr/particuliers/eco-pret-a-taux-zero-ptz'
),

-- 7. Exonération de taxe foncière
(
    'Exonération de taxe foncière',
    'Exonération partielle ou totale de taxe foncière pendant 3 à 5 ans pour travaux d''amélioration énergétique.',
    0,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    ARRAY['isolation', 'heating', 'ventilation', 'windows', 'global_renovation']::work_type[],
    'Collectivité locale',
    ARRAY['Factures des travaux', 'Formulaire H1', 'Justificatif de propriété'],
    ARRAY['owner_occupant', 'owner_lessor']::occupancy_status_type[],
    true,
    'https://www.collectivites-locales.gouv.fr/finances-locales/la-fiscalite-directe-locale'
),

-- 8. Fonds Air Bois
(
    'Fonds Air Bois',
    'Aide pour le remplacement d''un ancien appareil de chauffage au bois par un modèle performant.',
    0,
    1000,
    NULL,
    NULL,
    NULL,
    false,
    ARRAY['heating']::work_type[],
    'Collectivité locale',
    ARRAY['Devis d''artisan RGE', 'Photo de l''ancien appareil', 'Certificat de destruction'],
    ARRAY['owner_occupant', 'owner_lessor']::occupancy_status_type[],
    true,
    'https://agirpourlatransition.ademe.fr/particuliers/finances/aides-a-renovation/aide-fonds-air'
),

-- 9. Habiter Mieux Sérénité
(
    'Habiter Mieux Sérénité',
    'Programme de l''Anah pour une rénovation globale avec un gain énergétique minimum de 35%.',
    0,
    30000,
    NULL,
    NULL,
    35,
    true,
    ARRAY['global_renovation']::work_type[],
    'Anah',
    ARRAY['Avis d''imposition', 'Devis d''artisan RGE', 'DPE avant travaux', 'Justificatif de propriété'],
    ARRAY['owner_occupant']::occupancy_status_type[],
    true,
    'https://www.anah.fr/proprietaires/proprietaires-occupants/etre-mieux-chauffe-avec-habiter-mieux-serenite/'
),

-- 10. Aide spécifique communes
(
    'Aides spécifiques communes',
    'Aides variables selon les communes pour l''installation de panneaux solaires, isolation ou chauffage écologique.',
    0,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    ARRAY['isolation', 'heating']::work_type[],
    'Communes',
    ARRAY['Justificatif de domicile', 'Devis d''artisan'],
    ARRAY['owner_occupant', 'owner_lessor']::occupancy_status_type[],
    true,
    'https://www.service-public.fr/particuliers/vosdroits/F35083'
);
