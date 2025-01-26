

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "postgis" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."langues_preferees" AS ENUM (
    'francais',
    'anglais'
);


ALTER TYPE "public"."langues_preferees" OWNER TO "postgres";


CREATE TYPE "public"."role_utilisateur" AS ENUM (
    'artisan',
    'client',
    'mediateur',
    'administrateur'
);


ALTER TYPE "public"."role_utilisateur" OWNER TO "postgres";


CREATE TYPE "public"."statut_chantier" AS ENUM (
    'en_cours_validation',
    'refuse',
    'document_a_fournir',
    'envoye'
);


ALTER TYPE "public"."statut_chantier" OWNER TO "postgres";


CREATE TYPE "public"."statut_conversation" AS ENUM (
    'active',
    'archivee',
    'fermee'
);


ALTER TYPE "public"."statut_conversation" OWNER TO "postgres";


CREATE TYPE "public"."statut_notification" AS ENUM (
    'active',
    'desactive'
);


ALTER TYPE "public"."statut_notification" OWNER TO "postgres";


CREATE TYPE "public"."type_actualite" AS ENUM (
    'mise_a_jour_artisan',
    'message_mediateur',
    'changement_statut',
    'ajout_document'
);


ALTER TYPE "public"."type_actualite" OWNER TO "postgres";


CREATE TYPE "public"."type_logement" AS ENUM (
    'maison',
    'appartement'
);


ALTER TYPE "public"."type_logement" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."actualites_chantier" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "chantier_id" "uuid" NOT NULL,
    "auteur_id" "uuid" NOT NULL,
    "type" "public"."type_actualite" NOT NULL,
    "titre" character varying(255) NOT NULL,
    "contenu" "text" NOT NULL,
    "url_media" character varying(255),
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."actualites_chantier" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."adresses" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "ligne1" character varying(255) NOT NULL,
    "ligne2" character varying(255),
    "ville" character varying(100) NOT NULL,
    "departement" character varying(100),
    "code_postal" character varying(10) NOT NULL,
    "pays" character varying(100) NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "geom" "extensions"."geometry"(Point,4326)
);


ALTER TABLE "public"."adresses" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."aide_details" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nom" character varying(100) NOT NULL,
    "description" "text" NOT NULL,
    "montant" numeric(10,2),
    "criteres_eligibilite" "text",
    "organisme_financeur" character varying(100) NOT NULL,
    "date_debut_validite" timestamp with time zone,
    "date_fin_validite" timestamp with time zone,
    "documents_requis" "text"[],
    "conditions_versement" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."aide_details" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."aides_chantier" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "aide_detail_id" "uuid" NOT NULL,
    "chantier_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."aides_chantier" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."articles_blog" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "titre" character varying(255) NOT NULL,
    "description" "text",
    "contenu" "text" NOT NULL,
    "aide_id" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."articles_blog" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."chantiers" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "logement_id" "uuid" NOT NULL,
    "statut" "public"."statut_chantier" DEFAULT 'en_cours_validation'::"public"."statut_chantier" NOT NULL,
    "adresse_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."chantiers" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."conversations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "client_id" "uuid" NOT NULL,
    "mediateur_id" "uuid",
    "statut" "public"."statut_conversation" DEFAULT 'active'::"public"."statut_conversation" NOT NULL,
    "chantier_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."conversations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."demandes_aide" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "email" character varying(255) NOT NULL,
    "sujet" character varying(255) NOT NULL,
    "message" "text" NOT NULL,
    "utilisateur_id" "uuid",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."demandes_aide" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."etapes_simulation_aide" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "simulation_id" "uuid" NOT NULL,
    "numero_etape" integer NOT NULL,
    "date_completion" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."etapes_simulation_aide" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."fichiers_joints" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nom_fichier" character varying(255) NOT NULL,
    "url_fichier" character varying(255) NOT NULL,
    "type_mime" character varying(100) NOT NULL,
    "taille" bigint NOT NULL,
    "aide_chantier_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."fichiers_joints" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."intervenants_chantier" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "intervenant_id" "uuid" NOT NULL,
    "chantier_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."intervenants_chantier" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."jetons_rafraichissement" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "utilisateur_id" "uuid" NOT NULL,
    "jeton_hash" character varying(255) NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "date_expiration" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."jetons_rafraichissement" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."logements" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "type" "public"."type_logement" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."logements" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."messages" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "conversation_id" "uuid",
    "expediteur_id" "uuid",
    "contenu" "text" NOT NULL,
    "lu_le" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."messages" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "utilisateur_id" "uuid",
    "type" character varying(50) NOT NULL,
    "contenu" "text" NOT NULL,
    "statut" "public"."statut_notification" DEFAULT 'active'::"public"."statut_notification" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "preference_id" "uuid"
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."options_question_aide" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "question_id" "uuid" NOT NULL,
    "url_ressource" character varying(255),
    "contenu" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."options_question_aide" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."preferences" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "utilisateur_id" "uuid",
    "type_notification" character varying(50) NOT NULL,
    "est_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."preferences" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."questions_aide" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "numero_etape" integer NOT NULL,
    "titre" character varying(255) NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."questions_aide" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."simulation_aide" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "etape_courante" integer NOT NULL,
    "jeton_session" character varying(255) NOT NULL,
    "date_expiration" timestamp with time zone NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "departement" character varying(50) NOT NULL,
    "email" character varying(255) NOT NULL
);


ALTER TABLE "public"."simulation_aide" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."utilisateurs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "prenom" character varying(50) NOT NULL,
    "nom" character varying(50) NOT NULL,
    "nom_utilisateur" character varying(50) NOT NULL,
    "telephone" character varying(20),
    "email" character varying(255) NOT NULL,
    "mot_de_passe_hash" character varying(255) NOT NULL,
    "role" "public"."role_utilisateur" NOT NULL,
    "url_photo_profil" character varying(255),
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "adresse_id" "uuid",
    "simulation_aide_id" "uuid",
    "preferences_id" "uuid",
    CONSTRAINT "email_valide" CHECK ((("email")::"text" ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::"text"))
);


ALTER TABLE "public"."utilisateurs" OWNER TO "postgres";


ALTER TABLE ONLY "public"."actualites_chantier"
    ADD CONSTRAINT "actualites_chantier_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."adresses"
    ADD CONSTRAINT "adresses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."aide_details"
    ADD CONSTRAINT "aide_details_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."aides_chantier"
    ADD CONSTRAINT "aides_chantier_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."articles_blog"
    ADD CONSTRAINT "articles_blog_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."chantiers"
    ADD CONSTRAINT "chantiers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."conversations"
    ADD CONSTRAINT "conversations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."demandes_aide"
    ADD CONSTRAINT "demandes_aide_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."etapes_simulation_aide"
    ADD CONSTRAINT "etapes_simulation_aide_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."fichiers_joints"
    ADD CONSTRAINT "fichiers_joints_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."intervenants_chantier"
    ADD CONSTRAINT "intervenants_chantier_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."jetons_rafraichissement"
    ADD CONSTRAINT "jetons_rafraichissement_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."logements"
    ADD CONSTRAINT "logements_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."options_question_aide"
    ADD CONSTRAINT "options_question_aide_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."preferences"
    ADD CONSTRAINT "preferences_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."questions_aide"
    ADD CONSTRAINT "questions_aide_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."simulation_aide"
    ADD CONSTRAINT "simulation_aide_jeton_session_key" UNIQUE ("jeton_session");



ALTER TABLE ONLY "public"."simulation_aide"
    ADD CONSTRAINT "simulation_aide_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."utilisateurs"
    ADD CONSTRAINT "utilisateurs_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."utilisateurs"
    ADD CONSTRAINT "utilisateurs_nom_utilisateur_key" UNIQUE ("nom_utilisateur");



ALTER TABLE ONLY "public"."utilisateurs"
    ADD CONSTRAINT "utilisateurs_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_adresses_geom" ON "public"."adresses" USING "gist" ("geom");



CREATE INDEX "idx_chantiers_statut" ON "public"."chantiers" USING "btree" ("statut");



CREATE INDEX "idx_conversations_chantier" ON "public"."conversations" USING "btree" ("chantier_id");



CREATE INDEX "idx_messages_conversation" ON "public"."messages" USING "btree" ("conversation_id");



CREATE INDEX "idx_utilisateurs_email" ON "public"."utilisateurs" USING "btree" ("email");



CREATE INDEX "idx_utilisateurs_nom_utilisateur" ON "public"."utilisateurs" USING "btree" ("nom_utilisateur");



ALTER TABLE ONLY "public"."actualites_chantier"
    ADD CONSTRAINT "actualites_chantier_auteur_id_fkey" FOREIGN KEY ("auteur_id") REFERENCES "public"."utilisateurs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."actualites_chantier"
    ADD CONSTRAINT "actualites_chantier_chantier_id_fkey" FOREIGN KEY ("chantier_id") REFERENCES "public"."chantiers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."aides_chantier"
    ADD CONSTRAINT "aides_chantier_aide_detail_id_fkey" FOREIGN KEY ("aide_detail_id") REFERENCES "public"."aide_details"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."aides_chantier"
    ADD CONSTRAINT "aides_chantier_chantier_id_fkey" FOREIGN KEY ("chantier_id") REFERENCES "public"."chantiers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."articles_blog"
    ADD CONSTRAINT "articles_blog_aide_id_fkey" FOREIGN KEY ("aide_id") REFERENCES "public"."aide_details"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."chantiers"
    ADD CONSTRAINT "chantiers_adresse_id_fkey" FOREIGN KEY ("adresse_id") REFERENCES "public"."adresses"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chantiers"
    ADD CONSTRAINT "chantiers_logement_id_fkey" FOREIGN KEY ("logement_id") REFERENCES "public"."logements"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."conversations"
    ADD CONSTRAINT "conversations_chantier_id_fkey" FOREIGN KEY ("chantier_id") REFERENCES "public"."chantiers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."conversations"
    ADD CONSTRAINT "conversations_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "public"."utilisateurs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."conversations"
    ADD CONSTRAINT "conversations_mediateur_id_fkey" FOREIGN KEY ("mediateur_id") REFERENCES "public"."utilisateurs"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."demandes_aide"
    ADD CONSTRAINT "demandes_aide_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateurs"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."etapes_simulation_aide"
    ADD CONSTRAINT "etapes_simulation_aide_simulation_id_fkey" FOREIGN KEY ("simulation_id") REFERENCES "public"."simulation_aide"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."fichiers_joints"
    ADD CONSTRAINT "fichiers_joints_aide_chantier_id_fkey" FOREIGN KEY ("aide_chantier_id") REFERENCES "public"."aides_chantier"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."intervenants_chantier"
    ADD CONSTRAINT "intervenants_chantier_chantier_id_fkey" FOREIGN KEY ("chantier_id") REFERENCES "public"."chantiers"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."intervenants_chantier"
    ADD CONSTRAINT "intervenants_chantier_intervenant_id_fkey" FOREIGN KEY ("intervenant_id") REFERENCES "public"."utilisateurs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."jetons_rafraichissement"
    ADD CONSTRAINT "jetons_rafraichissement_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateurs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "public"."conversations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_expediteur_id_fkey" FOREIGN KEY ("expediteur_id") REFERENCES "public"."utilisateurs"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_preference_id_fkey" FOREIGN KEY ("preference_id") REFERENCES "public"."preferences"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateurs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."options_question_aide"
    ADD CONSTRAINT "options_question_aide_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."questions_aide"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."preferences"
    ADD CONSTRAINT "preferences_utilisateur_id_fkey" FOREIGN KEY ("utilisateur_id") REFERENCES "public"."utilisateurs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."utilisateurs"
    ADD CONSTRAINT "utilisateurs_adresse_id_fkey" FOREIGN KEY ("adresse_id") REFERENCES "public"."adresses"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."utilisateurs"
    ADD CONSTRAINT "utilisateurs_preferences_id_fkey" FOREIGN KEY ("preferences_id") REFERENCES "public"."preferences"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."utilisateurs"
    ADD CONSTRAINT "utilisateurs_simulation_aide_id_fkey" FOREIGN KEY ("simulation_aide_id") REFERENCES "public"."simulation_aide"("id") ON DELETE SET NULL;





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































GRANT ALL ON TABLE "public"."actualites_chantier" TO "anon";
GRANT ALL ON TABLE "public"."actualites_chantier" TO "authenticated";
GRANT ALL ON TABLE "public"."actualites_chantier" TO "service_role";



GRANT ALL ON TABLE "public"."adresses" TO "anon";
GRANT ALL ON TABLE "public"."adresses" TO "authenticated";
GRANT ALL ON TABLE "public"."adresses" TO "service_role";



GRANT ALL ON TABLE "public"."aide_details" TO "anon";
GRANT ALL ON TABLE "public"."aide_details" TO "authenticated";
GRANT ALL ON TABLE "public"."aide_details" TO "service_role";



GRANT ALL ON TABLE "public"."aides_chantier" TO "anon";
GRANT ALL ON TABLE "public"."aides_chantier" TO "authenticated";
GRANT ALL ON TABLE "public"."aides_chantier" TO "service_role";



GRANT ALL ON TABLE "public"."articles_blog" TO "anon";
GRANT ALL ON TABLE "public"."articles_blog" TO "authenticated";
GRANT ALL ON TABLE "public"."articles_blog" TO "service_role";



GRANT ALL ON TABLE "public"."chantiers" TO "anon";
GRANT ALL ON TABLE "public"."chantiers" TO "authenticated";
GRANT ALL ON TABLE "public"."chantiers" TO "service_role";



GRANT ALL ON TABLE "public"."conversations" TO "anon";
GRANT ALL ON TABLE "public"."conversations" TO "authenticated";
GRANT ALL ON TABLE "public"."conversations" TO "service_role";



GRANT ALL ON TABLE "public"."demandes_aide" TO "anon";
GRANT ALL ON TABLE "public"."demandes_aide" TO "authenticated";
GRANT ALL ON TABLE "public"."demandes_aide" TO "service_role";



GRANT ALL ON TABLE "public"."etapes_simulation_aide" TO "anon";
GRANT ALL ON TABLE "public"."etapes_simulation_aide" TO "authenticated";
GRANT ALL ON TABLE "public"."etapes_simulation_aide" TO "service_role";



GRANT ALL ON TABLE "public"."fichiers_joints" TO "anon";
GRANT ALL ON TABLE "public"."fichiers_joints" TO "authenticated";
GRANT ALL ON TABLE "public"."fichiers_joints" TO "service_role";



GRANT ALL ON TABLE "public"."intervenants_chantier" TO "anon";
GRANT ALL ON TABLE "public"."intervenants_chantier" TO "authenticated";
GRANT ALL ON TABLE "public"."intervenants_chantier" TO "service_role";



GRANT ALL ON TABLE "public"."jetons_rafraichissement" TO "anon";
GRANT ALL ON TABLE "public"."jetons_rafraichissement" TO "authenticated";
GRANT ALL ON TABLE "public"."jetons_rafraichissement" TO "service_role";



GRANT ALL ON TABLE "public"."logements" TO "anon";
GRANT ALL ON TABLE "public"."logements" TO "authenticated";
GRANT ALL ON TABLE "public"."logements" TO "service_role";



GRANT ALL ON TABLE "public"."messages" TO "anon";
GRANT ALL ON TABLE "public"."messages" TO "authenticated";
GRANT ALL ON TABLE "public"."messages" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON TABLE "public"."options_question_aide" TO "anon";
GRANT ALL ON TABLE "public"."options_question_aide" TO "authenticated";
GRANT ALL ON TABLE "public"."options_question_aide" TO "service_role";



GRANT ALL ON TABLE "public"."preferences" TO "anon";
GRANT ALL ON TABLE "public"."preferences" TO "authenticated";
GRANT ALL ON TABLE "public"."preferences" TO "service_role";



GRANT ALL ON TABLE "public"."questions_aide" TO "anon";
GRANT ALL ON TABLE "public"."questions_aide" TO "authenticated";
GRANT ALL ON TABLE "public"."questions_aide" TO "service_role";



GRANT ALL ON TABLE "public"."simulation_aide" TO "anon";
GRANT ALL ON TABLE "public"."simulation_aide" TO "authenticated";
GRANT ALL ON TABLE "public"."simulation_aide" TO "service_role";



GRANT ALL ON TABLE "public"."utilisateurs" TO "anon";
GRANT ALL ON TABLE "public"."utilisateurs" TO "authenticated";
GRANT ALL ON TABLE "public"."utilisateurs" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
