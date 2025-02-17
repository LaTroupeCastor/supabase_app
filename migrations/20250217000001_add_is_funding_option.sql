-- Add is_funding_option column to aid_details
ALTER TABLE aid_details ADD COLUMN is_funding_option BOOLEAN DEFAULT FALSE;

-- Update existing funding options
UPDATE aid_details 
SET is_funding_option = TRUE 
WHERE name IN ('Eco-PTZ (Éco-Prêt à Taux Zéro)', 'Exonération de taxe foncière');
