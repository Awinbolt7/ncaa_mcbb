--run localdb (localdb)\Local
--create db
IF NOT EXISTS (SELECT * FROM [sys].[databases] WHERE [name] = 'sports')
BEGIN
	CREATE DATABASE [sports];
END
GO

--create user with sql authen for sqlalchemy
IF EXISTS (SELECT * FROM [sys].[databases] WHERE [name] = 'sports')
	BEGIN
		--create schemas
	IF (SCHEMA_ID('etl') IS NULL) 
	BEGIN
		USE [sports];
		EXEC ('CREATE SCHEMA [etl] AUTHORIZATION [dbo]')
	END

	IF (SCHEMA_ID('ncaa_cbb') IS NULL) 
	BEGIN
		USE [sports];
		EXEC ('CREATE SCHEMA [ncaa_cbb] AUTHORIZATION [dbo]')
	END

	USE [sports];
	IF NOT EXISTS (SELECT * FROM [sys].[sysusers] WHERE [name] = 'selkies')
	BEGIN
		CREATE LOGIN [selkies] WITH PASSWORD = 'TheEndlessObsession'
		CREATE USER [selkies] FOR LOGIN [selkies]
		ALTER ROLE [db_owner] ADD MEMBER [selkies]
	END
END
GO