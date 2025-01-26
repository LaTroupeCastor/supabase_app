-- ##########################################
-- 1. TYPES ÉNUMÉRÉS
-- ##########################################

CREATE TYPE "langues_preferees" AS ENUM (
  'francais',  
  'anglais'      
);
                                                                                                                                                                                        
 -- État des notifications
 CREATE TYPE "statut_notification" AS ENUM (                                                                                                                                            
   'active',     
   'desactive'   
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- État d'avancement des chantiers
 CREATE TYPE "statut_chantier" AS ENUM (                                                                                                                                                
   'en_cours_validation',  
   'refuse',               
   'document_a_fournir',   
   'envoye'               
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- État des conversations
 CREATE TYPE "statut_conversation" AS ENUM (                                                                                                                                            
   'active',                                                                                                                                                                           
   'archivee',                                                                                                                                                                          
   'fermee'                                                                                                                                                                              
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- Types de logement disponibles
 CREATE TYPE "type_logement" AS ENUM (                                                                                                                                                  
   'maison',                                                                                                                                                                         
   'appartement'                                                                                                                                                                  
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- Rôles des utilisateurs dans le système
 CREATE TYPE "role_utilisateur" AS ENUM (                                                                                                                                               
   'artisan',                                                                                                                                                                        
   'client',                                                                                                                                                                     
   'mediateur',                                                                                                                                                                 
   'administrateur'                                                                                                                                                               
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- Types d'événements dans le fil d'actualité
 CREATE TYPE "type_actualite" AS ENUM (                                                                                                                                                 
   'mise_a_jour_artisan',  -- Modification du profil artisan                                                                                                                                                               
   'message_mediateur',    -- Nouveau message du médiateur                                                                                                                                                                
   'changement_statut',    -- Modification du statut du chantier                                                                                                                                                                
   'ajout_document'        -- Nouveau document téléchargé                                                                                                                                                                    
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- 2. Tables indépendantes (sans foreign keys)                                                                                                                                         
 CREATE TABLE "adresses" (                                                                                                                                                              
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "ligne1" varchar(255) NOT NULL,                                                                                                                                                      
   "ligne2" varchar(255),                                                                                                                                                               
   "ville" varchar(100) NOT NULL,                                                                                                                                                       
   "departement" varchar(100),                                                                                                                                                          
   "code_postal" varchar(10) NOT NULL,                                                                                                                                                  
   "pays" varchar(100) NOT NULL,                                                                                                                                                        
   "geom" geometry(Point, 4326), -- Remplace "coordonnees point" 
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "logements" (                                                                                                                                                             
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "type" type_logement NOT NULL,                                                                                                                                                       
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "aide_details" (                                                                                                                                                          
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "nom" varchar(100) NOT NULL,                                                                                                                                                         
   "description" text NOT NULL,                                                                                                                                                         
   "montant" decimal(10,2),                                                                                                                                                             
   "criteres_eligibilite" text,                                                                                                                                                         
   "organisme_financeur" varchar(100) NOT NULL,                                                                                                                                         
   "date_debut_validite" timestamp with time zone,                                                                                                                                      
   "date_fin_validite" timestamp with time zone,                                                                                                                                        
   "documents_requis" text[],                                                                                                                                                           
   "conditions_versement" text,                                                                                                                                                         
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "questions_aide" (                                                                                                                                                        
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "numero_etape" integer NOT NULL,                                                                                                                                                     
   "titre" varchar(255) NOT NULL,                                                                                                                                                       
   "description" text,                                                                                                                                                                  
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- 3. Tables avec dépendances simples                                                                                                                                                  
 CREATE TABLE "simulation_aide" (                                                                                                                                                       
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "etape_courante" integer NOT NULL,                                                                                                                                                   
   "jeton_session" varchar(255) NOT NULL UNIQUE,                                                                                                                                        
   "date_expiration" timestamp with time zone NOT NULL,                                                                                                                                 
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "departement" varchar(50) NOT NULL,                                                                                                                                                  
   "email" varchar(255) NOT NULL                                                                                                                                                        
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "utilisateurs" (                                                                                                                                                          
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),        -- Identifiant unique de l'utilisateur                                                                                                             
   "prenom" varchar(50) NOT NULL,                         -- Prénom de l'utilisateur                                                                                                                
   "nom" varchar(50) NOT NULL,                            -- Nom de famille de l'utilisateur                                                                                                               
   "nom_utilisateur" varchar(50) NOT NULL UNIQUE,         -- Identifiant unique pour la connexion                                                                                                                
   "telephone" varchar(20),                               -- Numéro de téléphone (optionnel)                                                                                                          
   "email" varchar(255) NOT NULL UNIQUE,                  -- Adresse email principale                                                                                                                      
   "mot_de_passe_hash" varchar(255) NOT NULL,            -- Hash sécurisé du mot de passe                                                                                                                               
   "role" role_utilisateur NOT NULL,                     -- Rôle définissant les permissions                                                                                                                        
   "url_photo_profil" varchar(255),                      -- Lien vers la photo de profil (optionnel)                                                                                                                                     
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "adresse_id" uuid REFERENCES adresses(id) ON DELETE SET NULL,          -- Lien vers l'adresse principale                                                                                              
   "simulation_aide_id" uuid REFERENCES simulation_aide(id) ON DELETE SET NULL,    -- Lien vers la simulation d'aide en cours                                                                                     
   CONSTRAINT "email_valide" CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')    -- Validation du format email                                                                    
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "preferences" (                                                                                                                                                           
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "utilisateur_id" uuid REFERENCES utilisateurs(id) ON DELETE CASCADE,                                                                                                                 
   "type_notification" varchar(50) NOT NULL,                                                                                                                                            
   "est_active" boolean DEFAULT true,                                                                                                                                                   
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- Mettre à jour utilisateurs pour ajouter la référence aux préférences                                                                                                                
 ALTER TABLE utilisateurs ADD COLUMN preferences_id uuid REFERENCES preferences(id) ON DELETE SET NULL;                                                                                 
                                                                                                                                                                                        
 CREATE TABLE "chantiers" (                                                                                                                                                             
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                    -- Identifiant unique du chantier                                                                                                                                     
   "logement_id" uuid REFERENCES logements(id) ON DELETE CASCADE NOT NULL,    -- Lien vers les détails du logement concerné                                                                                              
   "statut" statut_chantier NOT NULL DEFAULT 'en_cours_validation',    -- État d'avancement du chantier                                                                                                                     
   "adresse_id" uuid REFERENCES adresses(id) ON DELETE CASCADE NOT NULL,    -- Localisation du chantier                                                                                                
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,    -- Date de création du chantier                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP     -- Dernière modification du chantier                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- 4. Tables avec dépendances multiples                                                                                                                                                
 CREATE TABLE "notifications" (                                                                                                                                                         
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "utilisateur_id" uuid REFERENCES utilisateurs(id) ON DELETE CASCADE,                                                                                                                 
   "type" varchar(50) NOT NULL,                                                                                                                                                         
   "contenu" text NOT NULL,                                                                                                                                                             
   "statut" statut_notification NOT NULL DEFAULT 'active',                                                                                                                              
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "preference_id" uuid REFERENCES preferences(id) ON DELETE CASCADE                                                                                                                    
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "conversations" (                                                                                                                                                         
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                    -- Identifiant unique de la conversation                                                                                                                                     
   "client_id" uuid REFERENCES utilisateurs(id) ON DELETE CASCADE NOT NULL,    -- Utilisateur client participant                                                                                             
   "mediateur_id" uuid REFERENCES utilisateurs(id) ON DELETE SET NULL,         -- Médiateur assigné (optionnel)                                                                                                           
   "statut" statut_conversation NOT NULL DEFAULT 'active',                     -- État de la conversation                                                                                                              
   "chantier_id" uuid REFERENCES chantiers(id) ON DELETE CASCADE NOT NULL,     -- Chantier concerné                                                                                              
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,            -- Date de création                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP             -- Dernière modification                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "messages" (                                                                                                                                                              
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                    -- Identifiant unique du message                                                                                                                                     
   "conversation_id" uuid REFERENCES conversations(id) ON DELETE CASCADE,    -- Conversation parent                                                                                                               
   "expediteur_id" uuid REFERENCES utilisateurs(id) ON DELETE SET NULL,     -- Auteur du message                                                                                                                 
   "contenu" text NOT NULL,                                                 -- Corps du message                                                                                                                                             
   "lu_le" timestamp with time zone,                                        -- Date de lecture                                                                                                                                    
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,         -- Date d'envoi                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP          -- Dernière modification                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "intervenants_chantier" (                                                                                                                                                 
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "intervenant_id" uuid REFERENCES utilisateurs(id) ON DELETE CASCADE NOT NULL,                                                                                                        
   "chantier_id" uuid REFERENCES chantiers(id) ON DELETE CASCADE NOT NULL,                                                                                                              
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "options_question_aide" (                                                                                                                                                 
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "question_id" uuid REFERENCES questions_aide(id) ON DELETE CASCADE NOT NULL,                                                                                                         
   "url_ressource" varchar(255),                                                                                                                                                        
   "contenu" text NOT NULL,                                                                                                                                                             
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "etapes_simulation_aide" (                                                                                                                                                
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "simulation_id" uuid REFERENCES simulation_aide(id) ON DELETE CASCADE NOT NULL,                                                                                                      
   "numero_etape" integer NOT NULL,                                                                                                                                                     
   "date_completion" timestamp with time zone NOT NULL                                                                                                                                  
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "articles_blog" (                                                                                                                                                         
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "titre" varchar(255) NOT NULL,                                                                                                                                                       
   "description" text,                                                                                                                                                                  
   "contenu" text NOT NULL,                                                                                                                                                             
   "aide_id" uuid REFERENCES aide_details(id) ON DELETE SET NULL,                                                                                                                       
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "aides_chantier" (                                                                                                                                                        
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "aide_detail_id" uuid REFERENCES aide_details(id) ON DELETE CASCADE NOT NULL,                                                                                                        
   "chantier_id" uuid REFERENCES chantiers(id) ON DELETE CASCADE NOT NULL,                                                                                                              
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "fichiers_joints" (                                                                                                                                                       
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "nom_fichier" varchar(255) NOT NULL,                                                                                                                                                 
   "url_fichier" varchar(255) NOT NULL,                                                                                                                                                 
   "type_mime" varchar(100) NOT NULL,                                                                                                                                                   
   "taille" bigint NOT NULL,                                                                                                                                                            
   "aide_chantier_id" uuid REFERENCES aides_chantier(id) ON DELETE CASCADE NOT NULL,                                                                                                    
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "jetons_rafraichissement" (                                                                                                                                               
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "utilisateur_id" uuid REFERENCES utilisateurs(id) ON DELETE CASCADE NOT NULL,                                                                                                        
   "jeton_hash" varchar(255) NOT NULL,                                                                                                                                                  
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
   "date_expiration" timestamp with time zone NOT NULL                                                                                                                                  
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "demandes_aide" (                                                                                                                                                         
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "email" varchar(255) NOT NULL,                                                                                                                                                       
   "sujet" varchar(255) NOT NULL,                                                                                                                                                       
   "message" text NOT NULL,                                                                                                                                                             
   "utilisateur_id" uuid REFERENCES utilisateurs(id) ON DELETE SET NULL,                                                                                                                
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 CREATE TABLE "actualites_chantier" (                                                                                                                                                   
   "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
   "chantier_id" uuid REFERENCES chantiers(id) ON DELETE CASCADE NOT NULL,                                                                                                              
   "auteur_id" uuid REFERENCES utilisateurs(id) ON DELETE CASCADE NOT NULL,                                                                                                             
   "type" type_actualite NOT NULL,                                                                                                                                                      
   "titre" varchar(255) NOT NULL,                                                                                                                                                       
   "contenu" text NOT NULL,                                                                                                                                                             
   "url_media" varchar(255),                                                                                                                                                            
   "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
 );                                                                                                                                                                                     
                                                                                                                                                                                        
 -- 5. Index                                                                                                                                                                            
 CREATE INDEX idx_utilisateurs_email ON utilisateurs(email);                                                                                                                            
 CREATE INDEX idx_utilisateurs_nom_utilisateur ON utilisateurs(nom_utilisateur);                                                                                                        
 CREATE INDEX idx_chantiers_statut ON chantiers(statut);                                                                                                                                
 CREATE INDEX idx_messages_conversation ON messages(conversation_id);                                                                                                                   
 CREATE INDEX idx_conversations_chantier ON conversations(chantier_id);
 CREATE INDEX idx_adresses_geom ON adresses USING GIST (geom);                                                                                                                          