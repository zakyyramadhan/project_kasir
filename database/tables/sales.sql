CREATE TABLE public.sales (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  queue_no integer NOT NULL,
  sale_date date NOT NULL DEFAULT CURRENT_DATE,
  invoice_no text NOT NULL,
  total numeric(12,2) NOT NULL DEFAULT 0,
  payment_method text NOT NULL DEFAULT 'Cash',
  status text NOT NULL DEFAULT 'PAID',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT sales_invoice_no_unique UNIQUE(invoice_no),
  CONSTRAINT sales_sale_date_queue_unique UNIQUE(sale_date,queue_no),
  CONSTRAINT sales_total_check CHECK(total>=0),
  CONSTRAINT sales_payment_method_check CHECK(payment_method IN ('Cash','QRIS','Debit','Transfer')),
  CONSTRAINT sales_status_check CHECK(status IN ('PAID','VOID','REFUND'))
);