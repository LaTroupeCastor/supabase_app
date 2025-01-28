alter table "public"."aid_question_options" drop constraint "aid_question_options_question_id_fkey";

alter table "public"."aid_question_options" drop constraint "aid_question_options_pkey";

drop index if exists "public"."aid_question_options_pkey";

drop table "public"."aid_question_options";

create table "public"."aid_answers" (
    "id" uuid not null default gen_random_uuid(),
    "sub_question_id" uuid not null,
    "content" text not null,
    "image_url" character varying,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
);


create table "public"."aid_sub_questions" (
    "id" uuid not null default gen_random_uuid(),
    "question_id" uuid not null,
    "sub_step_number" integer not null,
    "content" text not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
);


alter table "public"."aid_questions" alter column "created_at" set default now();

alter table "public"."aid_questions" alter column "created_at" set not null;

alter table "public"."aid_questions" alter column "title" set data type character varying using "title"::character varying;

alter table "public"."aid_questions" alter column "updated_at" set default now();

alter table "public"."aid_questions" alter column "updated_at" set not null;

CREATE UNIQUE INDEX aid_answers_pkey ON public.aid_answers USING btree (id);

CREATE UNIQUE INDEX aid_sub_questions_pkey ON public.aid_sub_questions USING btree (id);

CREATE INDEX idx_aid_answers_sub_question_id ON public.aid_answers USING btree (sub_question_id);

CREATE INDEX idx_aid_questions_step_number ON public.aid_questions USING btree (step_number);

CREATE INDEX idx_aid_sub_questions_question_id ON public.aid_sub_questions USING btree (question_id);

alter table "public"."aid_answers" add constraint "aid_answers_pkey" PRIMARY KEY using index "aid_answers_pkey";

alter table "public"."aid_sub_questions" add constraint "aid_sub_questions_pkey" PRIMARY KEY using index "aid_sub_questions_pkey";

alter table "public"."aid_answers" add constraint "aid_answers_sub_question_id_fkey" FOREIGN KEY (sub_question_id) REFERENCES aid_sub_questions(id) ON DELETE CASCADE not valid;

alter table "public"."aid_answers" validate constraint "aid_answers_sub_question_id_fkey";

alter table "public"."aid_sub_questions" add constraint "aid_sub_questions_question_id_fkey" FOREIGN KEY (question_id) REFERENCES aid_questions(id) ON DELETE CASCADE not valid;

alter table "public"."aid_sub_questions" validate constraint "aid_sub_questions_question_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$                                                                                                                                                                  
 BEGIN                                                                                                                                                                                  
     NEW.updated_at = NOW();                                                                                                                                                            
     RETURN NEW;                                                                                                                                                                        
 END;                                                                                                                                                                                   
 $function$
;

CREATE TRIGGER update_aid_answers_updated_at BEFORE UPDATE ON public.aid_answers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_aid_questions_updated_at BEFORE UPDATE ON public.aid_questions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_aid_sub_questions_updated_at BEFORE UPDATE ON public.aid_sub_questions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


