# Kasir Seblak

Snapshot Version: v0.3.0.8

Architecture:
Flutter -> Supabase RPC -> PostgreSQL

Business logic resides in PostgreSQL.

## Web (branch: frontend/web-prototype)
- web/index.html — Kasir POS UI (product grid, cart, cash+kembalian, payment)
- web/admin.html — Admin: Auth login, product CRUD, sales history + daily report
- Gear icon on kasir visible only to admin user

## Quick start (web)
1. git pull origin frontend/web-prototype
2. Open web/index.html (kasir) or web/admin.html (admin, needs login)

## Database
- create_sale() — full atomic pipeline: validate -> stock check -> queue + invoice -> insert sale/items -> decrement stock
- fn_next_queue() — UPSERT, concurrency-safe, daily reset
- fn_generate_invoice() — YYYYMMDD-###
