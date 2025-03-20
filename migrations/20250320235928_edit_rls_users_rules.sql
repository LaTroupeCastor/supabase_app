drop trigger if exists "update_aid_answers_updated_at" on "public"."aid_answers";

drop trigger if exists "update_aid_questions_updated_at" on "public"."aid_questions";

drop trigger if exists "clean_expired_simulations" on "public"."aid_simulation";

drop trigger if exists "update_aid_sub_questions_updated_at" on "public"."aid_sub_questions";

drop policy "Accès public aux simulations" on "public"."aid_simulation";

drop policy "Utilisateurs peuvent créer une simulation" on "public"."aid_simulation";

drop policy "Utilisateurs peuvent modifier leur simulation" on "public"."aid_simulation";

drop policy "Users can manage their own data" on "public"."users";

revoke delete on table "public"."addresses" from "anon";

revoke insert on table "public"."addresses" from "anon";

revoke references on table "public"."addresses" from "anon";

revoke select on table "public"."addresses" from "anon";

revoke trigger on table "public"."addresses" from "anon";

revoke truncate on table "public"."addresses" from "anon";

revoke update on table "public"."addresses" from "anon";

revoke delete on table "public"."addresses" from "authenticated";

revoke insert on table "public"."addresses" from "authenticated";

revoke references on table "public"."addresses" from "authenticated";

revoke select on table "public"."addresses" from "authenticated";

revoke trigger on table "public"."addresses" from "authenticated";

revoke truncate on table "public"."addresses" from "authenticated";

revoke update on table "public"."addresses" from "authenticated";

revoke delete on table "public"."addresses" from "service_role";

revoke insert on table "public"."addresses" from "service_role";

revoke references on table "public"."addresses" from "service_role";

revoke select on table "public"."addresses" from "service_role";

revoke trigger on table "public"."addresses" from "service_role";

revoke truncate on table "public"."addresses" from "service_role";

revoke update on table "public"."addresses" from "service_role";

revoke delete on table "public"."aid_answers" from "anon";

revoke insert on table "public"."aid_answers" from "anon";

revoke references on table "public"."aid_answers" from "anon";

revoke select on table "public"."aid_answers" from "anon";

revoke trigger on table "public"."aid_answers" from "anon";

revoke truncate on table "public"."aid_answers" from "anon";

revoke update on table "public"."aid_answers" from "anon";

revoke delete on table "public"."aid_answers" from "authenticated";

revoke insert on table "public"."aid_answers" from "authenticated";

revoke references on table "public"."aid_answers" from "authenticated";

revoke select on table "public"."aid_answers" from "authenticated";

revoke trigger on table "public"."aid_answers" from "authenticated";

revoke truncate on table "public"."aid_answers" from "authenticated";

revoke update on table "public"."aid_answers" from "authenticated";

revoke delete on table "public"."aid_answers" from "service_role";

revoke insert on table "public"."aid_answers" from "service_role";

revoke references on table "public"."aid_answers" from "service_role";

revoke select on table "public"."aid_answers" from "service_role";

revoke trigger on table "public"."aid_answers" from "service_role";

revoke truncate on table "public"."aid_answers" from "service_role";

revoke update on table "public"."aid_answers" from "service_role";

revoke delete on table "public"."aid_details" from "anon";

revoke insert on table "public"."aid_details" from "anon";

revoke references on table "public"."aid_details" from "anon";

revoke select on table "public"."aid_details" from "anon";

revoke trigger on table "public"."aid_details" from "anon";

revoke truncate on table "public"."aid_details" from "anon";

revoke update on table "public"."aid_details" from "anon";

revoke delete on table "public"."aid_details" from "authenticated";

revoke insert on table "public"."aid_details" from "authenticated";

revoke references on table "public"."aid_details" from "authenticated";

revoke select on table "public"."aid_details" from "authenticated";

revoke trigger on table "public"."aid_details" from "authenticated";

revoke truncate on table "public"."aid_details" from "authenticated";

revoke update on table "public"."aid_details" from "authenticated";

revoke delete on table "public"."aid_details" from "service_role";

revoke insert on table "public"."aid_details" from "service_role";

revoke references on table "public"."aid_details" from "service_role";

revoke select on table "public"."aid_details" from "service_role";

revoke trigger on table "public"."aid_details" from "service_role";

revoke truncate on table "public"."aid_details" from "service_role";

revoke update on table "public"."aid_details" from "service_role";

revoke delete on table "public"."aid_questions" from "anon";

revoke insert on table "public"."aid_questions" from "anon";

revoke references on table "public"."aid_questions" from "anon";

revoke select on table "public"."aid_questions" from "anon";

revoke trigger on table "public"."aid_questions" from "anon";

revoke truncate on table "public"."aid_questions" from "anon";

revoke update on table "public"."aid_questions" from "anon";

revoke delete on table "public"."aid_questions" from "authenticated";

revoke insert on table "public"."aid_questions" from "authenticated";

revoke references on table "public"."aid_questions" from "authenticated";

revoke select on table "public"."aid_questions" from "authenticated";

revoke trigger on table "public"."aid_questions" from "authenticated";

revoke truncate on table "public"."aid_questions" from "authenticated";

revoke update on table "public"."aid_questions" from "authenticated";

revoke delete on table "public"."aid_questions" from "service_role";

revoke insert on table "public"."aid_questions" from "service_role";

revoke references on table "public"."aid_questions" from "service_role";

revoke select on table "public"."aid_questions" from "service_role";

revoke trigger on table "public"."aid_questions" from "service_role";

revoke truncate on table "public"."aid_questions" from "service_role";

revoke update on table "public"."aid_questions" from "service_role";

revoke delete on table "public"."aid_simulation" from "anon";

revoke insert on table "public"."aid_simulation" from "anon";

revoke references on table "public"."aid_simulation" from "anon";

revoke select on table "public"."aid_simulation" from "anon";

revoke trigger on table "public"."aid_simulation" from "anon";

revoke truncate on table "public"."aid_simulation" from "anon";

revoke update on table "public"."aid_simulation" from "anon";

revoke delete on table "public"."aid_simulation" from "authenticated";

revoke insert on table "public"."aid_simulation" from "authenticated";

revoke references on table "public"."aid_simulation" from "authenticated";

revoke select on table "public"."aid_simulation" from "authenticated";

revoke trigger on table "public"."aid_simulation" from "authenticated";

revoke truncate on table "public"."aid_simulation" from "authenticated";

revoke update on table "public"."aid_simulation" from "authenticated";

revoke delete on table "public"."aid_simulation" from "service_role";

revoke insert on table "public"."aid_simulation" from "service_role";

revoke references on table "public"."aid_simulation" from "service_role";

revoke select on table "public"."aid_simulation" from "service_role";

revoke trigger on table "public"."aid_simulation" from "service_role";

revoke truncate on table "public"."aid_simulation" from "service_role";

revoke update on table "public"."aid_simulation" from "service_role";

revoke delete on table "public"."aid_simulation_work_types" from "anon";

revoke insert on table "public"."aid_simulation_work_types" from "anon";

revoke references on table "public"."aid_simulation_work_types" from "anon";

revoke select on table "public"."aid_simulation_work_types" from "anon";

revoke trigger on table "public"."aid_simulation_work_types" from "anon";

revoke truncate on table "public"."aid_simulation_work_types" from "anon";

revoke update on table "public"."aid_simulation_work_types" from "anon";

revoke delete on table "public"."aid_simulation_work_types" from "authenticated";

revoke insert on table "public"."aid_simulation_work_types" from "authenticated";

revoke references on table "public"."aid_simulation_work_types" from "authenticated";

revoke select on table "public"."aid_simulation_work_types" from "authenticated";

revoke trigger on table "public"."aid_simulation_work_types" from "authenticated";

revoke truncate on table "public"."aid_simulation_work_types" from "authenticated";

revoke update on table "public"."aid_simulation_work_types" from "authenticated";

revoke delete on table "public"."aid_simulation_work_types" from "service_role";

revoke insert on table "public"."aid_simulation_work_types" from "service_role";

revoke references on table "public"."aid_simulation_work_types" from "service_role";

revoke select on table "public"."aid_simulation_work_types" from "service_role";

revoke trigger on table "public"."aid_simulation_work_types" from "service_role";

revoke truncate on table "public"."aid_simulation_work_types" from "service_role";

revoke update on table "public"."aid_simulation_work_types" from "service_role";

revoke delete on table "public"."aid_sub_questions" from "anon";

revoke insert on table "public"."aid_sub_questions" from "anon";

revoke references on table "public"."aid_sub_questions" from "anon";

revoke select on table "public"."aid_sub_questions" from "anon";

revoke trigger on table "public"."aid_sub_questions" from "anon";

revoke truncate on table "public"."aid_sub_questions" from "anon";

revoke update on table "public"."aid_sub_questions" from "anon";

revoke delete on table "public"."aid_sub_questions" from "authenticated";

revoke insert on table "public"."aid_sub_questions" from "authenticated";

revoke references on table "public"."aid_sub_questions" from "authenticated";

revoke select on table "public"."aid_sub_questions" from "authenticated";

revoke trigger on table "public"."aid_sub_questions" from "authenticated";

revoke truncate on table "public"."aid_sub_questions" from "authenticated";

revoke update on table "public"."aid_sub_questions" from "authenticated";

revoke delete on table "public"."aid_sub_questions" from "service_role";

revoke insert on table "public"."aid_sub_questions" from "service_role";

revoke references on table "public"."aid_sub_questions" from "service_role";

revoke select on table "public"."aid_sub_questions" from "service_role";

revoke trigger on table "public"."aid_sub_questions" from "service_role";

revoke truncate on table "public"."aid_sub_questions" from "service_role";

revoke update on table "public"."aid_sub_questions" from "service_role";

revoke delete on table "public"."attached_files" from "anon";

revoke insert on table "public"."attached_files" from "anon";

revoke references on table "public"."attached_files" from "anon";

revoke select on table "public"."attached_files" from "anon";

revoke trigger on table "public"."attached_files" from "anon";

revoke truncate on table "public"."attached_files" from "anon";

revoke update on table "public"."attached_files" from "anon";

revoke delete on table "public"."attached_files" from "authenticated";

revoke insert on table "public"."attached_files" from "authenticated";

revoke references on table "public"."attached_files" from "authenticated";

revoke select on table "public"."attached_files" from "authenticated";

revoke trigger on table "public"."attached_files" from "authenticated";

revoke truncate on table "public"."attached_files" from "authenticated";

revoke update on table "public"."attached_files" from "authenticated";

revoke delete on table "public"."attached_files" from "service_role";

revoke insert on table "public"."attached_files" from "service_role";

revoke references on table "public"."attached_files" from "service_role";

revoke select on table "public"."attached_files" from "service_role";

revoke trigger on table "public"."attached_files" from "service_role";

revoke truncate on table "public"."attached_files" from "service_role";

revoke update on table "public"."attached_files" from "service_role";

revoke delete on table "public"."blog_articles" from "anon";

revoke insert on table "public"."blog_articles" from "anon";

revoke references on table "public"."blog_articles" from "anon";

revoke select on table "public"."blog_articles" from "anon";

revoke trigger on table "public"."blog_articles" from "anon";

revoke truncate on table "public"."blog_articles" from "anon";

revoke update on table "public"."blog_articles" from "anon";

revoke delete on table "public"."blog_articles" from "authenticated";

revoke insert on table "public"."blog_articles" from "authenticated";

revoke references on table "public"."blog_articles" from "authenticated";

revoke select on table "public"."blog_articles" from "authenticated";

revoke trigger on table "public"."blog_articles" from "authenticated";

revoke truncate on table "public"."blog_articles" from "authenticated";

revoke update on table "public"."blog_articles" from "authenticated";

revoke delete on table "public"."blog_articles" from "service_role";

revoke insert on table "public"."blog_articles" from "service_role";

revoke references on table "public"."blog_articles" from "service_role";

revoke select on table "public"."blog_articles" from "service_role";

revoke trigger on table "public"."blog_articles" from "service_role";

revoke truncate on table "public"."blog_articles" from "service_role";

revoke update on table "public"."blog_articles" from "service_role";

revoke delete on table "public"."construction_site_aids" from "anon";

revoke insert on table "public"."construction_site_aids" from "anon";

revoke references on table "public"."construction_site_aids" from "anon";

revoke select on table "public"."construction_site_aids" from "anon";

revoke trigger on table "public"."construction_site_aids" from "anon";

revoke truncate on table "public"."construction_site_aids" from "anon";

revoke update on table "public"."construction_site_aids" from "anon";

revoke delete on table "public"."construction_site_aids" from "authenticated";

revoke insert on table "public"."construction_site_aids" from "authenticated";

revoke references on table "public"."construction_site_aids" from "authenticated";

revoke select on table "public"."construction_site_aids" from "authenticated";

revoke trigger on table "public"."construction_site_aids" from "authenticated";

revoke truncate on table "public"."construction_site_aids" from "authenticated";

revoke update on table "public"."construction_site_aids" from "authenticated";

revoke delete on table "public"."construction_site_aids" from "service_role";

revoke insert on table "public"."construction_site_aids" from "service_role";

revoke references on table "public"."construction_site_aids" from "service_role";

revoke select on table "public"."construction_site_aids" from "service_role";

revoke trigger on table "public"."construction_site_aids" from "service_role";

revoke truncate on table "public"."construction_site_aids" from "service_role";

revoke update on table "public"."construction_site_aids" from "service_role";

revoke delete on table "public"."construction_site_news" from "anon";

revoke insert on table "public"."construction_site_news" from "anon";

revoke references on table "public"."construction_site_news" from "anon";

revoke select on table "public"."construction_site_news" from "anon";

revoke trigger on table "public"."construction_site_news" from "anon";

revoke truncate on table "public"."construction_site_news" from "anon";

revoke update on table "public"."construction_site_news" from "anon";

revoke delete on table "public"."construction_site_news" from "authenticated";

revoke insert on table "public"."construction_site_news" from "authenticated";

revoke references on table "public"."construction_site_news" from "authenticated";

revoke select on table "public"."construction_site_news" from "authenticated";

revoke trigger on table "public"."construction_site_news" from "authenticated";

revoke truncate on table "public"."construction_site_news" from "authenticated";

revoke update on table "public"."construction_site_news" from "authenticated";

revoke delete on table "public"."construction_site_news" from "service_role";

revoke insert on table "public"."construction_site_news" from "service_role";

revoke references on table "public"."construction_site_news" from "service_role";

revoke select on table "public"."construction_site_news" from "service_role";

revoke trigger on table "public"."construction_site_news" from "service_role";

revoke truncate on table "public"."construction_site_news" from "service_role";

revoke update on table "public"."construction_site_news" from "service_role";

revoke delete on table "public"."construction_sites" from "anon";

revoke insert on table "public"."construction_sites" from "anon";

revoke references on table "public"."construction_sites" from "anon";

revoke select on table "public"."construction_sites" from "anon";

revoke trigger on table "public"."construction_sites" from "anon";

revoke truncate on table "public"."construction_sites" from "anon";

revoke update on table "public"."construction_sites" from "anon";

revoke delete on table "public"."construction_sites" from "authenticated";

revoke insert on table "public"."construction_sites" from "authenticated";

revoke references on table "public"."construction_sites" from "authenticated";

revoke select on table "public"."construction_sites" from "authenticated";

revoke trigger on table "public"."construction_sites" from "authenticated";

revoke truncate on table "public"."construction_sites" from "authenticated";

revoke update on table "public"."construction_sites" from "authenticated";

revoke delete on table "public"."construction_sites" from "service_role";

revoke insert on table "public"."construction_sites" from "service_role";

revoke references on table "public"."construction_sites" from "service_role";

revoke select on table "public"."construction_sites" from "service_role";

revoke trigger on table "public"."construction_sites" from "service_role";

revoke truncate on table "public"."construction_sites" from "service_role";

revoke update on table "public"."construction_sites" from "service_role";

revoke delete on table "public"."conversations" from "anon";

revoke insert on table "public"."conversations" from "anon";

revoke references on table "public"."conversations" from "anon";

revoke select on table "public"."conversations" from "anon";

revoke trigger on table "public"."conversations" from "anon";

revoke truncate on table "public"."conversations" from "anon";

revoke update on table "public"."conversations" from "anon";

revoke delete on table "public"."conversations" from "authenticated";

revoke insert on table "public"."conversations" from "authenticated";

revoke references on table "public"."conversations" from "authenticated";

revoke select on table "public"."conversations" from "authenticated";

revoke trigger on table "public"."conversations" from "authenticated";

revoke truncate on table "public"."conversations" from "authenticated";

revoke update on table "public"."conversations" from "authenticated";

revoke delete on table "public"."conversations" from "service_role";

revoke insert on table "public"."conversations" from "service_role";

revoke references on table "public"."conversations" from "service_role";

revoke select on table "public"."conversations" from "service_role";

revoke trigger on table "public"."conversations" from "service_role";

revoke truncate on table "public"."conversations" from "service_role";

revoke update on table "public"."conversations" from "service_role";

revoke delete on table "public"."help" from "anon";

revoke insert on table "public"."help" from "anon";

revoke references on table "public"."help" from "anon";

revoke select on table "public"."help" from "anon";

revoke trigger on table "public"."help" from "anon";

revoke truncate on table "public"."help" from "anon";

revoke update on table "public"."help" from "anon";

revoke delete on table "public"."help" from "authenticated";

revoke insert on table "public"."help" from "authenticated";

revoke references on table "public"."help" from "authenticated";

revoke select on table "public"."help" from "authenticated";

revoke trigger on table "public"."help" from "authenticated";

revoke truncate on table "public"."help" from "authenticated";

revoke update on table "public"."help" from "authenticated";

revoke delete on table "public"."help" from "service_role";

revoke insert on table "public"."help" from "service_role";

revoke references on table "public"."help" from "service_role";

revoke select on table "public"."help" from "service_role";

revoke trigger on table "public"."help" from "service_role";

revoke truncate on table "public"."help" from "service_role";

revoke update on table "public"."help" from "service_role";

revoke delete on table "public"."housings" from "anon";

revoke insert on table "public"."housings" from "anon";

revoke references on table "public"."housings" from "anon";

revoke select on table "public"."housings" from "anon";

revoke trigger on table "public"."housings" from "anon";

revoke truncate on table "public"."housings" from "anon";

revoke update on table "public"."housings" from "anon";

revoke delete on table "public"."housings" from "authenticated";

revoke insert on table "public"."housings" from "authenticated";

revoke references on table "public"."housings" from "authenticated";

revoke select on table "public"."housings" from "authenticated";

revoke trigger on table "public"."housings" from "authenticated";

revoke truncate on table "public"."housings" from "authenticated";

revoke update on table "public"."housings" from "authenticated";

revoke delete on table "public"."housings" from "service_role";

revoke insert on table "public"."housings" from "service_role";

revoke references on table "public"."housings" from "service_role";

revoke select on table "public"."housings" from "service_role";

revoke trigger on table "public"."housings" from "service_role";

revoke truncate on table "public"."housings" from "service_role";

revoke update on table "public"."housings" from "service_role";

revoke delete on table "public"."messages" from "anon";

revoke insert on table "public"."messages" from "anon";

revoke references on table "public"."messages" from "anon";

revoke select on table "public"."messages" from "anon";

revoke trigger on table "public"."messages" from "anon";

revoke truncate on table "public"."messages" from "anon";

revoke update on table "public"."messages" from "anon";

revoke delete on table "public"."messages" from "authenticated";

revoke insert on table "public"."messages" from "authenticated";

revoke references on table "public"."messages" from "authenticated";

revoke select on table "public"."messages" from "authenticated";

revoke trigger on table "public"."messages" from "authenticated";

revoke truncate on table "public"."messages" from "authenticated";

revoke update on table "public"."messages" from "authenticated";

revoke delete on table "public"."messages" from "service_role";

revoke insert on table "public"."messages" from "service_role";

revoke references on table "public"."messages" from "service_role";

revoke select on table "public"."messages" from "service_role";

revoke trigger on table "public"."messages" from "service_role";

revoke truncate on table "public"."messages" from "service_role";

revoke update on table "public"."messages" from "service_role";

revoke delete on table "public"."notifications" from "anon";

revoke insert on table "public"."notifications" from "anon";

revoke references on table "public"."notifications" from "anon";

revoke select on table "public"."notifications" from "anon";

revoke trigger on table "public"."notifications" from "anon";

revoke truncate on table "public"."notifications" from "anon";

revoke update on table "public"."notifications" from "anon";

revoke delete on table "public"."notifications" from "authenticated";

revoke insert on table "public"."notifications" from "authenticated";

revoke references on table "public"."notifications" from "authenticated";

revoke select on table "public"."notifications" from "authenticated";

revoke trigger on table "public"."notifications" from "authenticated";

revoke truncate on table "public"."notifications" from "authenticated";

revoke update on table "public"."notifications" from "authenticated";

revoke delete on table "public"."notifications" from "service_role";

revoke insert on table "public"."notifications" from "service_role";

revoke references on table "public"."notifications" from "service_role";

revoke select on table "public"."notifications" from "service_role";

revoke trigger on table "public"."notifications" from "service_role";

revoke truncate on table "public"."notifications" from "service_role";

revoke update on table "public"."notifications" from "service_role";

revoke delete on table "public"."preferences" from "anon";

revoke insert on table "public"."preferences" from "anon";

revoke references on table "public"."preferences" from "anon";

revoke select on table "public"."preferences" from "anon";

revoke trigger on table "public"."preferences" from "anon";

revoke truncate on table "public"."preferences" from "anon";

revoke update on table "public"."preferences" from "anon";

revoke delete on table "public"."preferences" from "authenticated";

revoke insert on table "public"."preferences" from "authenticated";

revoke references on table "public"."preferences" from "authenticated";

revoke select on table "public"."preferences" from "authenticated";

revoke trigger on table "public"."preferences" from "authenticated";

revoke truncate on table "public"."preferences" from "authenticated";

revoke update on table "public"."preferences" from "authenticated";

revoke delete on table "public"."preferences" from "service_role";

revoke insert on table "public"."preferences" from "service_role";

revoke references on table "public"."preferences" from "service_role";

revoke select on table "public"."preferences" from "service_role";

revoke trigger on table "public"."preferences" from "service_role";

revoke truncate on table "public"."preferences" from "service_role";

revoke update on table "public"."preferences" from "service_role";

revoke delete on table "public"."refresh_tokens" from "anon";

revoke insert on table "public"."refresh_tokens" from "anon";

revoke references on table "public"."refresh_tokens" from "anon";

revoke select on table "public"."refresh_tokens" from "anon";

revoke trigger on table "public"."refresh_tokens" from "anon";

revoke truncate on table "public"."refresh_tokens" from "anon";

revoke update on table "public"."refresh_tokens" from "anon";

revoke delete on table "public"."refresh_tokens" from "authenticated";

revoke insert on table "public"."refresh_tokens" from "authenticated";

revoke references on table "public"."refresh_tokens" from "authenticated";

revoke select on table "public"."refresh_tokens" from "authenticated";

revoke trigger on table "public"."refresh_tokens" from "authenticated";

revoke truncate on table "public"."refresh_tokens" from "authenticated";

revoke update on table "public"."refresh_tokens" from "authenticated";

revoke delete on table "public"."refresh_tokens" from "service_role";

revoke insert on table "public"."refresh_tokens" from "service_role";

revoke references on table "public"."refresh_tokens" from "service_role";

revoke select on table "public"."refresh_tokens" from "service_role";

revoke trigger on table "public"."refresh_tokens" from "service_role";

revoke truncate on table "public"."refresh_tokens" from "service_role";

revoke update on table "public"."refresh_tokens" from "service_role";

revoke delete on table "public"."site_participants" from "anon";

revoke insert on table "public"."site_participants" from "anon";

revoke references on table "public"."site_participants" from "anon";

revoke select on table "public"."site_participants" from "anon";

revoke trigger on table "public"."site_participants" from "anon";

revoke truncate on table "public"."site_participants" from "anon";

revoke update on table "public"."site_participants" from "anon";

revoke delete on table "public"."site_participants" from "authenticated";

revoke insert on table "public"."site_participants" from "authenticated";

revoke references on table "public"."site_participants" from "authenticated";

revoke select on table "public"."site_participants" from "authenticated";

revoke trigger on table "public"."site_participants" from "authenticated";

revoke truncate on table "public"."site_participants" from "authenticated";

revoke update on table "public"."site_participants" from "authenticated";

revoke delete on table "public"."site_participants" from "service_role";

revoke insert on table "public"."site_participants" from "service_role";

revoke references on table "public"."site_participants" from "service_role";

revoke select on table "public"."site_participants" from "service_role";

revoke trigger on table "public"."site_participants" from "service_role";

revoke truncate on table "public"."site_participants" from "service_role";

revoke update on table "public"."site_participants" from "service_role";

revoke delete on table "public"."users" from "anon";

revoke insert on table "public"."users" from "anon";

revoke references on table "public"."users" from "anon";

revoke select on table "public"."users" from "anon";

revoke trigger on table "public"."users" from "anon";

revoke truncate on table "public"."users" from "anon";

revoke update on table "public"."users" from "anon";

revoke delete on table "public"."users" from "authenticated";

revoke insert on table "public"."users" from "authenticated";

revoke references on table "public"."users" from "authenticated";

revoke select on table "public"."users" from "authenticated";

revoke trigger on table "public"."users" from "authenticated";

revoke truncate on table "public"."users" from "authenticated";

revoke update on table "public"."users" from "authenticated";

revoke delete on table "public"."users" from "service_role";

revoke insert on table "public"."users" from "service_role";

revoke references on table "public"."users" from "service_role";

revoke select on table "public"."users" from "service_role";

revoke trigger on table "public"."users" from "service_role";

revoke truncate on table "public"."users" from "service_role";

revoke update on table "public"."users" from "service_role";

alter table "public"."aid_answers" drop constraint "aid_answers_sub_question_id_fkey";

alter table "public"."aid_simulation" drop constraint "aid_simulation_session_token_key";

alter table "public"."aid_simulation_work_types" drop constraint "aid_simulation_work_types_simulation_id_fkey";

alter table "public"."aid_sub_questions" drop constraint "aid_sub_questions_question_id_fkey";

alter table "public"."attached_files" drop constraint "attached_files_construction_site_aid_id_fkey";

alter table "public"."blog_articles" drop constraint "blog_articles_aid_id_fkey";

alter table "public"."construction_site_aids" drop constraint "construction_site_aids_aid_detail_id_fkey";

alter table "public"."construction_site_aids" drop constraint "construction_site_aids_construction_site_id_fkey";

alter table "public"."construction_site_news" drop constraint "construction_site_news_author_id_fkey";

alter table "public"."construction_site_news" drop constraint "construction_site_news_construction_site_id_fkey";

alter table "public"."construction_sites" drop constraint "construction_sites_address_id_fkey";

alter table "public"."construction_sites" drop constraint "construction_sites_housing_id_fkey";

alter table "public"."conversations" drop constraint "conversations_client_id_fkey";

alter table "public"."conversations" drop constraint "conversations_construction_site_id_fkey";

alter table "public"."conversations" drop constraint "conversations_mediator_id_fkey";

alter table "public"."help" drop constraint "aid_requests_user_id_fkey";

alter table "public"."messages" drop constraint "messages_conversation_id_fkey";

alter table "public"."messages" drop constraint "messages_sender_id_fkey";

alter table "public"."notifications" drop constraint "notifications_preference_id_fkey";

alter table "public"."notifications" drop constraint "notifications_user_id_fkey";

alter table "public"."preferences" drop constraint "preferences_user_id_fkey";

alter table "public"."refresh_tokens" drop constraint "refresh_tokens_user_id_fkey";

alter table "public"."site_participants" drop constraint "site_participants_construction_site_id_fkey";

alter table "public"."site_participants" drop constraint "site_participants_participant_id_fkey";

alter table "public"."users" drop constraint "email_valid";

alter table "public"."users" drop constraint "users_address_id_fkey";

alter table "public"."users" drop constraint "users_aid_simulation_id_fkey";

alter table "public"."users" drop constraint "users_email_key";

alter table "public"."users" drop constraint "users_preferences_id_fkey";

alter table "public"."users" drop constraint "users_username_key";

drop type "public"."aid_eligibility_result";

drop function if exists "public"."check_aid_eligibility"(p_simulation_id uuid);

drop function if exists "public"."delete_expired_simulations"();

drop type "public"."eligible_aid_result";

drop function if exists "public"."get_aid_eligibility_summary"(p_simulation_id uuid);

drop function if exists "public"."update_updated_at_column"();

alter table "public"."addresses" drop constraint "addresses_pkey";

alter table "public"."aid_answers" drop constraint "aid_answers_pkey";

alter table "public"."aid_details" drop constraint "aid_details_pkey";

alter table "public"."aid_questions" drop constraint "aid_questions_pkey";

alter table "public"."aid_simulation" drop constraint "aid_simulation_pkey";

alter table "public"."aid_simulation_work_types" drop constraint "aid_simulation_work_types_pkey";

alter table "public"."aid_sub_questions" drop constraint "aid_sub_questions_pkey";

alter table "public"."attached_files" drop constraint "attached_files_pkey";

alter table "public"."blog_articles" drop constraint "blog_articles_pkey";

alter table "public"."construction_site_aids" drop constraint "construction_site_aids_pkey";

alter table "public"."construction_site_news" drop constraint "construction_site_news_pkey";

alter table "public"."construction_sites" drop constraint "construction_sites_pkey";

alter table "public"."conversations" drop constraint "conversations_pkey";

alter table "public"."help" drop constraint "aid_requests_pkey";

alter table "public"."housings" drop constraint "housings_pkey";

alter table "public"."messages" drop constraint "messages_pkey";

alter table "public"."notifications" drop constraint "notifications_pkey";

alter table "public"."preferences" drop constraint "preferences_pkey";

alter table "public"."refresh_tokens" drop constraint "refresh_tokens_pkey";

alter table "public"."site_participants" drop constraint "site_participants_pkey";

alter table "public"."users" drop constraint "users_pkey";

drop index if exists "public"."addresses_pkey";

drop index if exists "public"."aid_answers_pkey";

drop index if exists "public"."aid_details_pkey";

drop index if exists "public"."aid_questions_pkey";

drop index if exists "public"."aid_requests_pkey";

drop index if exists "public"."aid_simulation_pkey";

drop index if exists "public"."aid_simulation_session_token_key";

drop index if exists "public"."aid_simulation_work_types_pkey";

drop index if exists "public"."aid_sub_questions_pkey";

drop index if exists "public"."attached_files_pkey";

drop index if exists "public"."blog_articles_pkey";

drop index if exists "public"."construction_site_aids_pkey";

drop index if exists "public"."construction_site_news_pkey";

drop index if exists "public"."construction_sites_pkey";

drop index if exists "public"."conversations_pkey";

drop index if exists "public"."housings_pkey";

drop index if exists "public"."idx_addresses_geom";

drop index if exists "public"."idx_aid_answers_sub_question_id";

drop index if exists "public"."idx_aid_details_department";

drop index if exists "public"."idx_aid_details_income_range";

drop index if exists "public"."idx_aid_questions_step_number";

drop index if exists "public"."idx_aid_simulation_energy_label";

drop index if exists "public"."idx_aid_simulation_work_types";

drop index if exists "public"."idx_aid_sub_questions_question_id";

drop index if exists "public"."idx_construction_sites_status";

drop index if exists "public"."idx_conversations_construction_site";

drop index if exists "public"."idx_messages_conversation";

drop index if exists "public"."idx_users_email";

drop index if exists "public"."idx_users_username";

drop index if exists "public"."messages_pkey";

drop index if exists "public"."notifications_pkey";

drop index if exists "public"."preferences_pkey";

drop index if exists "public"."refresh_tokens_pkey";

drop index if exists "public"."site_participants_pkey";

drop index if exists "public"."users_email_key";

drop index if exists "public"."users_pkey";

drop index if exists "public"."users_username_key";

drop table "public"."addresses";

drop table "public"."aid_answers";

drop table "public"."aid_details";

drop table "public"."aid_questions";

drop table "public"."aid_simulation";

drop table "public"."aid_simulation_work_types";

drop table "public"."aid_sub_questions";

drop table "public"."attached_files";

drop table "public"."blog_articles";

drop table "public"."construction_site_aids";

drop table "public"."construction_site_news";

drop table "public"."construction_sites";

drop table "public"."conversations";

drop table "public"."help";

drop table "public"."housings";

drop table "public"."messages";

drop table "public"."notifications";

drop table "public"."preferences";

drop table "public"."refresh_tokens";

drop table "public"."site_participants";

drop table "public"."users";

drop type "public"."conversation_status";

drop type "public"."energy_label_type";

drop type "public"."fiscal_income_type";

drop type "public"."housing_type";

drop type "public"."news_type";

drop type "public"."notification_status";

drop type "public"."occupancy_status_type";

drop type "public"."preferred_languages";

drop type "public"."site_status";

drop type "public"."type_sub_question";

drop type "public"."user_role";

drop type "public"."work_type";


