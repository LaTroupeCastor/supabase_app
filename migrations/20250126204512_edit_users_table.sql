ALTER TABLE "users"                                                                                                                                                                    
   ALTER COLUMN "first_name" DROP NOT NULL,                                                                                                                                             
   ALTER COLUMN "last_name" DROP NOT NULL,                                                                                                                                              
   ALTER COLUMN "username" DROP NOT NULL,                                                                                                                                               
   ALTER COLUMN "password_hash" DROP NOT NULL;
