Use msdb
GO

SELECT 
    SJ.NAME AS [Job Name]
    ,RUN_STATUS AS [Run Status]
    ,MAX(DBO.AGENT_DATETIME(RUN_DATE, RUN_TIME)) AS [Last Time Job Ran On]
FROM 
    dbo.SYSJOBS SJ 
        LEFT OUTER JOIN dbo.SYSJOBHISTORY JH
    ON SJ.job_id = JH.job_id
        WHERE JH.step_id = 0
            AND jh.run_status = 1
                GROUP BY SJ.name, JH.run_status 
                    ORDER BY [Last Time Job Ran On] DESC
GO