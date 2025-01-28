alter table "public"."aid_question_options" drop constraint "aid_question_options_question_id_fkey";

alter table "public"."aid_requests" drop constraint "aid_requests_user_id_fkey";

alter table "public"."aid_requests" drop constraint "aid_requests_user_id_fkey1";

alter table "public"."aid_question_options" drop constraint "aid_question_options_pkey";

alter table "public"."aid_questions" drop constraint "aid_questions_pkey";

drop index if exists "public"."aid_question_options_pkey";

drop index if exists "public"."aid_questions_pkey";

drop table "public"."aid_question_options";

drop table "public"."aid_questions";

drop table "public"."aid_requests";


