CREATE TRIGGER clean_expired_simulations AFTER INSERT OR UPDATE ON public.aid_simulation FOR EACH ROW EXECUTE FUNCTION delete_expired_simulations();


