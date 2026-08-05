# CURRENT STATE
Version: v0.3.0.8 (DB) / v0.3.0.2-ui+ (Web)

## Database
- [x] Schema: products, sales, sale_items, queue_counters
- [x] Queue Engine (fn_next_queue, UPSERT, daily reset)
- [x] Invoice Generator (fn_generate_invoice -> YYYYMMDD-###)
- [x] create_sale full pipeline (v0.3.0.8):
  - [x] request validation (payment method, empty cart, qty)
  - [x] product validation (PRODUCT_NOT_FOUND / PRODUCT_INACTIVE)
  - [x] stock validation (INSUFFICIENT_STOCK, stock never minus)
  - [x] queue + invoice generation inside create_sale
  - [x] insert sales header + sale_items
  - [x] decrement stock atomically (single transaction)
- [x] products.emoji column
- [x] RLS: products anon read / authenticated CRUD; sales+sale_items authenticated read only (anon -> [])

## Web (branch: frontend/web-prototype)
- [x] index.html — kasir UI (white theme)
  - [x] product grid (live Supabase + demo fallback)
  - [x] cart with qty controls
  - [x] payment methods (Cash/QRIS/Debit)
  - [x] cash: Uang Dibayar input + live Kembalian calc + validation (paid >= total)
  - [x] Pay -> create_sale RPC (real invoice, queue, stock decrement)
  - [x] receipt shows Dibayar + Kembalian (cash)
  - [x] gear icon to admin, shown only to admin user (auth-gated)
- [x] admin.html — admin dashboard (white theme, centered)
  - [x] Supabase Auth login
  - [x] product CRUD with emoji dropdown
  - [x] tabs: Produk | Riwayat Penjualan
  - [x] sales history + daily report (date filter, revenue, items, profit)
  - [ ] Tambah User (needs Edge Function — auth.admin_create_user removed on PG 17.6)
- [x] Auth user: zakyyramadhan@gmail.com (owner/admin)

## Open / blocked
- [ ] Tambah User from admin — Edge Function required (service_role must stay server-side)
- [ ] Flutter port (after design approval)
