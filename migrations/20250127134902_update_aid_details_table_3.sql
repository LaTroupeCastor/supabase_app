create type "public"."energy_label_type" as enum ('a_or_b', 'c_or_d', 'e', 'f_or_g', 'unknown');

create type "public"."occupancy_status_type" as enum ('owner_occupant', 'owner_lessor', 'tenant', 'co_owner');

create table "public"."aid_simulation_work_types" (
    "id" uuid not null default gen_random_uuid(),
    "simulation_id" uuid,
    "work_type" work_type not null,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP
);


alter table "public"."aid_details" add column "building_age_condition" integer;

alter table "public"."aid_details" add column "department" character varying(3);

alter table "public"."aid_simulation" add column "anah_aid_last_5_years" boolean;

alter table "public"."aid_simulation" add column "biosourced_materials" boolean;

alter table "public"."aid_simulation" add column "building_age_over_15" boolean;

alter table "public"."aid_simulation" add column "energy_diagnostic_done" boolean;

alter table "public"."aid_simulation" add column "energy_label" energy_label_type;

alter table "public"."aid_simulation" add column "fiscal_income" numeric(12,2);

alter table "public"."aid_simulation" add column "living_area" numeric(8,2);

alter table "public"."aid_simulation" add column "occupancy_status" occupancy_status_type;

CREATE UNIQUE INDEX aid_simulation_work_types_pkey ON public.aid_simulation_work_types USING btree (id);

CREATE INDEX idx_aid_details_department ON public.aid_details USING btree (department);

CREATE INDEX idx_aid_simulation_energy_label ON public.aid_simulation USING btree (energy_label);

CREATE INDEX idx_aid_simulation_fiscal_income ON public.aid_simulation USING btree (fiscal_income);

CREATE INDEX idx_aid_simulation_work_types ON public.aid_simulation_work_types USING btree (simulation_id);

alter table "public"."aid_simulation_work_types" add constraint "aid_simulation_work_types_pkey" PRIMARY KEY using index "aid_simulation_work_types_pkey";

alter table "public"."aid_simulation_work_types" add constraint "aid_simulation_work_types_simulation_id_fkey" FOREIGN KEY (simulation_id) REFERENCES aid_simulation(id) ON DELETE CASCADE not valid;

alter table "public"."aid_simulation_work_types" validate constraint "aid_simulation_work_types_simulation_id_fkey";

create or replace view "public"."complete_aid_simulation" as  SELECT s.id,
    s.current_step,
    s.session_token,
    s.expiration_date,
    s.created_at,
    s.updated_at,
    s.department,
    s.email,
    s.occupancy_status,
    s.building_age_over_15,
    s.fiscal_income,
    s.energy_label,
    s.anah_aid_last_5_years,
    s.living_area,
    s.biosourced_materials,
    s.energy_diagnostic_done,
    array_agg(awt.work_type) AS selected_work_types
   FROM (aid_simulation s
     LEFT JOIN aid_simulation_work_types awt ON ((s.id = awt.simulation_id)))
  GROUP BY s.id;



