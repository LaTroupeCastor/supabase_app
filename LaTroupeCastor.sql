-- ##########################################
-- 1. ENUMERATED TYPES
-- ##########################################

CREATE TYPE "preferred_languages" AS ENUM (
  'french',  
  'english'      
);
                                                                                                                                                                                        
-- Notification status
CREATE TYPE "notification_status" AS ENUM (                                                                                                                                            
  'active',     
  'disabled'   
);                                                                                                                                                                                     
                                                                                                                                                                                        
-- Construction site progress status
CREATE TYPE "site_status" AS ENUM (                                                                                                                                                
  'pending_validation',  
  'rejected',               
  'document_required',   
  'sent'               
);                                                                                                                                                                                     
                                                                                                                                                                                        
-- Conversation status
CREATE TYPE "conversation_status" AS ENUM (                                                                                                                                            
  'active',                                                                                                                                                                           
  'archived',                                                                                                                                                                          
  'closed'                                                                                                                                                                              
);                                                                                                                                                                                     
                                                                                                                                                                                        
-- Available housing types
CREATE TYPE "housing_type" AS ENUM (                                                                                                                                                  
  'house',                                                                                                                                                                         
  'apartment'                                                                                                                                                                  
);                                                                                                                                                                                     
                                                                                                                                                                                        
-- User roles in the system
CREATE TYPE "user_role" AS ENUM (                                                                                                                                               
  'craftsman',                                                                                                                                                                        
  'client',                                                                                                                                                                     
  'mediator',                                                                                                                                                                 
  'administrator'                                                                                                                                                               
);                                                                                                                                                                                     
                                                                                                                                                                                        
-- Event types in the news feed
CREATE TYPE "news_type" AS ENUM (                                                                                                                                                 
  'craftsman_update',      -- Craftsman profile modification                                                                                                                                                               
  'mediator_message',      -- New mediator message                                                                                                                                                                
  'status_change',         -- Construction site status modification                                                                                                                                                                
  'document_added'         -- New document uploaded                                                                                                                                                                    
);                                                                                                                                                                                     
                                                                                                                                                                                        
-- 2. Independent Tables (without foreign keys)                                                                                                                                         
CREATE TABLE "addresses" (                                                                                                                                                              
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "address_line1" varchar(255) NOT NULL,                                                                                                                                                      
  "address_line2" varchar(255),                                                                                                                                                               
  "city" varchar(100) NOT NULL,                                                                                                                                                       
  "department" varchar(100),                                                                                                                                                          
  "postal_code" varchar(10) NOT NULL,                                                                                                                                                  
  "country" varchar(100) NOT NULL,                                                                                                                                                        
  "geom" geometry(Point, 4326), -- Replaces "coordinates point" 
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "housings" (                                                                                                                                                             
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "type" housing_type NOT NULL,                                                                                                                                                       
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "aid_details" (                                                                                                                                                          
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "name" varchar(100) NOT NULL,                                                                                                                                                         
  "description" text NOT NULL,                                                                                                                                                         
  "amount" decimal(10,2),                                                                                                                                                             
  "eligibility_criteria" text,                                                                                                                                                         
  "funding_organization" varchar(100) NOT NULL,                                                                                                                                         
  "validity_start_date" timestamp with time zone,                                                                                                                                      
  "validity_end_date" timestamp with time zone,                                                                                                                                        
  "required_documents" text[],                                                                                                                                                           
  "payment_conditions" text,                                                                                                                                                         
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "aid_questions" (                                                                                                                                                        
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "step_number" integer NOT NULL,                                                                                                                                                     
  "title" varchar(255) NOT NULL,                                                                                                                                                       
  "description" text,                                                                                                                                                                  
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
-- 3. Tables with Simple Dependencies                                                                                                                                                  
CREATE TABLE "aid_simulation" (                                                                                                                                                       
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "current_step" integer NOT NULL,                                                                                                                                                   
  "session_token" varchar(255) NOT NULL UNIQUE,                                                                                                                                        
  "expiration_date" timestamp with time zone NOT NULL,                                                                                                                                 
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "department" varchar(50) NOT NULL,                                                                                                                                                  
  "email" varchar(255) NOT NULL                                                                                                                                                        
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "users" (                                                                                                                                                          
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),        -- Unique user identifier                                                                                                             
  "first_name" varchar(50) NOT NULL,                      -- User's first name                                                                                                                
  "last_name" varchar(50) NOT NULL,                       -- User's last name                                                                                                               
  "username" varchar(50) NOT NULL UNIQUE,                 -- Unique login identifier                                                                                                                
  "phone" varchar(20),                                    -- Phone number (optional)                                                                                                          
  "email" varchar(255) NOT NULL UNIQUE,                   -- Main email address                                                                                                                      
  "password_hash" varchar(255) NOT NULL,                  -- Secure password hash                                                                                                                               
  "role" user_role NOT NULL,                              -- Role defining permissions                                                                                                                        
  "profile_photo_url" varchar(255),                       -- Link to profile photo (optional)                                                                                                                                     
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "address_id" uuid REFERENCES addresses(id) ON DELETE SET NULL,          -- Link to main address                                                                                              
  "aid_simulation_id" uuid REFERENCES aid_simulation(id) ON DELETE SET NULL,    -- Link to ongoing aid simulation                                                                                     
  CONSTRAINT "email_valid" CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')    -- Email format validation                                                                    
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "preferences" (                                                                                                                                                           
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "user_id" uuid REFERENCES users(id) ON DELETE CASCADE,                                                                                                                 
  "notification_type" varchar(50) NOT NULL,                                                                                                                                            
  "is_active" boolean DEFAULT true,                                                                                                                                                   
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
-- Update users to add a reference to preferences                                                
ALTER TABLE users ADD COLUMN preferences_id uuid REFERENCES preferences(id) ON DELETE SET NULL;                                                                                 
                                                                                                                                                                                        
CREATE TABLE "construction_sites" (                                                                                                                                                             
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                    -- Unique construction site identifier                                                                                                                                     
  "housing_id" uuid REFERENCES housings(id) ON DELETE CASCADE NOT NULL,    -- Link to housing details                                                                                              
  "status" site_status NOT NULL DEFAULT 'pending_validation',    -- Construction site progress status                                                                                                                     
  "address_id" uuid REFERENCES addresses(id) ON DELETE CASCADE NOT NULL,    -- Site location                                                                                                
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,    -- Construction site creation date                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP     -- Last modification date                                                                                                      
);

-- (Previous translations continue...)

CREATE TABLE "notifications" (                                                                                                                                                         
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "user_id" uuid REFERENCES users(id) ON DELETE CASCADE,                                                                                                                 
  "type" varchar(50) NOT NULL,                                                                                                                                                         
  "content" text NOT NULL,                                                                                                                                                             
  "status" notification_status NOT NULL DEFAULT 'active',                                                                                                                              
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "preference_id" uuid REFERENCES preferences(id) ON DELETE CASCADE                                                                                                                    
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "conversations" (                                                                                                                                                         
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                    -- Unique conversation identifier                                                                                                                                     
  "client_id" uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,    -- Participating client user                                                                                             
  "mediator_id" uuid REFERENCES users(id) ON DELETE SET NULL,         -- Assigned mediator (optional)                                                                                                           
  "status" conversation_status NOT NULL DEFAULT 'active',             -- Conversation status                                                                                                              
  "construction_site_id" uuid REFERENCES construction_sites(id) ON DELETE CASCADE NOT NULL,     -- Related construction site                                                                                              
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,    -- Creation date                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP     -- Last modification date                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "messages" (                                                                                                                                                              
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                    -- Unique message identifier                                                                                                                                     
  "conversation_id" uuid REFERENCES conversations(id) ON DELETE CASCADE,    -- Parent conversation                                                                                                               
  "sender_id" uuid REFERENCES users(id) ON DELETE SET NULL,           -- Message author                                                                                                                 
  "content" text NOT NULL,                                            -- Message body                                                                                                                                             
  "read_at" timestamp with time zone,                                 -- Reading date                                                                                                                                    
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,    -- Sending date                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP     -- Last modification date                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "site_participants" (                                                                                                                                                 
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "participant_id" uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,                                                                                                        
  "construction_site_id" uuid REFERENCES construction_sites(id) ON DELETE CASCADE NOT NULL,                                                                                                              
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "aid_question_options" (                                                                                                                                                 
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "question_id" uuid REFERENCES aid_questions(id) ON DELETE CASCADE NOT NULL,                                                                                                         
  "resource_url" varchar(255),                                                                                                                                                        
  "content" text NOT NULL,                                                                                                                                                             
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "aid_simulation_steps" (                                                                                                                                                
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "simulation_id" uuid REFERENCES aid_simulation(id) ON DELETE CASCADE NOT NULL,                                                                                                      
  "step_number" integer NOT NULL,                                                                                                                                                     
  "completion_date" timestamp with time zone NOT NULL                                                                                                                                  
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "blog_articles" (                                                                                                                                                         
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "title" varchar(255) NOT NULL,                                                                                                                                                       
  "description" text,                                                                                                                                                                  
  "content" text NOT NULL,                                                                                                                                                             
  "aid_id" uuid REFERENCES aid_details(id) ON DELETE SET NULL,                                                                                                                       
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "construction_site_aids" (                                                                                                                                                        
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "aid_detail_id" uuid REFERENCES aid_details(id) ON DELETE CASCADE NOT NULL,                                                                                                        
  "construction_site_id" uuid REFERENCES construction_sites(id) ON DELETE CASCADE NOT NULL,                                                                                                              
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "attached_files" (                                                                                                                                                       
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "file_name" varchar(255) NOT NULL,                                                                                                                                                 
  "file_url" varchar(255) NOT NULL,                                                                                                                                                 
  "mime_type" varchar(100) NOT NULL,                                                                                                                                                   
  "size" bigint NOT NULL,                                                                                                                                                            
  "construction_site_aid_id" uuid REFERENCES construction_site_aids(id) ON DELETE CASCADE NOT NULL,                                                                                                    
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "refresh_tokens" (                                                                                                                                               
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "user_id" uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,                                                                                                        
  "token_hash" varchar(255) NOT NULL,                                                                                                                                                  
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,                                                                                                                     
  "expiration_date" timestamp with time zone NOT NULL                                                                                                                                  
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "aid_requests" (                                                                                                                                                         
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "email" varchar(255) NOT NULL,                                                                                                                                                       
  "subject" varchar(255) NOT NULL,                                                                                                                                                       
  "message" text NOT NULL,                                                                                                                                                             
  "user_id" uuid REFERENCES users(id) ON DELETE SET NULL,                                                                                                                
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
CREATE TABLE "construction_site_news" (                                                                                                                                                   
  "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),                                                                                                                                     
  "construction_site_id" uuid REFERENCES construction_sites(id) ON DELETE CASCADE NOT NULL,                                                                                                              
  "author_id" uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,                                                                                                             
  "type" news_type NOT NULL,                                                                                                                                                      
  "title" varchar(255) NOT NULL,                                                                                                                                                       
  "content" text NOT NULL,                                                                                                                                                             
  "media_url" varchar(255),                                                                                                                                                            
  "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP                                                                                                                      
);                                                                                                                                                                                     
                                                                                                                                                                                        
-- 5. Indexes                                                                                                                                                                            
CREATE INDEX idx_users_email ON users(email);                                                                                                                            
CREATE INDEX idx_users_username ON users(username);                                                                                                        
CREATE INDEX idx_construction_sites_status ON construction_sites(status);                                                                                                                                
CREATE INDEX idx_messages_conversation ON messages(conversation_id);                                                                                                                   
CREATE INDEX idx_conversations_construction_site ON conversations(construction_site_id);
CREATE INDEX idx_addresses_geom ON addresses USING GIST (geom);