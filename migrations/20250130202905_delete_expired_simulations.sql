set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.delete_expired_simulations()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
    DELETE FROM aid_simulation
    WHERE expiration_date <= NOW();
    RETURN NEW;
END;$function$
;


