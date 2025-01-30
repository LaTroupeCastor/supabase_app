drop function if exists "public"."check_aid_eligibility"(p_simulation_id uuid);

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_aid_eligibility(p_simulation_id uuid)
 RETURNS TABLE(id uuid, name text, description text, max_amount numeric, default_amount numeric, adjusted_amount numeric, funding_organization text, required_documents text[])
 LANGUAGE plpgsql
AS $function$                                                                                                                                                                                
 DECLARE                                                                                                                                                                                
     simulation_record RECORD;                                                                                                                                                          
 BEGIN                                                                                                                                                                                  
     -- Récupération des informations de simulation avec la tranche de revenu                                                                                                           
     SELECT                                                                                                                                                                             
         s.*,                                                                                                                                                                           
         array_agg(awt.work_type) as selected_work_types,                                                                                                                               
         a.department,                                                                                                                                                                  
         CASE                                                                                                                                                                           
             WHEN aa.content LIKE 'Moins de%' THEN 0                                                                                                                                    
             WHEN aa.content LIKE 'Entre 15 262€%' THEN 15262                                                                                                                           
             WHEN aa.content LIKE 'Entre 19 565€%' THEN 19565                                                                                                                           
             WHEN aa.content LIKE 'Entre 29 148€%' THEN 29148                                                                                                                           
             WHEN aa.content LIKE 'Plus de%' THEN 38184                                                                                                                                 
         END as income_bracket_min,                                                                                                                                                     
         CASE                                                                                                                                                                           
             WHEN aa.content LIKE 'Moins de%' THEN 15262                                                                                                                                
             WHEN aa.content LIKE 'Entre 15 262€%' THEN 19565                                                                                                                           
             WHEN aa.content LIKE 'Entre 19 565€%' THEN 29148                                                                                                                           
             WHEN aa.content LIKE 'Entre 29 148€%' THEN 38184                                                                                                                           
             WHEN aa.content LIKE 'Plus de%' THEN NULL                                                                                                                                  
         END as income_bracket_max                                                                                                                                                      
     INTO simulation_record                                                                                                                                                             
     FROM aid_simulation s                                                                                                                                                              
     LEFT JOIN aid_simulation_work_types awt ON s.id = awt.simulation_id                                                                                                                
     LEFT JOIN users u ON s.email = u.email                                                                                                                                             
     LEFT JOIN addresses a ON u.address_id = a.id                                                                                                                                       
     LEFT JOIN aid_simulation_answers asa ON s.id = asa.simulation_id                                                                                                                   
     LEFT JOIN aid_answers aa ON asa.answer_id = aa.id                                                                                                                                  
     WHERE s.id = p_simulation_id                                                                                                                                                       
     AND aa.sub_question_id = (SELECT id FROM aid_sub_questions WHERE content LIKE '%revenu fiscal%')                                                                                   
     GROUP BY s.id, a.department, aa.content;                                                                                                                                           
                                                                                                                                                                                        
     IF NOT FOUND THEN                                                                                                                                                                  
         RAISE EXCEPTION 'Simulation not found';                                                                                                                                        
     END IF;                                                                                                                                                                            
                                                                                                                                                                                        
     RETURN QUERY                                                                                                                                                                       
     SELECT                                                                                                                                                                             
         ad.id,                                                                                                                                                                         
         ad.name,                                                                                                                                                                       
         ad.description,                                                                                                                                                                
         ad.max_amount,                                                                                                                                                                 
         ad.default_amount,                                                                                                                                                             
         CAST(                                                                                                                                                                          
             CASE                                                                                                                                                                       
                 WHEN ad.name = 'Aide départementale Maine-et-Loire'                                                                                                                    
                     AND simulation_record.department = '49'                                                                                                                            
                     AND simulation_record.energy_label IN ('f_or_g')                                                                                                                   
                 THEN                                                                                                                                                                   
                     CASE                                                                                                                                                               
                         WHEN simulation_record.biosourced_materials                                                                                                                    
                         THEN CAST(ad.default_amount + 500 AS numeric(12,2))                                                                                                            
                         ELSE ad.default_amount                                                                                                                                         
                     END                                                                                                                                                                
                 WHEN ad.name = 'Aide Mieux chez Moi'                                                                                                                                   
                     AND simulation_record.department = '49'                                                                                                                            
                 THEN ad.default_amount                                                                                                                                                 
                 WHEN ad.name = 'Aide amélioration énergétique Saumur'                                                                                                                  
                     AND simulation_record.department = '49'                                                                                                                            
                 THEN LEAST(ad.max_amount, ad.default_amount)                                                                                                                           
                 WHEN ad.name = 'MaPrimeRenov'                                                                                                                                          
                 THEN                                                                                                                                                                   
                     CASE                                                                                                                                                               
                         WHEN simulation_record.income_bracket_min < 15262 THEN ad.max_amount                                                                                           
                         WHEN simulation_record.income_bracket_min < 19565 THEN ad.max_amount * 0.75                                                                                    
                         WHEN simulation_record.income_bracket_min < 29148 THEN ad.max_amount * 0.50                                                                                    
                         ELSE ad.max_amount * 0.25                                                                                                                                      
                     END                                                                                                                                                                
                 ELSE ad.default_amount                                                                                                                                                 
             END AS numeric(12,2)                                                                                                                                                       
         ) as adjusted_amount,                                                                                                                                                          
         ad.funding_organization,                                                                                                                                                       
         ad.required_documents                                                                                                                                                          
     FROM aid_details ad                                                                                                                                                                
     WHERE                                                                                                                                                                              
         (ad.min_income IS NULL OR simulation_record.income_bracket_min >= ad.min_income)                                                                                               
         AND (ad.max_income IS NULL OR                                                                                                                                                  
             (simulation_record.income_bracket_max IS NULL OR                                                                                                                           
             simulation_record.income_bracket_max <= ad.max_income))                                                                                                                    
         AND (ad.building_age_over_15 IS NULL                                                                                                                                           
              OR ad.building_age_over_15 = simulation_record.building_age_over_15)                                                                                                      
         AND (ad.occupancy_status_required IS NULL                                                                                                                                      
              OR simulation_record.occupancy_status::text = ANY(ad.occupancy_status_required::text[]))                                                                                  
         AND (ad.allowed_work_types IS NULL                                                                                                                                             
              OR ad.allowed_work_types && simulation_record.selected_work_types)                                                                                                        
         AND (                                                                                                                                                                          
             (ad.name NOT LIKE 'Aide%département%' OR simulation_record.department = '49')                                                                                              
             AND                                                                                                                                                                        
             (ad.name NOT LIKE '%Saumur%' OR simulation_record.department = '49')                                                                                                       
             AND                                                                                                                                                                        
             (ad.name NOT LIKE '%Angers%' OR simulation_record.department = '49')                                                                                                       
         );                                                                                                                                                                             
                                                                                                                                                                                        
 END;                                                                                                                                                                                   
 $function$
;

grant delete on table "public"."addresses" to "anon";

grant insert on table "public"."addresses" to "anon";

grant references on table "public"."addresses" to "anon";

grant select on table "public"."addresses" to "anon";

grant trigger on table "public"."addresses" to "anon";

grant truncate on table "public"."addresses" to "anon";

grant update on table "public"."addresses" to "anon";

grant delete on table "public"."addresses" to "authenticated";

grant insert on table "public"."addresses" to "authenticated";

grant references on table "public"."addresses" to "authenticated";

grant select on table "public"."addresses" to "authenticated";

grant trigger on table "public"."addresses" to "authenticated";

grant truncate on table "public"."addresses" to "authenticated";

grant update on table "public"."addresses" to "authenticated";

grant delete on table "public"."addresses" to "service_role";

grant insert on table "public"."addresses" to "service_role";

grant references on table "public"."addresses" to "service_role";

grant select on table "public"."addresses" to "service_role";

grant trigger on table "public"."addresses" to "service_role";

grant truncate on table "public"."addresses" to "service_role";

grant update on table "public"."addresses" to "service_role";

grant delete on table "public"."aid_answers" to "anon";

grant insert on table "public"."aid_answers" to "anon";

grant references on table "public"."aid_answers" to "anon";

grant trigger on table "public"."aid_answers" to "anon";

grant truncate on table "public"."aid_answers" to "anon";

grant update on table "public"."aid_answers" to "anon";

grant delete on table "public"."aid_answers" to "authenticated";

grant insert on table "public"."aid_answers" to "authenticated";

grant references on table "public"."aid_answers" to "authenticated";

grant trigger on table "public"."aid_answers" to "authenticated";

grant truncate on table "public"."aid_answers" to "authenticated";

grant update on table "public"."aid_answers" to "authenticated";

grant delete on table "public"."aid_answers" to "service_role";

grant insert on table "public"."aid_answers" to "service_role";

grant references on table "public"."aid_answers" to "service_role";

grant trigger on table "public"."aid_answers" to "service_role";

grant truncate on table "public"."aid_answers" to "service_role";

grant update on table "public"."aid_answers" to "service_role";

grant delete on table "public"."aid_details" to "anon";

grant insert on table "public"."aid_details" to "anon";

grant references on table "public"."aid_details" to "anon";

grant select on table "public"."aid_details" to "anon";

grant trigger on table "public"."aid_details" to "anon";

grant truncate on table "public"."aid_details" to "anon";

grant update on table "public"."aid_details" to "anon";

grant delete on table "public"."aid_details" to "authenticated";

grant insert on table "public"."aid_details" to "authenticated";

grant references on table "public"."aid_details" to "authenticated";

grant select on table "public"."aid_details" to "authenticated";

grant trigger on table "public"."aid_details" to "authenticated";

grant truncate on table "public"."aid_details" to "authenticated";

grant update on table "public"."aid_details" to "authenticated";

grant delete on table "public"."aid_details" to "service_role";

grant insert on table "public"."aid_details" to "service_role";

grant references on table "public"."aid_details" to "service_role";

grant select on table "public"."aid_details" to "service_role";

grant trigger on table "public"."aid_details" to "service_role";

grant truncate on table "public"."aid_details" to "service_role";

grant update on table "public"."aid_details" to "service_role";

grant delete on table "public"."aid_questions" to "anon";

grant insert on table "public"."aid_questions" to "anon";

grant references on table "public"."aid_questions" to "anon";

grant trigger on table "public"."aid_questions" to "anon";

grant truncate on table "public"."aid_questions" to "anon";

grant update on table "public"."aid_questions" to "anon";

grant delete on table "public"."aid_questions" to "authenticated";

grant insert on table "public"."aid_questions" to "authenticated";

grant references on table "public"."aid_questions" to "authenticated";

grant trigger on table "public"."aid_questions" to "authenticated";

grant truncate on table "public"."aid_questions" to "authenticated";

grant update on table "public"."aid_questions" to "authenticated";

grant delete on table "public"."aid_questions" to "service_role";

grant insert on table "public"."aid_questions" to "service_role";

grant references on table "public"."aid_questions" to "service_role";

grant trigger on table "public"."aid_questions" to "service_role";

grant truncate on table "public"."aid_questions" to "service_role";

grant update on table "public"."aid_questions" to "service_role";

grant delete on table "public"."aid_simulation" to "anon";

grant insert on table "public"."aid_simulation" to "anon";

grant references on table "public"."aid_simulation" to "anon";

grant select on table "public"."aid_simulation" to "anon";

grant trigger on table "public"."aid_simulation" to "anon";

grant truncate on table "public"."aid_simulation" to "anon";

grant update on table "public"."aid_simulation" to "anon";

grant delete on table "public"."aid_simulation" to "authenticated";

grant insert on table "public"."aid_simulation" to "authenticated";

grant references on table "public"."aid_simulation" to "authenticated";

grant select on table "public"."aid_simulation" to "authenticated";

grant trigger on table "public"."aid_simulation" to "authenticated";

grant truncate on table "public"."aid_simulation" to "authenticated";

grant update on table "public"."aid_simulation" to "authenticated";

grant delete on table "public"."aid_simulation" to "service_role";

grant insert on table "public"."aid_simulation" to "service_role";

grant references on table "public"."aid_simulation" to "service_role";

grant select on table "public"."aid_simulation" to "service_role";

grant trigger on table "public"."aid_simulation" to "service_role";

grant truncate on table "public"."aid_simulation" to "service_role";

grant update on table "public"."aid_simulation" to "service_role";

grant delete on table "public"."aid_simulation_work_types" to "anon";

grant insert on table "public"."aid_simulation_work_types" to "anon";

grant references on table "public"."aid_simulation_work_types" to "anon";

grant select on table "public"."aid_simulation_work_types" to "anon";

grant trigger on table "public"."aid_simulation_work_types" to "anon";

grant truncate on table "public"."aid_simulation_work_types" to "anon";

grant update on table "public"."aid_simulation_work_types" to "anon";

grant delete on table "public"."aid_simulation_work_types" to "authenticated";

grant insert on table "public"."aid_simulation_work_types" to "authenticated";

grant references on table "public"."aid_simulation_work_types" to "authenticated";

grant select on table "public"."aid_simulation_work_types" to "authenticated";

grant trigger on table "public"."aid_simulation_work_types" to "authenticated";

grant truncate on table "public"."aid_simulation_work_types" to "authenticated";

grant update on table "public"."aid_simulation_work_types" to "authenticated";

grant delete on table "public"."aid_simulation_work_types" to "service_role";

grant insert on table "public"."aid_simulation_work_types" to "service_role";

grant references on table "public"."aid_simulation_work_types" to "service_role";

grant select on table "public"."aid_simulation_work_types" to "service_role";

grant trigger on table "public"."aid_simulation_work_types" to "service_role";

grant truncate on table "public"."aid_simulation_work_types" to "service_role";

grant update on table "public"."aid_simulation_work_types" to "service_role";

grant delete on table "public"."aid_sub_questions" to "anon";

grant insert on table "public"."aid_sub_questions" to "anon";

grant references on table "public"."aid_sub_questions" to "anon";

grant trigger on table "public"."aid_sub_questions" to "anon";

grant truncate on table "public"."aid_sub_questions" to "anon";

grant update on table "public"."aid_sub_questions" to "anon";

grant delete on table "public"."aid_sub_questions" to "authenticated";

grant insert on table "public"."aid_sub_questions" to "authenticated";

grant references on table "public"."aid_sub_questions" to "authenticated";

grant trigger on table "public"."aid_sub_questions" to "authenticated";

grant truncate on table "public"."aid_sub_questions" to "authenticated";

grant update on table "public"."aid_sub_questions" to "authenticated";

grant delete on table "public"."aid_sub_questions" to "service_role";

grant insert on table "public"."aid_sub_questions" to "service_role";

grant references on table "public"."aid_sub_questions" to "service_role";

grant trigger on table "public"."aid_sub_questions" to "service_role";

grant truncate on table "public"."aid_sub_questions" to "service_role";

grant update on table "public"."aid_sub_questions" to "service_role";

grant delete on table "public"."attached_files" to "anon";

grant insert on table "public"."attached_files" to "anon";

grant references on table "public"."attached_files" to "anon";

grant select on table "public"."attached_files" to "anon";

grant trigger on table "public"."attached_files" to "anon";

grant truncate on table "public"."attached_files" to "anon";

grant update on table "public"."attached_files" to "anon";

grant delete on table "public"."attached_files" to "authenticated";

grant insert on table "public"."attached_files" to "authenticated";

grant references on table "public"."attached_files" to "authenticated";

grant select on table "public"."attached_files" to "authenticated";

grant trigger on table "public"."attached_files" to "authenticated";

grant truncate on table "public"."attached_files" to "authenticated";

grant update on table "public"."attached_files" to "authenticated";

grant delete on table "public"."attached_files" to "service_role";

grant insert on table "public"."attached_files" to "service_role";

grant references on table "public"."attached_files" to "service_role";

grant select on table "public"."attached_files" to "service_role";

grant trigger on table "public"."attached_files" to "service_role";

grant truncate on table "public"."attached_files" to "service_role";

grant update on table "public"."attached_files" to "service_role";

grant delete on table "public"."blog_articles" to "anon";

grant insert on table "public"."blog_articles" to "anon";

grant references on table "public"."blog_articles" to "anon";

grant select on table "public"."blog_articles" to "anon";

grant trigger on table "public"."blog_articles" to "anon";

grant truncate on table "public"."blog_articles" to "anon";

grant update on table "public"."blog_articles" to "anon";

grant delete on table "public"."blog_articles" to "authenticated";

grant insert on table "public"."blog_articles" to "authenticated";

grant references on table "public"."blog_articles" to "authenticated";

grant select on table "public"."blog_articles" to "authenticated";

grant trigger on table "public"."blog_articles" to "authenticated";

grant truncate on table "public"."blog_articles" to "authenticated";

grant update on table "public"."blog_articles" to "authenticated";

grant delete on table "public"."blog_articles" to "service_role";

grant insert on table "public"."blog_articles" to "service_role";

grant references on table "public"."blog_articles" to "service_role";

grant select on table "public"."blog_articles" to "service_role";

grant trigger on table "public"."blog_articles" to "service_role";

grant truncate on table "public"."blog_articles" to "service_role";

grant update on table "public"."blog_articles" to "service_role";

grant delete on table "public"."construction_site_aids" to "anon";

grant insert on table "public"."construction_site_aids" to "anon";

grant references on table "public"."construction_site_aids" to "anon";

grant select on table "public"."construction_site_aids" to "anon";

grant trigger on table "public"."construction_site_aids" to "anon";

grant truncate on table "public"."construction_site_aids" to "anon";

grant update on table "public"."construction_site_aids" to "anon";

grant delete on table "public"."construction_site_aids" to "authenticated";

grant insert on table "public"."construction_site_aids" to "authenticated";

grant references on table "public"."construction_site_aids" to "authenticated";

grant select on table "public"."construction_site_aids" to "authenticated";

grant trigger on table "public"."construction_site_aids" to "authenticated";

grant truncate on table "public"."construction_site_aids" to "authenticated";

grant update on table "public"."construction_site_aids" to "authenticated";

grant delete on table "public"."construction_site_aids" to "service_role";

grant insert on table "public"."construction_site_aids" to "service_role";

grant references on table "public"."construction_site_aids" to "service_role";

grant select on table "public"."construction_site_aids" to "service_role";

grant trigger on table "public"."construction_site_aids" to "service_role";

grant truncate on table "public"."construction_site_aids" to "service_role";

grant update on table "public"."construction_site_aids" to "service_role";

grant delete on table "public"."construction_site_news" to "anon";

grant insert on table "public"."construction_site_news" to "anon";

grant references on table "public"."construction_site_news" to "anon";

grant select on table "public"."construction_site_news" to "anon";

grant trigger on table "public"."construction_site_news" to "anon";

grant truncate on table "public"."construction_site_news" to "anon";

grant update on table "public"."construction_site_news" to "anon";

grant delete on table "public"."construction_site_news" to "authenticated";

grant insert on table "public"."construction_site_news" to "authenticated";

grant references on table "public"."construction_site_news" to "authenticated";

grant select on table "public"."construction_site_news" to "authenticated";

grant trigger on table "public"."construction_site_news" to "authenticated";

grant truncate on table "public"."construction_site_news" to "authenticated";

grant update on table "public"."construction_site_news" to "authenticated";

grant delete on table "public"."construction_site_news" to "service_role";

grant insert on table "public"."construction_site_news" to "service_role";

grant references on table "public"."construction_site_news" to "service_role";

grant select on table "public"."construction_site_news" to "service_role";

grant trigger on table "public"."construction_site_news" to "service_role";

grant truncate on table "public"."construction_site_news" to "service_role";

grant update on table "public"."construction_site_news" to "service_role";

grant delete on table "public"."construction_sites" to "anon";

grant insert on table "public"."construction_sites" to "anon";

grant references on table "public"."construction_sites" to "anon";

grant select on table "public"."construction_sites" to "anon";

grant trigger on table "public"."construction_sites" to "anon";

grant truncate on table "public"."construction_sites" to "anon";

grant update on table "public"."construction_sites" to "anon";

grant delete on table "public"."construction_sites" to "authenticated";

grant insert on table "public"."construction_sites" to "authenticated";

grant references on table "public"."construction_sites" to "authenticated";

grant select on table "public"."construction_sites" to "authenticated";

grant trigger on table "public"."construction_sites" to "authenticated";

grant truncate on table "public"."construction_sites" to "authenticated";

grant update on table "public"."construction_sites" to "authenticated";

grant delete on table "public"."construction_sites" to "service_role";

grant insert on table "public"."construction_sites" to "service_role";

grant references on table "public"."construction_sites" to "service_role";

grant select on table "public"."construction_sites" to "service_role";

grant trigger on table "public"."construction_sites" to "service_role";

grant truncate on table "public"."construction_sites" to "service_role";

grant update on table "public"."construction_sites" to "service_role";

grant delete on table "public"."conversations" to "anon";

grant insert on table "public"."conversations" to "anon";

grant references on table "public"."conversations" to "anon";

grant select on table "public"."conversations" to "anon";

grant trigger on table "public"."conversations" to "anon";

grant truncate on table "public"."conversations" to "anon";

grant update on table "public"."conversations" to "anon";

grant delete on table "public"."conversations" to "authenticated";

grant insert on table "public"."conversations" to "authenticated";

grant references on table "public"."conversations" to "authenticated";

grant select on table "public"."conversations" to "authenticated";

grant trigger on table "public"."conversations" to "authenticated";

grant truncate on table "public"."conversations" to "authenticated";

grant update on table "public"."conversations" to "authenticated";

grant delete on table "public"."conversations" to "service_role";

grant insert on table "public"."conversations" to "service_role";

grant references on table "public"."conversations" to "service_role";

grant select on table "public"."conversations" to "service_role";

grant trigger on table "public"."conversations" to "service_role";

grant truncate on table "public"."conversations" to "service_role";

grant update on table "public"."conversations" to "service_role";

grant delete on table "public"."help" to "anon";

grant insert on table "public"."help" to "anon";

grant references on table "public"."help" to "anon";

grant select on table "public"."help" to "anon";

grant trigger on table "public"."help" to "anon";

grant truncate on table "public"."help" to "anon";

grant update on table "public"."help" to "anon";

grant delete on table "public"."help" to "authenticated";

grant insert on table "public"."help" to "authenticated";

grant references on table "public"."help" to "authenticated";

grant select on table "public"."help" to "authenticated";

grant trigger on table "public"."help" to "authenticated";

grant truncate on table "public"."help" to "authenticated";

grant update on table "public"."help" to "authenticated";

grant delete on table "public"."help" to "service_role";

grant insert on table "public"."help" to "service_role";

grant references on table "public"."help" to "service_role";

grant select on table "public"."help" to "service_role";

grant trigger on table "public"."help" to "service_role";

grant truncate on table "public"."help" to "service_role";

grant update on table "public"."help" to "service_role";

grant delete on table "public"."housings" to "anon";

grant insert on table "public"."housings" to "anon";

grant references on table "public"."housings" to "anon";

grant select on table "public"."housings" to "anon";

grant trigger on table "public"."housings" to "anon";

grant truncate on table "public"."housings" to "anon";

grant update on table "public"."housings" to "anon";

grant delete on table "public"."housings" to "authenticated";

grant insert on table "public"."housings" to "authenticated";

grant references on table "public"."housings" to "authenticated";

grant select on table "public"."housings" to "authenticated";

grant trigger on table "public"."housings" to "authenticated";

grant truncate on table "public"."housings" to "authenticated";

grant update on table "public"."housings" to "authenticated";

grant delete on table "public"."housings" to "service_role";

grant insert on table "public"."housings" to "service_role";

grant references on table "public"."housings" to "service_role";

grant select on table "public"."housings" to "service_role";

grant trigger on table "public"."housings" to "service_role";

grant truncate on table "public"."housings" to "service_role";

grant update on table "public"."housings" to "service_role";

grant delete on table "public"."messages" to "anon";

grant insert on table "public"."messages" to "anon";

grant references on table "public"."messages" to "anon";

grant select on table "public"."messages" to "anon";

grant trigger on table "public"."messages" to "anon";

grant truncate on table "public"."messages" to "anon";

grant update on table "public"."messages" to "anon";

grant delete on table "public"."messages" to "authenticated";

grant insert on table "public"."messages" to "authenticated";

grant references on table "public"."messages" to "authenticated";

grant select on table "public"."messages" to "authenticated";

grant trigger on table "public"."messages" to "authenticated";

grant truncate on table "public"."messages" to "authenticated";

grant update on table "public"."messages" to "authenticated";

grant delete on table "public"."messages" to "service_role";

grant insert on table "public"."messages" to "service_role";

grant references on table "public"."messages" to "service_role";

grant select on table "public"."messages" to "service_role";

grant trigger on table "public"."messages" to "service_role";

grant truncate on table "public"."messages" to "service_role";

grant update on table "public"."messages" to "service_role";

grant delete on table "public"."notifications" to "anon";

grant insert on table "public"."notifications" to "anon";

grant references on table "public"."notifications" to "anon";

grant select on table "public"."notifications" to "anon";

grant trigger on table "public"."notifications" to "anon";

grant truncate on table "public"."notifications" to "anon";

grant update on table "public"."notifications" to "anon";

grant delete on table "public"."notifications" to "authenticated";

grant insert on table "public"."notifications" to "authenticated";

grant references on table "public"."notifications" to "authenticated";

grant select on table "public"."notifications" to "authenticated";

grant trigger on table "public"."notifications" to "authenticated";

grant truncate on table "public"."notifications" to "authenticated";

grant update on table "public"."notifications" to "authenticated";

grant delete on table "public"."notifications" to "service_role";

grant insert on table "public"."notifications" to "service_role";

grant references on table "public"."notifications" to "service_role";

grant select on table "public"."notifications" to "service_role";

grant trigger on table "public"."notifications" to "service_role";

grant truncate on table "public"."notifications" to "service_role";

grant update on table "public"."notifications" to "service_role";

grant delete on table "public"."preferences" to "anon";

grant insert on table "public"."preferences" to "anon";

grant references on table "public"."preferences" to "anon";

grant select on table "public"."preferences" to "anon";

grant trigger on table "public"."preferences" to "anon";

grant truncate on table "public"."preferences" to "anon";

grant update on table "public"."preferences" to "anon";

grant delete on table "public"."preferences" to "authenticated";

grant insert on table "public"."preferences" to "authenticated";

grant references on table "public"."preferences" to "authenticated";

grant select on table "public"."preferences" to "authenticated";

grant trigger on table "public"."preferences" to "authenticated";

grant truncate on table "public"."preferences" to "authenticated";

grant update on table "public"."preferences" to "authenticated";

grant delete on table "public"."preferences" to "service_role";

grant insert on table "public"."preferences" to "service_role";

grant references on table "public"."preferences" to "service_role";

grant select on table "public"."preferences" to "service_role";

grant trigger on table "public"."preferences" to "service_role";

grant truncate on table "public"."preferences" to "service_role";

grant update on table "public"."preferences" to "service_role";

grant delete on table "public"."refresh_tokens" to "anon";

grant insert on table "public"."refresh_tokens" to "anon";

grant references on table "public"."refresh_tokens" to "anon";

grant select on table "public"."refresh_tokens" to "anon";

grant trigger on table "public"."refresh_tokens" to "anon";

grant truncate on table "public"."refresh_tokens" to "anon";

grant update on table "public"."refresh_tokens" to "anon";

grant delete on table "public"."refresh_tokens" to "authenticated";

grant insert on table "public"."refresh_tokens" to "authenticated";

grant references on table "public"."refresh_tokens" to "authenticated";

grant select on table "public"."refresh_tokens" to "authenticated";

grant trigger on table "public"."refresh_tokens" to "authenticated";

grant truncate on table "public"."refresh_tokens" to "authenticated";

grant update on table "public"."refresh_tokens" to "authenticated";

grant delete on table "public"."refresh_tokens" to "service_role";

grant insert on table "public"."refresh_tokens" to "service_role";

grant references on table "public"."refresh_tokens" to "service_role";

grant select on table "public"."refresh_tokens" to "service_role";

grant trigger on table "public"."refresh_tokens" to "service_role";

grant truncate on table "public"."refresh_tokens" to "service_role";

grant update on table "public"."refresh_tokens" to "service_role";

grant delete on table "public"."site_participants" to "anon";

grant insert on table "public"."site_participants" to "anon";

grant references on table "public"."site_participants" to "anon";

grant select on table "public"."site_participants" to "anon";

grant trigger on table "public"."site_participants" to "anon";

grant truncate on table "public"."site_participants" to "anon";

grant update on table "public"."site_participants" to "anon";

grant delete on table "public"."site_participants" to "authenticated";

grant insert on table "public"."site_participants" to "authenticated";

grant references on table "public"."site_participants" to "authenticated";

grant select on table "public"."site_participants" to "authenticated";

grant trigger on table "public"."site_participants" to "authenticated";

grant truncate on table "public"."site_participants" to "authenticated";

grant update on table "public"."site_participants" to "authenticated";

grant delete on table "public"."site_participants" to "service_role";

grant insert on table "public"."site_participants" to "service_role";

grant references on table "public"."site_participants" to "service_role";

grant select on table "public"."site_participants" to "service_role";

grant trigger on table "public"."site_participants" to "service_role";

grant truncate on table "public"."site_participants" to "service_role";

grant update on table "public"."site_participants" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant references on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";


