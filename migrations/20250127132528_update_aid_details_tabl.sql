alter table "public"."aid_details" drop column "eligibility_criteria";

alter table "public"."aid_details" drop column "payment_conditions";

alter table "public"."aid_details" drop column "validity_end_date";

alter table "public"."aid_details" drop column "validity_start_date";

alter table "public"."aid_details" add column "allowed_work_types" work_type[];

alter table "public"."aid_details" add column "building_age_over_15" boolean;

alter table "public"."aid_details" add column "cumulative" boolean default true;

alter table "public"."aid_details" add column "max_amount" numeric(12,2);

alter table "public"."aid_details" add column "max_income" numeric(12,2);

alter table "public"."aid_details" add column "min_energy_gain" integer;

alter table "public"."aid_details" add column "min_income" numeric(12,2);

alter table "public"."aid_details" add column "occupancy_status_required" text[];


