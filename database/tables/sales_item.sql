create table public.sale_items (
  id uuid not null default gen_random_uuid (),
  sale_id uuid not null,
  product_id uuid not null,
  qty integer not null,
  price numeric not null default '0'::numeric,
  subtotal numeric not null default '0'::numeric,
  created_at timestamp with time zone not null default now(),
  notes text null,
  constraint sale_items_pkey primary key (id),
  constraint sale_items_product_id_fkey foreign KEY (product_id) references products (id) on update RESTRICT,
  constraint sale_items_sale_id_fkey foreign KEY (sale_id) references sales (id) on delete CASCADE
) TABLESPACE pg_default;