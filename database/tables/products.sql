create table public.products (
  id uuid not null default gen_random_uuid (),
  sku text not null default ''::text,
  name text not null default ''::text,
  sale_price numeric not null default '0'::numeric,
  cost_price numeric not null default '0'::numeric,
  stock integer not null default 0,
  is_active boolean not null default true,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  constraint Product_pkey primary key (id),
  constraint products_sku_key unique (sku)
) TABLESPACE pg_default;