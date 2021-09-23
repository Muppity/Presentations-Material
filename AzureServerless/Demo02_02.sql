/*
Basic, Standard, 
Premium or Data Warehouse.
Standard:
S0, S1, S2, S3, S4, S6, S7, S9 or S12.
Premium
P1, P2, P4, P6, P11 or P15.

*/

CREATE DATABASE GX_09 ( EDITION = 'GeneralPurpose', SERVICE_OBJECTIVE = 'GP_S_Gen5_1' ) ;

DROP DATABASE GX_09;


SELECT  d.name,   
     slo.*    
FROM sys.databases d   
JOIN sys.database_service_objectives slo    
ON d.database_id = slo.database_id;


--Change the Service Objective
/* 
   Standard
   
   'S0' | 'S1' | 'S2' | 'S3' | 'S4'| 'S6'| 'S7'| 'S9'| 'S12' |
   Premium
                 | 'P1' | 'P2' | 'P4'| 'P6' | 'P11' | 'P15' |
                 | 'PRS1' | 'PRS2' | 'PRS4' | 'PRS6' |  
   ELASTIC POOL
*/
--Change the DATABASE Edition
/*
    Standard
    GeneralPurpose
*/
DECLARE @ed as nvarchar(20);
DECLARE @slo nvarchar(20);
SET @slo='GP_S_Gen5_1';
SET @ed='GeneralPurpose';
ALTER DATABASE [GX_04] MODIFY ( EDITION = 'GeneralPurpose',SERVICE_OBJECTIVE = 'S0');  
GO 


SELECT  @@version as version,d.name,
        s.database_id,
        s.edition,
        s.service_objective,
        (CASE WHEN s.elastic_pool_name  IS NULL
                THEN 'No Elastic Pool used'
                ELSE s.elastic_pool_name
                END) AS [Elastic Pool details]
FROM sys.databases d
JOIN sys.database_service_objectives s
ON d.database_id = s.database_id;

SELECT * FROM sys.dm_operation_status
ORDER BY start_time DESC

ALTER DATABASE [GX04]
MODIFY ( SERVICE_OBJECTIVE = ELASTIC_POOL ( name = SQLPOOL ) ) ;


/*  Note: The cache plan for the SQL Server instance
     it is cleaned by any of the mentioned options, which implies recompilation
     of the I / O implementation and utilization plans ---> $_$ 
    COLLATE, MODIFY FILEGROUP DEFAULT,MODIFY FILEGROUP READ_ONLY,READ_WRITE
    MODIFY_NAME,OFFLINE,ONLINE,PAGE_VERIFY,READ_ONLY,READ_WRITE
    --------------------------------------------------------------
                                                                o   ^__^
                                                                o   (oo)\_______
                                                                    (__)\       )\/\
                                                                        ||----w |
                                                                        ||     ||

    
*/
ALTER DATABASE  [GX04]
Modify Name =  GX03 ;