--http://www.jasonstrate.com/2009/04/find-query-plans-that-may-utilize-parallelism/
WITH cQueryStats
AS (
SELECT qs.plan_handle
,MAX(qs.execution_count) as execution_count
,SUM(qs.total_worker_time) as total_worker_time
,SUM(qs.total_logical_reads) as total_logical_reads
,SUM(qs.total_elapsed_time) as total_elapsed_time
FROM sys.dm_exec_query_stats qs
GROUP BY qs.plan_handle
)
SELECT TOP 50
OBJECT_NAME(p.objectid, p.dbid) as [object_name] ,qs.execution_count
,qs.total_worker_time
,qs.total_logical_reads
,qs.total_elapsed_time
,p.query_plan
,q.text
,cp.plan_handle
FROM cQueryStats qs
INNER JOIN sys.dm_exec_cached_plans cp ON qs.plan_handle = cp.plan_handle
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) p
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) as q
WHERE cp.cacheobjtype = 'Compiled Plan'
AND p.query_plan.value('declare namespace p="http://schemas.microsoft.com/sqlserver/2004/07/showplan";max(//p:RelOp/@Parallel)', 'float') > 0
ORDER BY qs.total_worker_time/qs.execution_count DESC
