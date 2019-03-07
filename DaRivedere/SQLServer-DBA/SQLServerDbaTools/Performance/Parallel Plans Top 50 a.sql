--http://www.jasonstrate.com/2009/04/find-query-plans-that-may-utilize-parallelism/
SELECT TOP 50
OBJECT_NAME(p.objectid, p.dbid) as [object_name]
,qs.execution_count
,qs.total_worker_time
,qs.total_logical_reads
,qs.total_elapsed_time
,CASE statement_end_offset WHEN -1 THEN q.text
ELSE SUBSTRING(q.text, statement_start_offset/2, (statement_end_offset-statement_start_offset)/2) END as sql_statement
,p.query_plan
,q.text
,cp.plan_handle
FROM sys.dm_exec_query_stats qs
INNER JOIN sys.dm_exec_cached_plans cp ON qs.plan_handle = cp.plan_handle
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) p
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) as q
WHERE cp.cacheobjtype = 'Compiled Plan'
AND p.query_plan.value('declare namespace p="http://schemas.microsoft.com/sqlserver/2004/07/showplan";max(//p:RelOp/@Parallel)', 'float') > 0
ORDER BY qs.total_worker_time/qs.execution_count DESC
