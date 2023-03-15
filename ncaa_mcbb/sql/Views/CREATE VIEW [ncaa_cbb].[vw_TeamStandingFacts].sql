USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 03.11.23>
-- Description: <Description, , A view that transposes Home/Away Teams from schedules. >
-- Notes:
-- <1, , Created>
-- <2, , Fixed IS NOT NULL on scores AW 03.02.23>
-- <3, , Added DateKey AW 03.03.23>
-- <4, , Removed Columns AW 03.05.23>
-- =============================================

-- =============================================
-- Notes
-- =============================================
-- Only Return Stat Rows Associated with a Game 
-- =============================================

IF EXISTS (
		SELECT * 
		FROM sys.views v
		INNER JOIN sys.schemas s
			ON s.[schema_id] = v.[schema_id]
		WHERE s.[name] = 'ncaa_cbb'
		AND v.[name] = 'vw_TeamStandingFacts'
	)
	DROP VIEW [ncaa_cbb].[vw_TeamStandingFacts]
GO


CREATE VIEW [ncaa_cbb].[vw_TeamStandingFacts] AS 
SELECT
	[GameID],
	[OverTime],
	[DateKey],
	[GameDateTime],
	[AwayTeamScore] AS [points_scored],
	[HomeTeamScore] AS [points_against],
	[GlobalAwayTeamID] AS [GlobalTeamID],
	[GlobalHomeTeamID] AS [GlobalOpponentID],
	CAST(1 AS TINYINT) AS [is_away],
	CAST(0 AS TINYINT) AS [is_home],
	CAST(CASE WHEN [AwayTeamScore] < [HomeTeamScore] THEN 1 ELSE 0 END AS TINYINT) AS [is_loss],
	CAST(CASE WHEN [HomeTeamScore] < [AwayTeamScore] THEN 1 ELSE 0 END AS TINYINT) AS [is_win],
	CAST(CASE WHEN [AwayTeamScore] < [HomeTeamScore] THEN 'L' ELSE 'W' END AS NVARCHAR(1)) AS [win_loss],
	[Televised],
	[GameDurationMin]
FROM [ncaa_cbb].[vw_GameScheduleFacts] 
UNION ALL
SELECT
	[GameID],
	[OverTime],
	[DateKey],
	[GameDateTime],
	[HomeTeamScore] AS [points_scored],
	[HomeTeamScore] AS [points_against],
	[GlobalHomeTeamID] AS [GlobalTeamID],
	[GlobalAwayTeamID] AS [GlobalOpponentID],
	CAST(0 AS TINYINT) AS [is_away],
	CAST(1 AS TINYINT) AS [is_home],
	CAST(CASE WHEN [HomeTeamScore] < [AwayTeamScore] THEN 1 ELSE 0 END AS TINYINT) AS [is_loss],
	CAST(CASE WHEN [AwayTeamScore] < [HomeTeamScore] THEN 1 ELSE 0 END AS TINYINT) AS [is_win],
	CAST(CASE WHEN [AwayTeamScore] < [HomeTeamScore] THEN 'L' ELSE 'W' END AS NVARCHAR(1)) AS [win_loss],
	[Televised],
	[GameDurationMin]
FROM [ncaa_cbb].[vw_GameScheduleFacts]
