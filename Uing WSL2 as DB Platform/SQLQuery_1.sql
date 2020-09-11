USE [master]
Print '**'
go
PRINT '...Comencing Backup file tests process..'
go
RESTORE VERIFYONLY FROM DISK ='MIRROR_DWM_Local_FULL_20180801_203845.bak'
go
RESTORE VERIFYONLY FROM DISK ='MIRROR_Gt_Logistic_FULL_20180801_203845.bak'
go
RESTORE VERIFYONLY FROM DISK ='MIRROR_TSQL2012_FULL_20180801_203846.bak'
go
PRINT '...End of Backup file tests process..'

Print '**'
go
PRINT '...Comencing Refreshing DB process..'
go
PRINT 'Starting DWM refresh 1/3...'
go
RESTORE DATABASE [DWM_Local] FROM  DISK = N'/mnt/SQL/MIRROR_DWM_Local_FULL_20180801_203845.bak' 
WITH  FILE = 1,  MOVE N'DWM_Local' TO N'/var/opt/mssql/data/DWM_Local.mdf',  
MOVE N'DWM_Local_log' TO N'/var/opt/mssql/data/DWM_Local_log.ldf',  NOUNLOAD,  STATS = 5, REPLACE
go
PRINT 'Refresh DWM complete 1/3...'
go
PRINT 'Starting Gt_Logistic refresh 2/3...'
go
RESTORE DATABASE [Gt_Logistic] FROM  DISK = N'/mnt/SQL/MIRROR_Gt_Logistic_FULL_20180801_203845.bak' 
WITH  FILE = 1,  MOVE N'Gt_Logistic' TO N'/var/opt/mssql/data/Gt_Logistic.mdf',  
MOVE N'Gt_Logistic_log' TO N'/var/opt/mssql/data/Gt_Logistic_1.ldf',  NOUNLOAD,  STATS = 5, REPLACE
go
PRINT 'Refresh GT_Logistic complete 2/3...'
go
PRINT 'Starting TSQL2012 refresh 3/3...'
go
RESTORE DATABASE [TSQL2012] FROM  DISK = N'/mnt/SQL/MIRROR_TSQL2012_FULL_20180801_203846.bak' WITH  FILE = 1,
  MOVE N'TSQL2012' TO N'/var/opt/mssql/data/TSQL2012.mdf',  MOVE N'TSQL2012_log' TO N'/var/opt/mssql/data/TSQL2012_log.LDF',  
  NOUNLOAD,  STATS = 5, REPLACE
go
PRINT 'Refresh TSQL2012 Complete ...'
go
--db integrity checks
/*
Print '**'
go
PRINT 'Commencing DB integrity checks'
go
DBCC checkdb [DWM_Local]
go
DBCC checkdb [Gt_Logistic]
go
DBCC checkdb [TSQL2012]
go
PRINT 'End DB integrity checks'
go

*/

