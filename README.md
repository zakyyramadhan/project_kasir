# Kasir Seblak

Snapshot Version: v0.3.0.3

Architecture:
Flutter -> Supabase RPC -> PostgreSQL

Business logic resides in PostgreSQL.

## Web (branch: frontend/web-prototype)
- web/index.html — Kasir POS UI (product grid, cart, payment)
- web/admin.html — Admin: Supabase Auth login + product CRUD
- Gear icon on kasir visible only to admin user

## Quick start (web)
1. git pull origin frontend/web-prototype
2. Open web/index.html (kasir) or web/admin.html (admin, needs login)
