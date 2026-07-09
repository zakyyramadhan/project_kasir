CREATE OR REPLACE FUNCTION public.fn_generate_invoice(
    p_sale_date DATE,
    p_queue_no INTEGER
)
RETURNS TEXT
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
    RETURN format('%s-%s',to_char(p_sale_date,'YYYYMMDD'),lpad(p_queue_no::text,3,'0'));
END;
$$;