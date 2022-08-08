USE [master]
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = N'kodb_user')
  DROP LOGIN [kodb_user];
CREATE LOGIN [kodb_user] WITH PASSWORD=N'kodb_user', DEFAULT_DATABASE=[kodb], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON;
GO

USE [kodb]
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'kodb_user')
  DROP USER [kodb_user];
CREATE USER [kodb_user] FOR LOGIN [kodb_user];
EXEC sp_addrolemember N'db_owner', N'kodb_user';
GO
