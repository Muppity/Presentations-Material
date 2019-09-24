USE [master]
RESTORE DATABASE [DWM_Local] FROM  DISK = N'/mnt/share/MIRROR/DWM_Local/FULL/MIRROR_DWM_Local_FULL_20180801_203845.bak' WITH  FILE = 1,  MOVE N'DWM_Local' TO N'/var/opt/mssql/data/DWM_Local.mdf',  MOVE N'DWM_Local_log' TO N'/var/opt/mssql/data/DWM_Local_log.ldf',  NOUNLOAD,  STATS = 5

RESTORE DATABASE [Gt_Logistic] FROM  DISK = N'/mnt/share/MIRROR/Gt_Logistic/FULL/MIRROR_Gt_Logistic_FULL_20180801_203845.bak' WITH  FILE = 1,  MOVE N'Gt_Logistic' TO N'/var/opt/mssql/data/Gt_Logistic.mdf',  MOVE N'Gt_Logistic_log' TO N'/var/opt/mssql/data/Gt_Logistic_1.ldf',  NOUNLOAD,  STATS = 5

RESTORE DATABASE [TSQL2012] FROM  DISK = N'/mnt/share/MIRROR/TSQL2012/FULL/MIRROR_TSQL2012_FULL_20180801_203846.bak' WITH  FILE = 1,  MOVE N'TSQL2012' TO N'/var/opt/mssql/data/TSQL2012.mdf',  MOVE N'TSQL2012_log' TO N'/var/opt/mssql/data/TSQL2012_log.LDF',  NOUNLOAD,  STATS = 5
