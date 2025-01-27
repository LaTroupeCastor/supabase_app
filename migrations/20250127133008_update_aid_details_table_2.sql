alter table "public"."aid_details" drop column "amount";

alter table "public"."aid_details" add column "default_amount" numeric(12,2);

CREATE INDEX idx_aid_details_income_range ON public.aid_details USING btree (min_income, max_income);


