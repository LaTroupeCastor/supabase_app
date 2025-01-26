-- Désactiver temporairement les contraintes de clés étrangères
DO $$ 
BEGIN
    -- Désactiver les contraintes de clés étrangères
    EXECUTE (
        SELECT 'ALTER TABLE "' || tablename || '" DISABLE TRIGGER ALL;'
        FROM pg_tables
        WHERE schemaname = 'public'
    );

    -- Supprimer toutes les données de toutes les tables
    EXECUTE (
        SELECT string_agg('TRUNCATE TABLE "' || tablename || '" CASCADE;', ' ')
        FROM pg_tables
        WHERE schemaname = 'public'
    );

    -- Réactiver les contraintes de clés étrangères
    EXECUTE (
        SELECT 'ALTER TABLE "' || tablename || '" ENABLE TRIGGER ALL;'
        FROM pg_tables
        WHERE schemaname = 'public'
    );
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
