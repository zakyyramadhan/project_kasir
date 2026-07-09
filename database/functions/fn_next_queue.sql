CREATE OR REPLACE FUNCTION public.fn_next_queue(
    p_sale_date DATE DEFAULT CURRENT_DATE
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_next_queue INTEGER;
BEGIN
    INSERT INTO public.queue_counters(sale_date,last_queue)
    VALUES (p_sale_date,1)
    ON CONFLICT (sale_date)
    DO UPDATE
    SET last_queue=queue_counters.last_queue+1,
        updated_at=NOW()
    RETURNING last_queue INTO v_next_queue;

    RETURN v_next_queue;
END;
$$;