# Architecture

Flutter -> RPC create_sale() -> PostgreSQL

Queue dihasilkan melalui helper fn_next_queue() dengan tabel queue_counters.
