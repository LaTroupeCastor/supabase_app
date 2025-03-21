-- Donner les droits d'accès
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;

-- Insertion des questions principales (étapes)                                                                                                                                        
 INSERT INTO aid_questions (step_number, title, description) VALUES                                                                                                                     
 (1, 'Informations sur vous et votre statut', 'Parlons de votre situation actuelle'),                                                                                                   
 (2, 'Caractéristiques de votre logement', 'Décrivez votre logement'),                                                                                                                  
 (3, 'Vos revenus', 'Information sur vos revenus'),                                                                                                                                     
 (4, 'Votre projet', 'Détaillez votre projet de rénovation');                                                                                                                           
                                                                                                                                                                                        
 -- Insertion des sous-questions pour l'étape 1                                                                                                                                         
 WITH step1 AS (SELECT id FROM aid_questions WHERE step_number = 1)                                                                                                                     
 INSERT INTO aid_sub_questions (question_id, sub_step_number, content, type_sub_questions) VALUES                                                                                           
 ((SELECT id FROM step1), 1, 'Quel est votre statut d''occupation ?', 'occupancy_status'),                                                                                                                  
 ((SELECT id FROM step1), 2, 'Avez-vous déjà bénéficié d''aides de l''Anah ces 5 dernières années ?', 'anah');                                                                                  
                                                                                                                                                                                        
 -- Insertion des sous-questions pour l'étape 2                                                                                                                                         
 WITH step2 AS (SELECT id FROM aid_questions WHERE step_number = 2)                                                                                                                     
 INSERT INTO aid_sub_questions (question_id, sub_step_number, content, type_sub_questions) VALUES                                                                                           
 ((SELECT id FROM step2), 1, 'Quel est l''âge de votre logement ?', 'building_age'),                                                                                                                    
 ((SELECT id FROM step2), 2, 'Quelle est l''étiquette énergétique actuelle de votre logement ?', 'energy_label'),                                                                                       
 ((SELECT id FROM step2), 3, 'Avez-vous déjà fait réaliser un diagnostic énergétique ?', 'energy_diagnostic');                                                                                               
                                                                                                                                                                                        
 -- Insertion des sous-questions pour l'étape 3                                                                                                                                         
 WITH step3 AS (SELECT id FROM aid_questions WHERE step_number = 3)                                                                                                                     
 INSERT INTO aid_sub_questions (question_id, sub_step_number, content, type_sub_questions) VALUES                                                                                           
 ((SELECT id FROM step3), 1, 'Quel est le revenu fiscal de référence de votre foyer ?', 'fiscal_income');

 -- Insertion des réponses pour l'étape 3 (Revenu fiscal)
 WITH income_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%revenu fiscal%')
 INSERT INTO aid_answers (sub_question_id, content, image_url, value) VALUES
 ((SELECT id FROM income_q), 'Moins de 15 262€', 'income_1', 'very_low'),
 ((SELECT id FROM income_q), 'Entre 15 262€ et 19 565€', 'income_2', 'low'),
 ((SELECT id FROM income_q), 'Entre 19 565€ et 29 148€', 'income_3', 'medium'),
 ((SELECT id FROM income_q), 'Entre 29 148€ et 38 184€', 'income_4', 'high'),
 ((SELECT id FROM income_q), 'Plus de 38 184€', 'income_5', 'very_high');
                                                                                                                                                                                        
 -- Insertion des sous-questions pour l'étape 4                                                                                                                                         
 WITH step4 AS (SELECT id FROM aid_questions WHERE step_number = 4)                                                                                                                     
 INSERT INTO aid_sub_questions (question_id, sub_step_number, content, type_sub_questions, allow_multiple_answers) VALUES                                                                                           
 ((SELECT id FROM step4), 1, 'Quel type de travaux souhaitez-vous réaliser ?', 'work_type', true),                                                                                                         
 ((SELECT id FROM step4), 2, 'Souhaitez-vous utiliser des matériaux biosourcés ?', 'biosourced', false);                                                                                                     
                                                                                                                                                                                        
 -- Insertion des réponses pour chaque sous-question                                                                                                                                    
 -- Étape 1, Question 1 (Statut d'occupation)                                                                                                                                           
 WITH occupation_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%statut d''occupation%')                                                                                           
 INSERT INTO aid_answers (sub_question_id, content, image_url, value) VALUES                                                                                                                              
 ((SELECT id FROM occupation_q), 'Propriétaire occupant', 'proprietaire_occupant', 'owner_occupant'),                                                                                                                     
 ((SELECT id FROM occupation_q), 'Propriétaire bailleur', 'proprietaire_bailleur', 'owner_lessor'),                                                                                                                     
 ((SELECT id FROM occupation_q), 'Locataire', 'locataire', 'tenant'),                                                                                                                                                 
 ((SELECT id FROM occupation_q), 'Copropriétaire', 'copropriete', 'co_owner');                                                                                                                                            
                                                                                                                                                                                        
 -- Étape 1, Question 2 (Aides Anah)                                                                                                                                                    
 WITH anah_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%Anah%')                                                                                                           
 INSERT INTO aid_answers (sub_question_id, content, image_url, value) VALUES                                                                                                                              
 ((SELECT id FROM anah_q), 'Oui', 'check', 'yes'),                                                                                                                                                       
 ((SELECT id FROM anah_q), 'Non', 'cross', 'no');                                                                                                                                                       
                                                                                                                                                                                        
 -- Étape 2, Question 1 (Âge logement)                                                                                                                                                  
 WITH age_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%âge de votre logement%')                                                                                          
 INSERT INTO aid_answers (sub_question_id, content, image_url, value) VALUES                                                                                                                              
 ((SELECT id FROM age_q), 'Moins de 15 ans', 'maison_recente', 'false'),                                                                                                                                           
 ((SELECT id FROM age_q), 'Plus de 15 ans', 'maison_ancienne', 'true');                                                                                                                                            
                                                                                                                                                                                        
 -- Étape 2, Question 3 (Étiquette énergétique)                                                                                                                                         
 WITH dpe_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%étiquette énergétique%')                                                                                          
 INSERT INTO aid_answers (sub_question_id, content, image_url, value) VALUES                                                                                                                              
 ((SELECT id FROM dpe_q), 'A, B, C, D ou E', 'dpe_abcde', 'A_B_C_D_E'),                                                                                                                                                    
 ((SELECT id FROM dpe_q), 'F ou G', 'dpe_fg', 'F_G'),                                                                                                                                                    
 ((SELECT id FROM dpe_q), 'Je ne sais pas', 'question', 'UNKNOWN');                                                                                                                                            
                                                                                                                                                                                        
 -- Étape 2, Question 4 (Diagnostic énergétique)                                                                                                                                        
 WITH diagnostic_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%diagnostic énergétique%')                                                                                         
 INSERT INTO aid_answers (sub_question_id, content, image_url, value) VALUES                                                                                                                              
 ((SELECT id FROM diagnostic_q), 'Oui', 'check', 'yes'),                                                                                                                                                       
 ((SELECT id FROM diagnostic_q), 'Non', 'cross', 'no');                                                                                                                                                       
                                                                                                                                                                                        
 -- Étape 4, Question 1 (Type de travaux)                                                                                                                                               
 WITH travaux_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%type de travaux%')                                                                                                
 INSERT INTO aid_answers (sub_question_id, content, image_url, value) VALUES                                                                                                                              
 ((SELECT id FROM travaux_q), 'Isolation (murs, combles, planchers)', 'isolation', 'isolation'),                                                                                                                      
 ((SELECT id FROM travaux_q), 'Chauffage', 'chauffage', 'heating'),                                                                                                                                                 
 ((SELECT id FROM travaux_q), 'Ventilation', 'ventilation', 'ventilation'),                                                                                                                                               
 ((SELECT id FROM travaux_q), 'Fenêtres', 'fenetre', 'windows'),                                                                                                                                                  
 ((SELECT id FROM travaux_q), 'Rénovation globale', 'renovation', 'global_renovation');                                                                                                                                        
                                                                                                                                                                                        
 -- Étape 4, Question 2 (Matériaux biosourcés)                                                                                                                                          
 WITH materiaux_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%biosourcés%')                                                                                                     
 INSERT INTO aid_answers (sub_question_id, content, image_url, value) VALUES                                                                                                                              
 ((SELECT id FROM materiaux_q), 'Oui', 'check', 'yes'),                                                                                                                                                       
 ((SELECT id FROM materiaux_q), 'Non', 'cross', 'no');   
