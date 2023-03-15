USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 03.01.23>
-- Description: <Description, , A view that selects from ActivePlayers. >
-- Notes:
-- <1, , Created>
-- <2, , Added FullName, FullNameKey AW 03.11.23>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================

IF EXISTS (
		SELECT * 
		FROM sys.views v
		INNER JOIN sys.schemas s
			ON s.[schema_id] = v.[schema_id]
		WHERE s.[name] = 'ncaa_cbb'
		AND v.[name] = 'vw_ActivePlayers'
	)
	DROP VIEW [ncaa_cbb].[vw_ActivePlayers]
GO

CREATE VIEW [ncaa_cbb].[vw_ActivePlayers] AS
SELECT
	[PlayerID],
	[FirstName],
	[LastName],
	ISNULL([LastName],'No Last Name, ') + ', ' + ISNULL([FirstName],' No First Name') AS [FullName],
	ISNULL([LastName],'No Last Name, ') + ', ' + ISNULL([FirstName],' No First Name') + ' (' + CAST([PlayerID] AS NVARCHAR(15)) + ')' AS [FullNameKey],
	[TeamID],
	[Team],
	[Jersey],
	[Position],
	[Class],
	[Height],
	[BirthCity],
	[BirthState],
	[HighSchool],
	[GlobalTeamID]
FROM [ncaa_cbb].[ActivePlayers]

GO


