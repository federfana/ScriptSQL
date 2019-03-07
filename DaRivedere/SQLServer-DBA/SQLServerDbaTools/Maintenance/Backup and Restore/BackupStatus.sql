SELECT m.name AS DatabaseName, DATABASEPROPERTYEX(m.name, 'Recovery') AS RecoveryMode,
 CASE WHEN ISNULL(MAX(b.backup_finish_date), GETDATE()-10000) < GETDATE()-7 
    AND b.[type] = 'D' THEN 'Problem!' 
   WHEN ISNULL(MAX(b.backup_finish_date), GETDATE()-10000) < GETDATE()-2 
     AND b.[type] = 'I' THEN 'Problem!' 
   WHEN ISNULL(MAX(b.backup_finish_date), GETDATE()-10000) < GETDATE()-1 
     AND b.[type] = 'L' THEN 'Problem!' 
   ELSE 'OK' END AS BackupStatus,
    CASE WHEN b.[type] = 'D'  THEN 'Full' 
   WHEN b.[type] = 'I'  THEN 'Differential'
   WHEN b.[type] = 'L'  THEN 'Transaction Log'  END AS BackupType, 
 MAX(b.backup_finish_date) AS backup_finish_date
  FROM master.sys.databases m LEFT JOIN msdb.dbo.backupset b
  ON m.name = b.database_name 
WHERE m.database_id NOT IN (2,3) 
  AND DATABASEPROPERTYEX(m.name, 'Updateability') <> 'READ_ONLY'
GROUP BY m.name, b.[type] 
HAVING ISNULL(MAX(b.backup_finish_date), GETDATE()-11) > GETDATE() - 10 
  OR MAX(b.backup_finish_date) IS NULL
ORDER BY m.name, backup_finish_date 