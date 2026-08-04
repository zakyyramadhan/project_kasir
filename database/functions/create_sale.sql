-- v0.3.0.8 — create_sale full pipeline (atomic)
-- Receives: create_sale(payload jsonb)
-- Pipeline: request validation -> product validation -> stock validation
--           -> queue + invoice -> insert sales + sale_items -> decrement stock
-- One transaction: any failure rolls back everything (no partial stock drops).

CREATE OR REPLACE FUNCTION public.create_sale(payload jsonb)
RETURNS jsonb
LANGUAGE plpgsql
AS $function$
DECLARE
    v_payment_method text;
    v_item_count     integer;
    v_cart           jsonb;
    v_item           jsonb;
    v_product_id     uuid;
    v_qty            integer;
    v_product        record;
    v_sale_date      date    := CURRENT_DATE;
    v_queue_no       integer;
    v_invoice_no     text;
    v_sale_id        uuid;
    v_total          numeric := 0;
BEGIN
    -- ============ REQUEST VALIDATION ============
    v_payment_method := payload->>'payment_method';
    IF v_payment_method IS NULL OR trim(v_payment_method) = '' THEN
        RETURN jsonb_build_object('success', false, 'error', 'PAYMENT_METHOD_REQUIRED');
    END IF;
    IF v_payment_method NOT IN ('Cash','QRIS','Debit','Transfer') THEN
        RETURN jsonb_build_object('success', false, 'error', 'INVALID_PAYMENT_METHOD');
    END IF;

    v_cart := payload->'items';
    IF v_cart IS NULL OR jsonb_typeof(v_cart) <> 'array' THEN
        RETURN jsonb_build_object('success', false, 'error', 'ITEMS_MUST_BE_ARRAY');
    END IF;
    v_item_count := jsonb_array_length(v_cart);
    IF v_item_count = 0 THEN
        RETURN jsonb_build_object('success', false, 'error', 'EMPTY_CART');
    END IF;

    -- ============ PER-ITEM VALIDATION (product + stock) ============
    FOR v_item IN SELECT * FROM jsonb_array_elements(v_cart)
    LOOP
        IF (v_item->>'qty') IS NULL OR (v_item->>'qty')::integer <= 0 THEN
            RETURN jsonb_build_object('success', false, 'error', 'INVALID_QTY',
                                      'product_id', v_item->>'product_id');
        END IF;

        BEGIN
            v_product_id := (v_item->>'product_id')::uuid;
        EXCEPTION WHEN invalid_text_representation THEN
            RETURN jsonb_build_object('success', false, 'error', 'INVALID_PRODUCT_ID',
                                      'product_id', v_item->>'product_id');
        END;

        SELECT id, name, sale_price, stock, is_active
          INTO v_product
          FROM public.products
         WHERE id = v_product_id;

        IF NOT FOUND THEN
            RETURN jsonb_build_object('success', false, 'error', 'PRODUCT_NOT_FOUND',
                                      'product_id', v_product_id);
        END IF;
        IF NOT v_product.is_active THEN
            RETURN jsonb_build_object('success', false, 'error', 'PRODUCT_INACTIVE',
                                      'product_id', v_product_id, 'name', v_product.name);
        END IF;

        -- v0.3.0.4: stock validation (stock tidak boleh minus)
        v_qty := (v_item->>'qty')::integer;
        IF v_qty > v_product.stock THEN
            RETURN jsonb_build_object('success', false, 'error', 'INSUFFICIENT_STOCK',
                                      'product_id', v_product_id,
                                      'name', v_product.name,
                                      'requested', v_qty,
                                      'available', v_product.stock);
        END IF;

        v_total := v_total + (v_qty * v_product.sale_price);
    END LOOP;

    -- ============ QUEUE + INVOICE (v0.3.0.5) ============
    v_queue_no := public.fn_next_queue(v_sale_date);
    v_invoice_no := public.fn_generate_invoice(v_sale_date, v_queue_no);

    -- ============ INSERT SALES HEADER (v0.3.0.6) ============
    INSERT INTO public.sales (queue_no, sale_date, invoice_no, total, payment_method, status)
    VALUES (v_queue_no, v_sale_date, v_invoice_no, v_total, v_payment_method, 'PAID')
    RETURNING id INTO v_sale_id;

    -- ============ INSERT SALE ITEMS + DECREMENT STOCK (v0.3.0.7-8) ============
    FOR v_item IN SELECT * FROM jsonb_array_elements(v_cart)
    LOOP
        v_product_id := (v_item->>'product_id')::uuid;
        v_qty := (v_item->>'qty')::integer;

        INSERT INTO public.sale_items (sale_id, product_id, qty, price, subtotal, notes)
        SELECT v_sale_id, p.id, v_qty, p.sale_price, v_qty * p.sale_price, v_item->>'notes'
          FROM public.products p WHERE p.id = v_product_id;

        UPDATE public.products
           SET stock = stock - v_qty,
               updated_at = now()
         WHERE id = v_product_id;
    END LOOP;

    -- ============ RESULT ============
    RETURN jsonb_build_object(
        'success', true,
        'sale_id', v_sale_id,
        'invoice_no', v_invoice_no,
        'queue_no', v_queue_no,
        'sale_date', v_sale_date,
        'total', v_total,
        'payment_method', v_payment_method,
        'item_count', v_item_count
    );
END;
$function$;