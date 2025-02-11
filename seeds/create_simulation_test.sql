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
 ) VALUES (                                                                                                                                                                             
     3, -- current_step                                                                                                                                                                 
     2, -- current_sub_step                                                                                                                                                             
     'session_test_123', -- session_token                                                                                                                                               
     (CURRENT_TIMESTAMP + INTERVAL '24 hours'), -- expiration_date (24h à partir de maintenant)                                                                                         
     '49', -- department (Maine-et-Loire)                                                                                                                                               
     'test@example.com', -- email                                                                                                                                                       
     false, -- anah_aid_last_5_years                                                                                                                                                    
     true, -- biosourced_materials                                                                                                                                                      
     true, -- building_age_over_15                                                                                                                                                      
     true, -- energy_diagnostic_done                                                                                                                                                    
     'F_G', -- energy_label                                                                                                                                                               
     'owner_occupant', -- occupancy_status                                                                                                                                              
     'isolation', -- work_type                                                                                                                                                          
     'very_low', -- fiscal_income                                                                                                                                                       
     'Jean', -- first_name                                                                                                                                                              
     'Dupont' -- last_name                                                                                                                                                              
 );

 -- Doit retourner le résultat suivant : MaPrimeRenov avec un montant maximum (car revenus très modestes)  + L'aide départementale du Maine-et-Loire avec le bonus matéraux biosourcés


-- Simulation qui ne doit retourner aucune aide éligible
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
 ) VALUES (
     3,
     2,
     'session_test_no_aid',
     (CURRENT_TIMESTAMP + INTERVAL '24 hours'),
     '75', -- Département hors Maine-et-Loire
     'test2@example.com',
     false,
     false,
     false, -- Bâtiment de moins de 15 ans
     true,
     'A_B', -- Très bonne performance énergétique
     'tenant', -- Locataire
     'global_renovation',
     'very_high', -- Revenus très élevés
     'Marie',
     'Martin'
 );

 -- Ne doit retourner aucune aide éligible
