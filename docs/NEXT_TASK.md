# NEXT TASK

## v0.3.0.4 — Stock Validation (create_sale)
1. Compare requested qty vs product.stock (loaded in v0.3.0.3)
2. Return INSUFFICIENT_STOCK if qty > stock
3. Stock tidak boleh minus (business rule)

## v0.3.0.5 — Queue + Invoice
1. Call fn_next_queue() -> queue_no
2. Call fn_generate_invoice(sale_date, queue_no) -> invoice_no
3. Stamp on the sale

## v0.3.0.6-8 — Finalization
- Insert sales header + sale_items, then decrement stock atomically

## Web — Tambah User (owner-gated)
- auth.admin_create_user() does NOT exist on this Supabase (PG 17.6)
- Fix: Supabase Edge Function (Deno) holding service_role; validate caller == admin id 4f3040fd-d930-4e84-b578-e798dcf68a7a; call POST /auth/v1/admin/users
- Then wire admin.html "👥 Tambah User" to the edge function
