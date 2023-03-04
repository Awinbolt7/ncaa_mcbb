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
	[GameDay], 
	[GameDateTime], 
	[AwayTeamID], 
	[HomeTeamID], 
	[AwayTeamScore], 
	[HomeTeamScore], 
	[GameUpdated], 
	[Period], 
	[IsClosed], 
	[GameEndDateTime], 
	[Channel]
FROM [ncaa_cbb].[GameSchedules]
WHERE ([AwayTeamScore] IS NOT NULL AND [HomeTeamScore] IS NOT NULL)
AND [GameStatus] IN ('F/OT', 'Final')

GO