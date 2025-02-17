-- Mise à jour du type enum energy_label_type
DO $$ BEGIN
    -- Créer temporairement un nouveau type
    CREATE TYPE energy_label_type_new AS ENUM ('A_B_C_D_E', 'F_G', 'UNKNOWN');

    -- Convertir les données existantes
    ALTER TABLE simulations 
    ALTER COLUMN energy_label TYPE energy_label_type_new 
    USING (
        CASE energy_label::text
            WHEN 'A_B' THEN 'A_B_C_D_E'::energy_label_type_new
            WHEN 'C_D' THEN 'A_B_C_D_E'::energy_label_type_new
            WHEN 'E' THEN 'A_B_C_D_E'::energy_label_type_new
            WHEN 'F_G' THEN 'F_G'::energy_label_type_new
            WHEN 'UNKNOWN' THEN 'UNKNOWN'::energy_label_type_new
        END
    );

    -- Supprimer l'ancien type
    DROP TYPE energy_label_type;

    -- Renommer le nouveau type
    ALTER TYPE energy_label_type_new RENAME TO energy_label_type;
END $$;
