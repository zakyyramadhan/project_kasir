# CURRENT STATE
Version: v0.3.0.3 (DB) / v0.3.0.2-ui+ (Web)

## Database
- [x] Schema: products, sales, sale_items, queue_counters
- [x] Queue Engine (fn_next_queue, UPSERT, daily reset)
- [x] Invoice Generator (fn_generate_invoice -> YYYYMMDD-###)
- [x] Sales Finalization
- [x] create_sale() skeleton + request validation (payment, empty cart, qty)
- [x] v0.3.0.3 Product Validation: PRODUCT_NOT_FOUND / PRODUCT_INACTIVE / INVALID_QTY / INVALID_PRODUCT_ID + load sale_price & stock
- [x] products.emoji column added (for web UI thumbnails)
- [x] RLS on products: anon read-only, authenticated CRUD (admin)
- [ ] v0.3.0.4 Stock Validation (qty <= stock, INSUFFICIENT_STOCK)
- [ ] v0.3.0.5 Queue + Invoice inside create_sale()
- [ ] v0.3.0.6 Insert Sales header
- [ ] v0.3.0.7 Insert Sale Items
- [ ] v0.3.0.8 Update Stock / finalize

## Web (branch: frontend/web-prototype)
- [x] index.html — kasir UI (product grid, cart, payment, receipt) white theme, live Supabase + demo fallback
- [x] admin.html — Supabase Auth login + product CRUD (white theme, centered, emoji dropdown)
- [x] Gear icon on kasir, shown ONLY to admin user (auth-gated)
- [x] Auth user: zakyyramadhan@gmail.com (owner/admin)
- [ ] Tambah User from admin (needs Edge Function — auth.admin_create_user removed on PG17.6)
- [ ] Wire "Bayar" to create_sale() RPC (once v0.3.0.5+ lands)
