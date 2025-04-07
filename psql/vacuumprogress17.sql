SELECT p.pid,
       now() - a.xact_start AS duration,
       coalesce(wait_event_type ||'.'|| wait_event, 'f') AS waiting,
       CASE
           WHEN a.query ~*'^autovacuum.*to prevent wraparound' THEN 'wraparound'
           WHEN a.query ~*'^vacuum' THEN 'user'
           ELSE 'regular'
       END AS MODE,
       p.datname AS DATABASE,
       p.relid::regclass AS TABLE,
       p.phase,
       pg_size_pretty(p.heap_blks_total * current_setting('block_size')::int) AS table_size,
       pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
       pg_size_pretty(p.heap_blks_scanned * current_setting('block_size')::int) AS scanned,
       pg_size_pretty(p.heap_blks_vacuumed * current_setting('block_size')::int) AS vacuumed,
       round(100.0 * p.heap_blks_scanned / p.heap_blks_total, 1) AS scanned_pct,
       round(100.0 * p.heap_blks_vacuumed / p.heap_blks_total, 1) AS vacuumed_pct,
       p.index_vacuum_count,
       round(100.0 * p.dead_tuple_bytes / p.max_dead_tuple_bytes, 1) AS dead_pct
FROM pg_stat_progress_vacuum p
JOIN pg_stat_activity a USING (pid)
ORDER BY now() - a.xact_start DESC;
