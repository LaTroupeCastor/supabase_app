set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_aid_eligibility_summary(p_simulation_id uuid)
 RETURNS TABLE(total_possible_amount numeric, total_adjusted_amount numeric, eligible_aids_count integer, all_required_documents text[])
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
    RETURN QUERY
    WITH eligible_aids AS (
        SELECT * FROM check_aid_eligibility(p_simulation_id)
    ),
    unnested_docs AS (
        SELECT DISTINCT unnest(required_documents) as doc
        FROM eligible_aids
    ),
    aid_counts AS (
        SELECT 
            COALESCE(SUM(CASE WHEN max_amount > 0 THEN max_amount ELSE default_amount END), 0)::numeric(12,2) as total_possible,
            COALESCE(SUM(adjusted_amount), 0)::numeric(12,2) as total_adjusted,
            COUNT(*)::integer as aid_count
        FROM eligible_aids
    )
    SELECT 
        ac.total_possible,
        ac.total_adjusted,
        ac.aid_count,
        ARRAY(SELECT DISTINCT ud.doc FROM unnested_docs ud ORDER BY ud.doc)
    FROM aid_counts ac
    GROUP BY ac.total_possible, ac.total_adjusted, ac.aid_count;
END;
$function$
;


