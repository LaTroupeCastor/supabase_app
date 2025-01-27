alter table "public"."aid_simulation_steps" drop constraint "aid_simulation_steps_simulation_id_fkey";

alter table "public"."aid_simulation_steps" drop constraint "aid_simulation_steps_pkey";

drop index if exists "public"."aid_simulation_steps_pkey";

drop table "public"."aid_simulation_steps";


