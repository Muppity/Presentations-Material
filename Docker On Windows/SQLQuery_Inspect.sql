--show log sql creation and restore info
exec sp_readerrorlog 0

--show datafile locations
select Db_name(database_id),name,physical_name,upper(substring(physical_name,1,1)) drive,Sum(( ( size * 8 ) / 1024 )) / 1024 N'Size in GB'
from sys.master_files--sys.sysaltfiles
group by database_id,name,physical_name

--show sql uptime
SET NOCOUNT ON
DECLARE @crdate DATETIME, @hr VARCHAR(50), @min VARCHAR(5)
SELECT @crdate=create_date FROM sys.databases WHERE NAME='tempdb'
SELECT @hr=(DATEDIFF ( mi, @crdate,GETDATE()))/60
IF ((DATEDIFF ( mi, @crdate,GETDATE()))/60)=0
SELECT @min=(DATEDIFF ( mi, @crdate,GETDATE()))
ELSE
SELECT @min=(DATEDIFF ( mi, @crdate,GETDATE()))-((DATEDIFF( mi, @crdate,GETDATE()))/60)*60
PRINT 'SQL Server "' + CONVERT(VARCHAR(20),SERVERPROPERTY('SERVERNAME'))+'" is Online for the past '+@hr+' hours & '+@min+' minutes'
IF NOT EXISTS (SELECT 1 FROM master.dbo.sysprocesses WHERE program_name = N'SQLAgent - Generic Refresher')
BEGIN
PRINT 'SQL Server is running but SQL Server Agent <<NOT>> running'
END
ELSE BEGIN
PRINT 'SQL Server and SQL Server Agent both are running'
END

---audit information of engine
SELECT 
	@@version,
	SERVERPROPERTY('BuildClrVersion') AS BuildClrVersion,
	SERVERPROPERTY('Collation') AS Collation,
	SERVERPROPERTY('CollationID') as CollationID,
	SERVERPROPERTY('ComparisonStyle') as ComparisonStyle,
	SERVERPROPERTY('ComputerNamePhysicalNetBIOS') as ComputerNamePhysicalNetBIOS,
	SERVERPROPERTY('Edition') as Edition,
	SERVERPROPERTY('EditionID') as EditionID,
	SERVERPROPERTY('EngineEdition') as EngineEdition,
	SERVERPROPERTY('HadrManagerStatus') as HadrManagerStatus,
	SERVERPROPERTY('InstanceName') as InstanceName,
	SERVERPROPERTY('IsClustered') as IsClustered,
	SERVERPROPERTY('IsFullTextInstalled') as IsFullTextInstalled,
	SERVERPROPERTY('IsHadrEnabled') as IsHadrEnabled,
	SERVERPROPERTY('IsIntegratedSecurityOnly') as IsIntegratedSecurityOnly,
	SERVERPROPERTY('IsLocalDB') as IsLocalDB,
	SERVERPROPERTY('IsSingleUser') as IsSingleUser,
	SERVERPROPERTY('MachineName') as MachineName,
	SERVERPROPERTY('ProductVersion') as ProductVersion,
	SERVERPROPERTY('ProductLevel') as ProductLevel,
	SERVERPROPERTY('ServerName') as ServerName,
	SERVERPROPERTY('SqlCharSet') as SqlCharSet,
	SERVERPROPERTY('SqlCharSetName') as SqlCharSetName,
	SERVERPROPERTY('SqlSortOrder') as SqlSortOrder,
	SERVERPROPERTY('SqlSortOrderName') as SqlSortOrderName,
	SERVERPROPERTY('FilestreamShareName') as FilestreamShareName,
	SERVERPROPERTY('FilestreamConfiguredLevel') as FilestreamConfiguredLevel,
	SERVERPROPERTY('FilestreamEffectiveLevel') as FilestreamEffectiveLevel

SELECT TOP 100
s.database_name,
m.physical_device_name,
CAST(CAST(s.backup_size / 1000000 AS INT) AS VARCHAR(14)) + ' ' + 'MB' AS bkSize,
CAST(DATEDIFF(second, s.backup_start_date,
s.backup_finish_date) AS VARCHAR(10)) + ' ' + 'Seconds' TimeTaken,
s.backup_start_date,
CAST(s.first_lsn AS VARCHAR(50)) AS first_lsn,
CAST(s.last_lsn AS VARCHAR(50)) AS last_lsn,
CASE s.[type]
WHEN 'D' THEN 'Full'
WHEN 'I' THEN 'Differential'
WHEN 'L' THEN 'Transaction Log'
END AS BackupType,
s.server_name,
s.recovery_model
FROM msdb.dbo.backupset s
INNER JOIN msdb.dbo.backupmediafamily m ON s.media_set_id = m.media_set_id
ORDER BY backup_start_date DESC, backup_finish_date

