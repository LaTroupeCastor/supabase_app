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
 ((SELECT id FROM step2), 2, 'Quelle est la surface habitable de votre logement ?'),                                                                                                    
 ((SELECT id FROM step2), 3, 'Quelle est l''étiquette énergétique actuelle de votre logement ?'),                                                                                       
 ((SELECT id FROM step2), 4, 'Avez-vous déjà fait réaliser un diagnostic énergétique ?');                                                                                               
                                                                                                                                                                                        
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
 WITH sub_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%statut d''occupation%')                                                                                           
 INSERT INTO aid_answers (sub_question_id, content) VALUES                                                                                                                              
 ((SELECT id FROM sub_q), 'Propriétaire occupant'),                                                                                                                                     
 ((SELECT id FROM sub_q), 'Propriétaire bailleur'),                                                                                                                                     
 ((SELECT id FROM sub_q), 'Locataire'),                                                                                                                                                 
 ((SELECT id FROM sub_q), 'Copropriétaire');                                                                                                                                            
                                                                                                                                                                                        
 -- Étape 1, Question 2 (Aides Anah)                                                                                                                                                    
 WITH sub_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%Anah%')                                                                                                           
 INSERT INTO aid_answers (sub_question_id, content) VALUES                                                                                                                              
 ((SELECT id FROM sub_q), 'Oui'),                                                                                                                                                       
 ((SELECT id FROM sub_q), 'Non');                                                                                                                                                       
                                                                                                                                                                                        
 -- Étape 2, Question 1 (Âge logement)                                                                                                                                                  
 WITH sub_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%âge de votre logement%')                                                                                          
 INSERT INTO aid_answers (sub_question_id, content) VALUES                                                                                                                              
 ((SELECT id FROM sub_q), 'Moins de 15 ans'),                                                                                                                                           
 ((SELECT id FROM sub_q), 'Plus de 15 ans');                                                                                                                                            
                                                                                                                                                                                        
 -- Étape 2, Question 3 (Étiquette énergétique)                                                                                                                                         
 WITH sub_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%étiquette énergétique%')                                                                                          
 INSERT INTO aid_answers (sub_question_id, content) VALUES                                                                                                                              
 ((SELECT id FROM sub_q), 'A ou B'),                                                                                                                                                    
 ((SELECT id FROM sub_q), 'C ou D'),                                                                                                                                                    
 ((SELECT id FROM sub_q), 'E'),                                                                                                                                                         
 ((SELECT id FROM sub_q), 'F ou G'),                                                                                                                                                    
 ((SELECT id FROM sub_q), 'Je ne sais pas');                                                                                                                                            
                                                                                                                                                                                        
 -- Étape 2, Question 4 (Diagnostic énergétique)                                                                                                                                        
 WITH sub_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%diagnostic énergétique%')                                                                                         
 INSERT INTO aid_answers (sub_question_id, content) VALUES                                                                                                                              
 ((SELECT id FROM sub_q), 'Oui'),                                                                                                                                                       
 ((SELECT id FROM sub_q), 'Non');                                                                                                                                                       
                                                                                                                                                                                        
 -- Étape 4, Question 1 (Type de travaux)                                                                                                                                               
 WITH sub_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%type de travaux%')                                                                                                
 INSERT INTO aid_answers (sub_question_id, content) VALUES                                                                                                                              
 ((SELECT id FROM sub_q), 'Isolation (murs, combles, planchers)'),                                                                                                                      
 ((SELECT id FROM sub_q), 'Chauffage'),                                                                                                                                                 
 ((SELECT id FROM sub_q), 'Ventilation'),                                                                                                                                               
 ((SELECT id FROM sub_q), 'Fenêtres'),                                                                                                                                                  
 ((SELECT id FROM sub_q), 'Rénovation globale');                                                                                                                                        
                                                                                                                                                                                        
 -- Étape 4, Question 2 (Matériaux biosourcés)                                                                                                                                          
 WITH sub_q AS (SELECT id FROM aid_sub_questions WHERE content LIKE '%biosourcés%')                                                                                                     
 INSERT INTO aid_answers (sub_question_id, content) VALUES                                                                                                                              
 ((SELECT id FROM sub_q), 'Oui'),                                                                                                                                                       
 ((SELECT id FROM sub_q), 'Non');   
