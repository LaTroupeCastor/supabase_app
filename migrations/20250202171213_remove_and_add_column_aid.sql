alter table "public"."aid_simulation" drop column "living_area";

alter table "public"."aid_simulation" drop column "token_expiration";

alter table "public"."aid_simulation" add column "first_name" text;

alter table "public"."aid_simulation" add column "last_name" text;

alter table "public"."aid_simulation" alter column "department" drop not null;

alter table "public"."aid_simulation" alter column "department" set data type text using "department"::text;

alter table "public"."aid_simulation" alter column "email" drop not null;


