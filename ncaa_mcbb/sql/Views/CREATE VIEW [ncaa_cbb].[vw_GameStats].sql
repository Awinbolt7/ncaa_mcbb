USE [sports];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.26.23>
-- Description: <Description, , A view that provisions a date range based on GameStats. >
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
		AND v.[name] = 'vw_GameStatFacts'
	)
	DROP VIEW [ncaa_cbb].[vw_GameStatFacts]
GO

CREATE VIEW [ncaa_cbb].[vw_GameStatFacts] AS 
SELECT
	GS.[StatID],
	GS.[TeamID],
	GS.[PlayerID],
	GS.[SeasonType],
	GS.[Season],
	--GS.[PlayerName],
	--GS.[Team],
	--GS.[Position],
	GS.[InjuryStatus],
	GS.[InjuryBodyPart],
	GS.[InjuryStartDate],
	GS.[InjuryNotes],
	GS.[OpponentRank],
	GS.[OpponentPositionRank],
	GS.[GlobalTeamID],
	GS.[GameID],
	GS.[OpponentID],
	GS.[Opponent],
	GS.[Day],
	GS.[DateTime],
	GS.[HomeOrAway],
	GS.[IsGameOver],
	GS.[GlobalGameID],
	GS.[GlobalOpponentID],
	--GS.[StatUpdated],
	GS.[Games],
	GS.[Minutes],
	GS.[FieldGoalsMade],
	GS.[FieldGoalsAttempted],
	GS.[FieldGoalsPercentage],
	GS.[EffectiveFieldGoalsPercentage],
	GS.[TwoPointersMade],
	GS.[TwoPointersAttempted],
	GS.[ThreePointersMade],
	GS.[ThreePointersAttempted],
	GS.[FreeThrowsMade],
	GS.[FreeThrowsAttempted],
	GS.[OffensiveRebounds],
	GS.[DefensiveRebounds],
	GS.[Rebounds],
	GS.[OffensiveReboundsPercentage],
	GS.[DefensiveReboundsPercentage],
	GS.[TotalReboundsPercentage],
	GS.[Assists],
	GS.[Steals],
	GS.[BlockedShots],
	GS.[Turnovers],
	GS.[PersonalFouls],
	GS.[Points],
	GS.[TrueShootingAttempts],
	GS.[TrueShootingPercentage],
	GS.[PlayerEfficiencyRating],
	GS.[AssistsPercentage],
	GS.[StealsPercentage],
	GS.[BlocksPercentage],
	GS.[TurnOversPercentage],
	GS.[UsageRatePercentage]
FROM [ncaa_cbb].[GameStats] GS
--crutch
INNER JOIN [ncaa_cbb].[GameSchedules] GC 
	ON GC.[GlobalGameID] = GS.[GlobalGameID]