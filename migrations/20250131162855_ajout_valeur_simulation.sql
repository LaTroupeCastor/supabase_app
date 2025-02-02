create type "public"."fiscal_income_type" as enum ('very_low', 'low', 'medium', 'high', 'very_high');

create type "public"."type_sub_question" as enum ('anah', 'biosourced', 'building_age', 'energy_diagnostic', 'energy_label', 'fiscal_income', 'living_area', 'occupancy_status', 'work_type');

drop index if exists "public"."idx_aid_simulation_fiscal_income";

alter table "public"."aid_answers" add column "value" text;

alter table "public"."aid_simulation" add column "current_sub_step" integer not null;

alter table "public"."aid_simulation" add column "work_type" work_type;

alter table "public"."aid_sub_questions" add column "type_sub_questions" type_sub_question;


