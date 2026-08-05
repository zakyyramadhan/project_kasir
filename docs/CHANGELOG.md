# CHANGELOG

## Database
- v0.2.1 Queue Engine
- v0.2.2 Invoice Generator
- v0.2.3 Sales Finalization
- v0.3.0.1 create_sale Skeleton
- v0.3.0.2 Request Validation
- v0.3.0.3 Product Validation (exists/active/price/stock)
- v0.3.0.4 Stock Validation (INSUFFICIENT_STOCK)
- v0.3.0.5 Queue + Invoice inside create_sale
- v0.3.0.6 Insert Sales header
- v0.3.0.7 Insert Sale Items
- v0.3.0.8 Update Stock — full atomic pipeline COMPLETE
- products.emoji column
- RLS: products read-only anon / CRUD authenticated; sales+sale_items read-only authenticated

## Web (frontend/web-prototype)
- Kasir UI (index.html) — product grid, cart, payment
- Cash payment: Uang Dibayar input + live Kembalian + validation + receipt lines
- Pay -> create_sale RPC (real invoice, queue, stock decrement)
- Admin page (admin.html) — Auth login, product CRUD, emoji dropdown
- White theme, centered layout
- Gear icon gated to admin user
- Sales history + daily report (date filter, revenue, items, profit)
