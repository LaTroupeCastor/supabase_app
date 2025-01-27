alter table "public"."aid_requests" drop constraint "aid_requests_user_id_fkey";

alter table "public"."aid_requests" drop constraint "aid_requests_pkey";

drop index if exists "public"."aid_requests_pkey";

create table "public"."help" (
    "id" uuid not null default gen_random_uuid(),
    "email" character varying(255) not null,
    "subject" character varying(255) not null,
    "message" text not null,
    "user_id" uuid,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP
);


alter table "public"."aid_simulation" add column "token_expiration" timestamp with time zone;

CREATE UNIQUE INDEX aid_requests_pkey ON public.help USING btree (id);

alter table "public"."help" add constraint "aid_requests_pkey" PRIMARY KEY using index "aid_requests_pkey";

alter table "public"."aid_requests" add constraint "aid_requests_user_id_fkey1" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL not valid;

alter table "public"."aid_requests" validate constraint "aid_requests_user_id_fkey1";

alter table "public"."help" add constraint "aid_requests_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL not valid;

alter table "public"."help" validate constraint "aid_requests_user_id_fkey";

alter table "public"."aid_requests" add constraint "aid_requests_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) not valid;

alter table "public"."aid_requests" validate constraint "aid_requests_user_id_fkey";


