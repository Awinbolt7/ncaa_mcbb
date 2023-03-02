USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:   <Author,, Awin>
-- Create Date: <Create Date,, 02.13.23>
-- Description: <Description,, A Stored Procedure that merges GameStats. >
-- Notes:
-- <1,, Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================

CREATE PROCEDURE [ncaa_cbb].[MERGE_GameStats]
AS
BEGIN

	IF OBJECT_ID('tempdb..#GameStats') IS NOT NULL DROP TABLE #GameStats

	/*** #GameStats ***/
	SELECT DISTINCT
		GS.[StatID],
		GS.[TeamID],
		GS.[PlayerID],
		GS.[SeasonType],
		GS.[Season],
		GS.[PlayerName],
		GS.[Team],
		GS.[Position],
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
		GS.[StatUpdated],
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
		GS.[UsageRatePercentage],
		GETDATE() AS [Created]
	INTO #GameStats
	FROM [etl].[Game_GameStats] GS

	--merge
	MERGE [ncaa_cbb].[GameStats] AS TARGET
	USING #GameStats SOURCE
	ON (TARGET.[GlobalGameID] = SOURCE.[GlobalGameID]
	AND TARGET.[StatID] = SOURCE.[StatID])

	WHEN MATCHED
		THEN 
			UPDATE SET
				TARGET.[StatID] = SOURCE.[StatID],
				TARGET.[TeamID] = SOURCE.[TeamID],
				TARGET.[PlayerID] = SOURCE.[PlayerID],
				TARGET.[SeasonType] = SOURCE.[SeasonType],
				TARGET.[Season] = SOURCE.[Season],
				TARGET.[PlayerName] = SOURCE.[PlayerName],
				TARGET.[Team] = SOURCE.[Team],
				TARGET.[Position] = SOURCE.[Position],
				TARGET.[InjuryStatus] = SOURCE.[InjuryStatus],
				TARGET.[InjuryBodyPart] = SOURCE.[InjuryBodyPart],
				TARGET.[InjuryStartDate] = SOURCE.[InjuryStartDate],
				TARGET.[InjuryNotes] = SOURCE.[InjuryNotes],
				TARGET.[OpponentRank] = SOURCE.[OpponentRank],
				TARGET.[OpponentPositionRank] = SOURCE.[OpponentPositionRank],
				TARGET.[GlobalTeamID] = SOURCE.[GlobalTeamID],
				TARGET.[GameID] = SOURCE.[GameID],
				TARGET.[OpponentID] = SOURCE.[OpponentID],
				TARGET.[Opponent] = SOURCE.[Opponent],
				TARGET.[Day] = SOURCE.[Day],
				TARGET.[DateTime] = SOURCE.[DateTime],
				TARGET.[HomeOrAway] = SOURCE.[HomeOrAway],
				TARGET.[IsGameOver] = SOURCE.[IsGameOver],
				TARGET.[GlobalGameID] = SOURCE.[GlobalGameID],
				TARGET.[GlobalOpponentID] = SOURCE.[GlobalOpponentID],
				TARGET.[StatUpdated] = SOURCE.[StatUpdated],
				TARGET.[Games] = SOURCE.[Games],
				TARGET.[Minutes] = SOURCE.[Minutes],
				TARGET.[FieldGoalsMade] = SOURCE.[Minutes],
				TARGET.[FieldGoalsAttempted] = SOURCE.[FieldGoalsAttempted],
				TARGET.[FieldGoalsPercentage] = SOURCE.[FieldGoalsPercentage],
				TARGET.[EffectiveFieldGoalsPercentage] = SOURCE.[EffectiveFieldGoalsPercentage],
				TARGET.[TwoPointersMade] = SOURCE.[TwoPointersMade],
				TARGET.[TwoPointersAttempted] = SOURCE.[TwoPointersAttempted],
				TARGET.[ThreePointersMade] = SOURCE.[ThreePointersMade],
				TARGET.[ThreePointersAttempted] = SOURCE.[ThreePointersAttempted],
				TARGET.[FreeThrowsMade] = SOURCE.[FreeThrowsMade],
				TARGET.[FreeThrowsAttempted] = SOURCE.[FreeThrowsAttempted],
				TARGET.[OffensiveRebounds] = SOURCE.[OffensiveRebounds],
				TARGET.[DefensiveRebounds] = SOURCE.[DefensiveRebounds],
				TARGET.[Rebounds] = SOURCE.[Rebounds],
				TARGET.[OffensiveReboundsPercentage] = SOURCE.[OffensiveReboundsPercentage],
				TARGET.[DefensiveReboundsPercentage] = SOURCE.[DefensiveReboundsPercentage],
				TARGET.[TotalReboundsPercentage] = SOURCE.[TotalReboundsPercentage],
				TARGET.[Assists] = SOURCE.[Assists],
				TARGET.[Steals] = SOURCE.[Steals],
				TARGET.[BlockedShots] = SOURCE.[BlockedShots],
				TARGET.[Turnovers] = SOURCE.[Turnovers],
				TARGET.[PersonalFouls] = SOURCE.[PersonalFouls],
				TARGET.[Points] = SOURCE.[Points],
				TARGET.[TrueShootingAttempts] = SOURCE.[TrueShootingAttempts],
				TARGET.[TrueShootingPercentage] = SOURCE.[TrueShootingPercentage],
				TARGET.[PlayerEfficiencyRating] = SOURCE.[PlayerEfficiencyRating],
				TARGET.[AssistsPercentage] = SOURCE.[AssistsPercentage],
				TARGET.[StealsPercentage] = SOURCE.[StealsPercentage],
				TARGET.[BlocksPercentage] = SOURCE.[BlocksPercentage],
				TARGET.[TurnOversPercentage] = SOURCE.[TurnOversPercentage],
				TARGET.[UsageRatePercentage] = SOURCE.[UsageRatePercentage],
				TARGET.[LastUpdated] = SOURCE.[Created]
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT
			(
				[StatID],
				[TeamID],
				[PlayerID],
				[SeasonType],
				[Season],
				[PlayerName],
				[Team],
				[Position],
				[InjuryStatus],
				[InjuryBodyPart],
				[InjuryStartDate],
				[InjuryNotes],
				[OpponentRank],
				[OpponentPositionRank],
				[GlobalTeamID],
				[GameID],
				[OpponentID],
				[Opponent],
				[Day],
				[DateTime],
				[HomeOrAway],
				[IsGameOver],
				[GlobalGameID],
				[GlobalOpponentID],
				[StatUpdated],
				[Games],
				[Minutes],
				[FieldGoalsMade],
				[FieldGoalsAttempted],
				[FieldGoalsPercentage],
				[EffectiveFieldGoalsPercentage],
				[TwoPointersMade],
				[TwoPointersAttempted],
				[ThreePointersMade],
				[ThreePointersAttempted],
				[FreeThrowsMade],
				[FreeThrowsAttempted],
				[OffensiveRebounds],
				[DefensiveRebounds],
				[Rebounds],
				[OffensiveReboundsPercentage],
				[DefensiveReboundsPercentage],
				[TotalReboundsPercentage],
				[Assists],
				[Steals],
				[BlockedShots],
				[Turnovers],
				[PersonalFouls],
				[Points],
				[TrueShootingAttempts],
				[TrueShootingPercentage],
				[PlayerEfficiencyRating],
				[AssistsPercentage],
				[StealsPercentage],
				[BlocksPercentage],
				[TurnOversPercentage],
				[UsageRatePercentage],
				[Created]
			)
			VALUES
			(
				SOURCE.[StatID],
				SOURCE.[TeamID],
				SOURCE.[PlayerID],
				SOURCE.[SeasonType],
				SOURCE.[Season],
				SOURCE.[PlayerName],
				SOURCE.[Team],
				SOURCE.[Position],
				SOURCE.[InjuryStatus],
				SOURCE.[InjuryBodyPart],
				SOURCE.[InjuryStartDate],
				SOURCE.[InjuryNotes],
				SOURCE.[OpponentRank],
				SOURCE.[OpponentPositionRank],
				SOURCE.[GlobalTeamID],
				SOURCE.[GameID],
				SOURCE.[OpponentID],
				SOURCE.[Opponent],
				SOURCE.[Day],
				SOURCE.[DateTime],
				SOURCE.[HomeOrAway],
				SOURCE.[IsGameOver],
				SOURCE.[GlobalGameID],
				SOURCE.[GlobalOpponentID],
				SOURCE.[StatUpdated],
				SOURCE.[Games],
				SOURCE.[Minutes],
				SOURCE.[FieldGoalsMade],
				SOURCE.[FieldGoalsAttempted],
				SOURCE.[FieldGoalsPercentage],
				SOURCE.[EffectiveFieldGoalsPercentage],
				SOURCE.[TwoPointersMade],
				SOURCE.[TwoPointersAttempted],
				SOURCE.[ThreePointersMade],
				SOURCE.[ThreePointersAttempted],
				SOURCE.[FreeThrowsMade],
				SOURCE.[FreeThrowsAttempted],
				SOURCE.[OffensiveRebounds],
				SOURCE.[DefensiveRebounds],
				SOURCE.[Rebounds],
				SOURCE.[OffensiveReboundsPercentage],
				SOURCE.[DefensiveReboundsPercentage],
				SOURCE.[TotalReboundsPercentage],
				SOURCE.[Assists],
				SOURCE.[Steals],
				SOURCE.[BlockedShots],
				SOURCE.[Turnovers],
				SOURCE.[PersonalFouls],
				SOURCE.[Points],
				SOURCE.[TrueShootingAttempts],
				SOURCE.[TrueShootingPercentage],
				SOURCE.[PlayerEfficiencyRating],
				SOURCE.[AssistsPercentage],
				SOURCE.[StealsPercentage],
				SOURCE.[BlocksPercentage],
				SOURCE.[TurnOversPercentage],
				SOURCE.[UsageRatePercentage],
				SOURCE.[Created]
			);
	--ran as batch
	--WHEN NOT MATCHED BY SOURCE
	--	THEN DELETE;

	IF OBJECT_ID('tempdb..#GameStats') IS NOT NULL DROP TABLE #GameStats

END
GO

