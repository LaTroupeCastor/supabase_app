 ALTER TABLE "users" ENABLE ROW LEVEL SECURITY;                                                                                                                                     

  CREATE POLICY "Enable insert for authenticated users" ON "users"                                                                                                                       
 FOR INSERT                                                                                                                                                                             
 TO authenticated                                                                                                                                                                       
 WITH CHECK (true);
