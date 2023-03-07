USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 03.01.23>
-- Description: <Description, , A view that selects from GameSchedules. >
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
		AND v.[name] = 'vw_GameScheduleFacts'
	)
	DROP VIEW [ncaa_cbb].[vw_GameScheduleFacts]
GO

CREATE VIEW [ncaa_cbb].[vw_GameScheduleFacts] AS
SELECT 
	[GameID], 
	[GameStatus],
	CASE 
		WHEN [GameStatus] = 'F/OT' 
			THEN 1 
		ELSE 0
	END AS [OverTime],
	--[GameDay],
	[DateKey],
	[GameDateTime], 
	--[AwayTeamID], 
	--[HomeTeamID], 
	[AwayTeamScore], 
	[HomeTeamScore], 
	--[GameUpdated], 
	--[Period], 
	--[IsClosed], 
	[GlobalAwayTeamID],
	[GlobalHomeTeamID],
	[GameEndDateTime], 
	[Channel],
	CASE WHEN [Channel] IS NULL THEN 0 ELSE 1 END AS [Televised],
	ABS([HomeTeamScore] - [AwayTeamScore]) AS [PointDifferential],
	DATEDIFF(MINUTE,[GameDateTime], [GameEndDateTime]) AS [GameDurationMin]
FROM [ncaa_cbb].[GameSchedules]
WHERE ([AwayTeamScore] IS NOT NULL AND [HomeTeamScore] IS NOT NULL)
AND [GameStatus] IN ('F/OT', 'Final')

GO