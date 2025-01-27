GRANT USAGE ON SCHEMA public TO authenticated;
GRANT INSERT, SELECT, UPDATE, DELETE ON public.users TO authenticated;

CREATE POLICY "Users can manage their own data" ON "users"
FOR ALL
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);
