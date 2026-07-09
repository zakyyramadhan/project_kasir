SELECT public.create_sale(
'{
 "payment_method":"Cash",
 "items":[
   {
     "product_id":"00000000-0000-0000-0000-000000000001",
     "qty":2,
     "notes":"Pedas"
   }
 ]
}'::jsonb
);