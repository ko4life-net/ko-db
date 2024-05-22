USE [master]
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = N'###DB_NAME###_user')
  DROP LOGIN [###DB_NAME###_user];
CREATE LOGIN [###DB_NAME###_user] WITH PASSWORD=N'###DB_NAME###_user', DEFAULT_DATABASE=[###DB_NAME###], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON;
GO

USE [###DB_NAME###]
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'###DB_NAME###_user')
  DROP USER [###DB_NAME###_user];
CREATE USER [###DB_NAME###_user] FOR LOGIN [###DB_NAME###_user];
EXEC sp_addrolemember N'db_owner', N'###DB_NAME###_user';
GO
