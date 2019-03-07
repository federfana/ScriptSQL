SELECT  sd.name AS [Database],
        CASE WHEN bs.type = 'D' THEN 'Full backup'
             WHEN bs.type = 'I' THEN 'Differential'
             WHEN bs.type = 'L' THEN 'Log'
             WHEN bs.type = 'F' THEN 'File/Filegroup'
             WHEN bs.type = 'G' THEN 'Differential file'
             WHEN bs.type = 'P' THEN 'Partial'
             WHEN bs.type = 'Q' THEN 'Differential partial'
             ELSE 'Unknown (' + bs.type + ')'
        END AS [Backup Type],
        bs.backup_start_date AS [Date]
FROM    master..sysdatabases sd
        LEFT OUTER JOIN msdb..backupset bs ON RTRIM(bs.database_name) = RTRIM(sd.name)
        LEFT OUTER JOIN msdb..backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
ORDER BY sd.name, [Date]