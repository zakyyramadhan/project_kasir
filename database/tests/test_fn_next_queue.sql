DELETE FROM queue_counters;
SELECT fn_next_queue();
SELECT fn_next_queue();
SELECT fn_next_queue();
SELECT * FROM queue_counters;