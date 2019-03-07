SELECT
qs.total_worker_time,
qs.total_elapsed_time,
qs.sql_handle,
qs.statement_start_offset,
qs.statement_end_offset,
q.dbid,
q.objectid,
q.number,
q.encrypted,
q.TEXT
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) AS q
WHERE qs.total_worker_time > qs.total_elapsed_time