alter table "public"."aid_simulation" enable row level security;

create policy "Accès public aux simulations"
on "public"."aid_simulation"
as permissive
for all
to public
using (true)
with check (true);


create policy "Utilisateurs peuvent créer une simulation"
on "public"."aid_simulation"
as permissive
for insert
to public
with check (true);


create policy "Utilisateurs peuvent modifier leur simulation"
on "public"."aid_simulation"
as permissive
for update
to public
using ((id IN ( SELECT users.aid_simulation_id
   FROM users
  WHERE (users.id = auth.uid()))))
with check ((id IN ( SELECT users.aid_simulation_id
   FROM users
  WHERE (users.id = auth.uid()))));



