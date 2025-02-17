-- Modification du type de la colonne allowed_work_types pour accepter un tableau de work_type
ALTER TABLE aid_details 
ALTER COLUMN allowed_work_types TYPE work_type[] USING allowed_work_types::work_type[];
