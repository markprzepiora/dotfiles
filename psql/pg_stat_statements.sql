SELECT
  query,
  calls,
  ROUND((total_plan_time + total_exec_time) / calls) AS avg_time_ms,
  ROUND((total_plan_time + total_exec_time) / 60000) AS total_time_min
FROM pg_stat_statements
ORDER BY total_plan_time + total_exec_time DESC
LIMIT 40;
