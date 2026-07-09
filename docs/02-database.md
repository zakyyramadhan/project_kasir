# Database

Tables:
- products
- sales
- sale_items
- queue_counters (v0.2.1)

## queue_counters
- sale_date (PK)
- last_queue
- updated_at

## Function
- fn_next_queue(p_sale_date DATE DEFAULT CURRENT_DATE)
- Menggunakan UPSERT untuk concurrency-safe queue.
