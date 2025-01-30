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
 INSERT INTO aid_sub_questions (question_id, sub_step_number, content) VALUES                                                                                                           
 ((SELECT id FROM step1), 1, 'Quel est votre statut d''occupation ?'),                                                                                                                  
 ((SELECT id FROM step1), 2, 'Avez-vous déjà bénéficié d''aides de l''Anah ces 5 dernières années ?');                                                                                  
                                                                                                                                                                                        
 -- Insertion des sous-questions pour l'étape 2                                                                                                                                         
 WITH step2 AS (SELECT id FROM aid_questions WHERE step_number = 2)                                                                                                                     
 INSERT INTO aid_sub_questions (question_id, sub_step_number, content) VALUES                                                                                                           
 ((SELECT id FROM step2), 1, 'Quel est l''âge de votre logement ?'),                                                                                                                    
 ((SELECT id FROM step2), 2, 'Quelle est l''étiquette énergétique actuelle de votre logement ?'),                                                                                       
 ((SELECT id FROM step2), 3, 'Avez-vous déjà fait réaliser un diagnostic énergétique ?');                                                                                               
                                                                                                                                                                                        
 -- Insertion des sous-questions pour l'étape 3                                                                                                                                         
 WITH step3 AS (SELECT id FROM aid_questions WHERE step_number = 3)                                                                                                                     
 INSERT INTO aid_sub_questions (question_id, sub_step_number, content) VALUES                                                                                                           
 ((SELECT id FROM step3), 1, 'Quel est le revenu fiscal de référence de votre foyer ?');                                                                                                
                                                                                                                                                                                        
 -- Insertion des sous-questions pour l'étape 4                                                                                                                                         
 WITH step4 AS (SELECT id FROM aid_questions WHERE step_number = 4)                                                                                                                     
 INSERT INTO aid_sub_questions (question_id, sub_step_number, content) VALUES                                                                                                           
 ((SELECT id FROM step4), 1, 'Quel type de travaux souhaitez-vous réaliser ?'),                                                                                                         
 ((SELECT id FROM step4), 2, 'Souhaitez-vous utiliser des matériaux biosourcés ?');                                                                                                     
                                                                                                                                                                                        
 -- Insertion des réponses pour chaque sous-question                                                                                                                                    
 -- Étape 1, Question 1 (Statut d'occupation)                                                                                                                                           
 WITH occupation_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%statut d''occupation%')                                                                                           
 INSERT INTO aid_answers (sub_question_id, content, image_url) VALUES                                                                                                                              
 ((SELECT id FROM occupation_q), 'Propriétaire occupant', 'proprietaire_occupant'),                                                                                                                     
 ((SELECT id FROM occupation_q), 'Propriétaire bailleur', 'proprietaire_bailleur'),                                                                                                                     
 ((SELECT id FROM occupation_q), 'Locataire', 'locataire'),                                                                                                                                                 
 ((SELECT id FROM occupation_q), 'Copropriétaire', 'copropriete');                                                                                                                                            
                                                                                                                                                                                        
 -- Étape 1, Question 2 (Aides Anah)                                                                                                                                                    
 WITH anah_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%Anah%')                                                                                                           
 INSERT INTO aid_answers (sub_question_id, content, image_url) VALUES                                                                                                                              
 ((SELECT id FROM anah_q), 'Oui', 'check'),                                                                                                                                                       
 ((SELECT id FROM anah_q), 'Non', 'cross');                                                                                                                                                       
                                                                                                                                                                                        
 -- Étape 2, Question 1 (Âge logement)                                                                                                                                                  
 WITH age_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%âge de votre logement%')                                                                                          
 INSERT INTO aid_answers (sub_question_id, content, image_url) VALUES                                                                                                                              
 ((SELECT id FROM age_q), 'Moins de 15 ans', 'maison_recente'),                                                                                                                                           
 ((SELECT id FROM age_q), 'Plus de 15 ans', 'maison_ancienne');                                                                                                                                            
                                                                                                                                                                                        
 -- Étape 2, Question 3 (Étiquette énergétique)                                                                                                                                         
 WITH dpe_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%étiquette énergétique%')                                                                                          
 INSERT INTO aid_answers (sub_question_id, content, image_url) VALUES                                                                                                                              
 ((SELECT id FROM dpe_q), 'A ou B', 'dpe_ab'),                                                                                                                                                    
 ((SELECT id FROM dpe_q), 'C ou D', 'dpe_cd'),                                                                                                                                                    
 ((SELECT id FROM dpe_q), 'E', 'dpe_e'),                                                                                                                                                         
 ((SELECT id FROM dpe_q), 'F ou G', 'dpe_fg'),                                                                                                                                                    
 ((SELECT id FROM dpe_q), 'Je ne sais pas', 'question');                                                                                                                                            
                                                                                                                                                                                        
 -- Étape 2, Question 4 (Diagnostic énergétique)                                                                                                                                        
 WITH diagnostic_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%diagnostic énergétique%')                                                                                         
 INSERT INTO aid_answers (sub_question_id, content, image_url) VALUES                                                                                                                              
 ((SELECT id FROM diagnostic_q), 'Oui', 'check'),                                                                                                                                                       
 ((SELECT id FROM diagnostic_q), 'Non', 'cross');                                                                                                                                                       
                                                                                                                                                                                        
 -- Étape 4, Question 1 (Type de travaux)                                                                                                                                               
 WITH travaux_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%type de travaux%')                                                                                                
 INSERT INTO aid_answers (sub_question_id, content, image_url) VALUES                                                                                                                              
 ((SELECT id FROM travaux_q), 'Isolation (murs, combles, planchers)', 'isolation'),                                                                                                                      
 ((SELECT id FROM travaux_q), 'Chauffage', 'chauffage'),                                                                                                                                                 
 ((SELECT id FROM travaux_q), 'Ventilation', 'ventilation'),                                                                                                                                               
 ((SELECT id FROM travaux_q), 'Fenêtres', 'fenetre'),                                                                                                                                                  
 ((SELECT id FROM travaux_q), 'Rénovation globale', 'renovation');                                                                                                                                        
                                                                                                                                                                                        
 -- Étape 4, Question 2 (Matériaux biosourcés)                                                                                                                                          
 WITH materiaux_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%biosourcés%')                                                                                                     
 INSERT INTO aid_answers (sub_question_id, content, image_url) VALUES                                                                                                                              
 ((SELECT id FROM materiaux_q), 'Oui', 'check'),                                                                                                                                                       
 ((SELECT id FROM materiaux_q), 'Non', 'cross');   
