-- Modification du type de la colonne work_type dans aid_simulation pour accepter un tableau
ALTER TABLE aid_simulation 
ALTER COLUMN work_type TYPE work_type[] USING ARRAY[work_type]::work_type[];
