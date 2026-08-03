-- v0.3.0.3 Product Validation
-- Receives: create_sale(p_payload jsonb)
-- Current features:
--  * request validation (payment method, empty cart, qty)
--  * product validation (exists, active, price + stock load)
-- Next (v0.3.0.4): stock validation

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
    v_enriched_items jsonb := '[]'::jsonb;
BEGIN
    -- ============ REQUEST VALIDATION ============

    -- 1. Payment method wajib ada
    v_payment_method := payload->>'payment_method';
    IF v_payment_method IS NULL OR trim(v_payment_method) = '' THEN
        RETURN jsonb_build_object('success', false, 'error', 'PAYMENT_METHOD_REQUIRED');
    END IF;

    -- 2. Items wajib ada & tidak kosong
    v_cart := payload->'items';
    IF v_cart IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'ITEMS_REQUIRED');
    END IF;
    IF jsonb_typeof(v_cart) <> 'array' THEN
        RETURN jsonb_build_object('success', false, 'error', 'ITEMS_MUST_BE_ARRAY');
    END IF;
    v_item_count := jsonb_array_length(v_cart);
    IF v_item_count = 0 THEN
        RETURN jsonb_build_object('success', false, 'error', 'EMPTY_CART');
    END IF;

    -- ============ PRODUCT VALIDATION (v0.3.0.3) ============
    -- Iterasi setiap item: pastikan produk ada, aktif, dan ambil harga jual + stock.

    FOR v_item IN SELECT * FROM jsonb_array_elements(v_cart)
    LOOP
        -- qty wajib > 0
        IF (v_item->>'qty') IS NULL OR (v_item->>'qty')::integer <= 0 THEN
            RETURN jsonb_build_object('success', false, 'error', 'INVALID_QTY',
                                      'product_id', v_item->>'product_id');
        END IF;

        -- product_id wajib ada (dan valid uuid)
        BEGIN
            v_product_id := (v_item->>'product_id')::uuid;
        EXCEPTION WHEN invalid_text_representation THEN
            RETURN jsonb_build_object('success', false, 'error', 'INVALID_PRODUCT_ID',
                                      'product_id', v_item->>'product_id');
        END;
        IF v_product_id IS NULL THEN
            RETURN jsonb_build_object('success', false, 'error', 'PRODUCT_ID_REQUIRED');
        END IF;

        -- Cek produk ada
        SELECT id, name, sale_price, stock, is_active
          INTO v_product
          FROM public.products
         WHERE id = v_product_id;

        IF NOT FOUND THEN
            RETURN jsonb_build_object('success', false, 'error', 'PRODUCT_NOT_FOUND',
                                      'product_id', v_product_id);
        END IF;

        -- Cek produk aktif
        IF NOT v_product.is_active THEN
            RETURN jsonb_build_object('success', false, 'error', 'PRODUCT_INACTIVE',
                                      'product_id', v_product_id,
                                      'name', v_product.name);
        END IF;

        -- Load sale_price + stock, perbaiki quantity, garis bawahi untuk tahap berikut
        v_enriched_items := v_enriched_items || jsonb_build_object(
            'product_id', v_product_id,
            'name',       v_product.name,
            'qty',        (v_item->>'qty')::integer,
            'sale_price', v_product.sale_price,
            'stock',      v_product.stock,
            'notes',      v_item->>'notes'
        );
    END LOOP;

    -- Validasi selesai (produk valid). Insert/finalisasi ada di v0.3.0.4+.
    RETURN jsonb_build_object(
        'success', true,
        'payment_method', v_payment_method,
        'item_count', v_item_count,
        'items', v_enriched_items
    );
END;
$function$;