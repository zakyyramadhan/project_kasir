create table public.sales (
  id uuid not null default gen_random_uuid (),
  queue_no integer null,
  sale_date date not null default CURRENT_DATE,
  invoice_no text null,
  total numeric not null default '0'::numeric,
  payment_method text not null default 'Cash'::text,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  constraint sales_pkey primary key (id),
  constraint sales_invoice_no_key unique (invoice_no),
  constraint sales_invoice_no_unique unique (invoice_no),
  constraint sales_sale_date_queue_unique unique (sale_date, queue_no)
) TABLESPACE pg_default;

create trigger before_insert_sales BEFORE INSERT on sales for EACH row
execute FUNCTION generate_sales_invoice ();