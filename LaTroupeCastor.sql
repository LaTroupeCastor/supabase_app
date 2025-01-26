-- Désactiver temporairement les contraintes de clés étrangères
DO $$ 
DECLARE
    r RECORD;
BEGIN
    -- Désactiver les contraintes de clés étrangères
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'ALTER TABLE "' || r.tablename || '" DISABLE TRIGGER ALL';
    END LOOP;

    -- Supprimer toutes les données de toutes les tables
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'TRUNCATE TABLE "' || r.tablename || '" CASCADE';
    END LOOP;

    -- Réactiver les contraintes de clés étrangères
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'ALTER TABLE "' || r.tablename || '" ENABLE TRIGGER ALL';
    END LOOP;
END $$;

-- Réinitialiser les séquences
DO $$ 
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT sequencename FROM pg_sequences WHERE schemaname = 'public'
    LOOP
        EXECUTE 'ALTER SEQUENCE ' || rec.sequencename || ' RESTART WITH 1;';
    END LOOP;
END $$;
