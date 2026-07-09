CREATE TABLE public.queue_counters (
  sale_date date not null,
  last_queue integer not null default 0,
  updated_at timestamp with time zone not null default now(),
  constraint queue_counters_pkey primary key (sale_date)
);