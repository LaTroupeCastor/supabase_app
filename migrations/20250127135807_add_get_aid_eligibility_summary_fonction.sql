set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_aid_eligibility_summary(simulation_id uuid)
 RETURNS TABLE(total_possible_amount numeric, eligible_aids_count integer, all_required_documents text[])
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
    RETURN QUERY
    WITH eligible_aids AS (
        SELECT * FROM check_aid_eligibility(simulation_id)
    )
    SELECT 
        COALESCE(SUM(CASE WHEN max_amount > 0 THEN max_amount ELSE default_amount END), 0),
        COUNT(*)::integer,
        array_agg(DISTINCT unnest(required_documents))
    FROM eligible_aids;
END;
$function$
;


