# NEXT TASK

## Short-term (web, high value)
1. Low-stock alert — red badge list on admin (stock <= 5), maybe on kasir too
2. Cancel/Void sale (admin) — refund flow; sales.status already supports VOID/REFUND
3. Tambah User via Edge Function (owner-gated) — service_role server-side, caller must be admin id 4f3040fd-d930-4e84-b578-e798dcf68a7a, then call POST /auth/v1/admin/users

## Medium-term
4. Customer queue display screen (fn_next_queue already built for this)
5. Print receipt (58mm thermal)
6. Daily summary email / export CSV
7. Cashier shift/session login (ties into add-user feature)

## DB roadmap (create_sale) — DONE at v0.3.0.8
- v0.3.0.1 Skeleton
- v0.3.0.2 Request Validation
- v0.3.0.3 Product Validation
- v0.3.0.4 Stock Validation
- v0.3.0.5 Queue + Invoice
- v0.3.0.6 Insert Sales
- v0.3.0.7 Insert Sale Items
- v0.3.0.8 Update Stock (atomic pipeline complete)

## Flutter
- Port approved web design to Flutter + supabase_flutter (blocked until web design approved)
