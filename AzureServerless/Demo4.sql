-- Memory Clerks
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

WITH mem
AS (
	SELECT [type] = COALESCE([type], 'Total')
		,SUM(virtual_memory_committed_kb + shared_memory_committed_kb + awe_allocated_kb) / 1024 Virt_MB
		,SUM(pages_kb) / 1024 Pages_MB
		,(SUM(virtual_memory_committed_kb + shared_memory_committed_kb + awe_allocated_kb + pages_kb)) / 1024 Total_MB
	FROM sys.dm_os_memory_clerks
	GROUP BY GROUPING SETS(([type]), ())
	)
SELECT TOP 11 
	 [type]
	,Virt_MB
	,Pages_MB
	,Total_MB
	,CAST((
		SELECT Total_MB / (
							SELECT Total_MB * 1.
							FROM mem
							WHERE [type] = 'total'
							) * 100
		FROM mem a
		WHERE a.[type] = mem.[type]
		) AS DECIMAL(5,2)) [%]
FROM mem
ORDER BY Total_MB DESC;

--AVG Resource use
SELECT  
    AVG(avg_cpu_percent) AS 'Average CPU use in percent',
    MAX(avg_cpu_percent) AS 'Maximum CPU use in percent',
    AVG(avg_data_io_percent) AS 'Average data IO in percent',
    MAX(avg_data_io_percent) AS 'Maximum data IO in percent',
    AVG(avg_log_write_percent) AS 'Average log write use in percent',
    MAX(avg_log_write_percent) AS 'Maximum log write use in percent',
    AVG(avg_memory_usage_percent) AS 'Average memory use in percent',
    MAX(avg_memory_usage_percent) AS 'Maximum memory use in percent'
FROM sys.dm_db_resource_stats;  

--Wait Events
SELECT wait_type,
       SUM(wait_time) AS total_wait_time_ms
FROM sys.dm_exec_requests AS req
    JOIN sys.dm_exec_sessions AS sess
        ON req.session_id = sess.session_id
WHERE is_user_process = 1
GROUP BY wait_type
ORDER BY SUM(wait_time) DESC;
--Max DOP
SELECT *--[value] 
FROM sys.database_scoped_configurations WHERE [name] = 'MAXDOP';

--Query Plan SQL Handle
SELECT plan_handle, execution_count, query_plan
INTO #tmpPlan
FROM sys.dm_exec_query_stats
     CROSS APPLY sys.dm_exec_query_plan(plan_handle);
GO

WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS sp)
SELECT plan_handle, stmt.stmt_details.value('@Database', 'varchar(max)') 'Database', stmt.stmt_details.value('@Schema', 'varchar(max)') 'Schema', stmt.stmt_details.value('@Table', 'varchar(max)') 'table'
INTO #tmp2
FROM(SELECT CAST(query_plan AS XML) sqlplan, plan_handle FROM #tmpPlan) AS p
    CROSS APPLY sqlplan.nodes('//sp:Object') AS stmt(stmt_details);
GO

SELECT t.plan_handle, [Database], [Schema], [table], execution_count
FROM(SELECT DISTINCT plan_handle, [Database], [Schema], [table]
     FROM #tmp2
     WHERE [table] LIKE '%@%' OR [table] LIKE '%#%') AS t
    JOIN #tmpPlan AS t2 ON t.plan_handle=t2.plan_handle;