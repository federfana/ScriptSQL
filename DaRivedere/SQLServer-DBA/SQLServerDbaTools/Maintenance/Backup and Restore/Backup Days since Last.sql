SELECT Database_Name,
CONVERT( SmallDateTime , MAX(Backup_Finish_Date)) as Last_Backup, 
DATEDIFF(d, MAX(Backup_Finish_Date), Getdate()) as Days_Since_Last
FROM MSDB.dbo.BackupSet
WHERE Type = 'd'
GROUP BY Database_Name