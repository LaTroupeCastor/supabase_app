alter type "public"."energy_label_type" rename to "energy_label_type__old_version_to_be_dropped";

create type "public"."energy_label_type" as enum ('A_B', 'C_D', 'E', 'F_G', 'UNKNOWN');

alter table "public"."aid_simulation" alter column energy_label type "public"."energy_label_type" using energy_label::text::"public"."energy_label_type";

drop type "public"."energy_label_type__old_version_to_be_dropped";


