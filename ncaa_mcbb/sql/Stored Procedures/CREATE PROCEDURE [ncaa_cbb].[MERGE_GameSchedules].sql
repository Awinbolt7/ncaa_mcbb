USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.13.23>
-- Description: <Description, , A Stored Procedure that merges GameStats. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================

CREATE PROCEDURE [ncaa_cbb].[MERGE_GameSchedules]
AS
BEGIN

	IF OBJECT_ID('tempdb..#GameSchedules') IS NOT NULL DROP TABLE #GameSchedules

	/*** #GameSchedules ***/
	SELECT DISTINCT
		GS.[GameID],
		GS.[Season],
		GS.[SeasonType],
		GS.[GameStatus],
		GS.[GameDay],
		CAST(TRIM(REPLACE(CAST(CAST([GameDay] AS DATE) AS NVARCHAR(20)),'-','')) AS [bigint]) AS [DateKey],
		GS.[GameDateTime],
		GS.[AwayTeam],
		GS.[HomeTeam],
		GS.[AwayTeamID],
		GS.[HomeTeamID],
		GS.[AwayTeamScore],
		GS.[HomeTeamScore],
		GS.[GameUpdated],
		GS.[Period],
		GS.[TimeRemainingMinutes],
		GS.[TimeRemainingSeconds],
		GS.[GlobalGameID],
		GS.[GlobalAwayTeamID],
		GS.[GlobalHomeTeamID],
		GS.[TournamentID],
		GS.[Bracket],
		GS.[Round],
		GS.[AwayTeamSeed],
		GS.[HomeTeamSeed],
		GS.[TournamentDisplayOrder],
		GS.[TournamentDisplayOrderForHomeTeam],
		GS.[IsClosed],
		GS.[GameEndDateTime],
		GS.[HomeRotationNumber],
		GS.[AwayRotationNumber],
		GS.[Channel],
		GS.[NeutralVenue],
		GS.[DateTimeUTC],
		GS.[Attendance],
		GS.[StadiumID],
		GETDATE() AS [Created]
	INTO #GameSchedules
	FROM [etl].[Game_Schedules] GS

	--merge
	MERGE [ncaa_cbb].[GameSchedules] AS TARGET
	USING #GameSchedules SOURCE
	ON (TARGET.[GlobalGameID] = SOURCE.[GlobalGameID])

	WHEN MATCHED
		THEN 
			UPDATE SET
				TARGET.[GameID] = SOURCE.[GameID],
				TARGET.[Season] = SOURCE.[Season],
				TARGET.[SeasonType] = SOURCE.[SeasonType],
				TARGET.[GameStatus] = SOURCE.[GameStatus],
				TARGET.[GameDay] = SOURCE.[GameDay],
				TARGET.[GameDateTime] = SOURCE.[GameDateTime],
				TARGET.[AwayTeam] = SOURCE.[AwayTeam],
				TARGET.[HomeTeam] = SOURCE.[HomeTeam],
				TARGET.[AwayTeamID] = SOURCE.[AwayTeamID],
				TARGET.[HomeTeamID] = SOURCE.[HomeTeamID],
				TARGET.[AwayTeamScore] = SOURCE.[AwayTeamScore],
				TARGET.[HomeTeamScore] = SOURCE.[HomeTeamScore],
				TARGET.[GameUpdated] = SOURCE.[GameUpdated],
				TARGET.[Period] = SOURCE.[Period],
				TARGET.[TimeRemainingMinutes] = SOURCE.[TimeRemainingMinutes],
				TARGET.[TimeRemainingSeconds] = SOURCE.[TimeRemainingSeconds],
				TARGET.[GlobalGameID] = SOURCE.[GlobalGameID],
				TARGET.[GlobalAwayTeamID] = SOURCE.[GlobalAwayTeamID],
				TARGET.[GlobalHomeTeamID] = SOURCE.[GlobalHomeTeamID],
				TARGET.[TournamentID] = SOURCE.[TournamentID],
				TARGET.[Bracket] = SOURCE.[Bracket],
				TARGET.[Round] = SOURCE.[Round],
				TARGET.[AwayTeamSeed] = SOURCE.[AwayTeamSeed],
				TARGET.[HomeTeamSeed] = SOURCE.[HomeTeamSeed],
				TARGET.[TournamentDisplayOrder] = SOURCE.[TournamentDisplayOrder],
				TARGET.[TournamentDisplayOrderForHomeTeam] = SOURCE.[TournamentDisplayOrderForHomeTeam],
				TARGET.[IsClosed] = SOURCE.[IsClosed],
				TARGET.[GameEndDateTime] = SOURCE.[GameEndDateTime],
				TARGET.[HomeRotationNumber] = SOURCE.[HomeRotationNumber],
				TARGET.[AwayRotationNumber] = SOURCE.[AwayRotationNumber],
				TARGET.[Channel] = SOURCE.[Channel],
				TARGET.[NeutralVenue] = SOURCE.[NeutralVenue],
				TARGET.[DateTimeUTC] = SOURCE.[DateTimeUTC],
				TARGET.[Attendance] = SOURCE.[Attendance],
				TARGET.[StadiumID] = SOURCE.[StadiumID],
				TARGET.[LastUpdated] = SOURCE.[Created]
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT
			(
				[GameID],
				[Season],
				[SeasonType],
				[GameStatus],
				[GameDay],
				[GameDateTime],
				[AwayTeam],
				[HomeTeam],
				[AwayTeamID],
				[HomeTeamID],
				[AwayTeamScore],
				[HomeTeamScore],
				[GameUpdated],
				[Period],
				[TimeRemainingMinutes],
				[TimeRemainingSeconds],
				[GlobalGameID],
				[GlobalAwayTeamID],
				[GlobalHomeTeamID],
				[TournamentID],
				[Bracket],
				[Round],
				[AwayTeamSeed],
				[HomeTeamSeed],
				[TournamentDisplayOrder],
				[TournamentDisplayOrderForHomeTeam],
				[IsClosed],
				[GameEndDateTime],
				[HomeRotationNumber],
				[AwayRotationNumber],
				[Channel],
				[NeutralVenue],
				[DateTimeUTC],
				[Attendance],
				[StadiumID],
				[Created]
			)
			VALUES
			(
				SOURCE.[GameID],
				SOURCE.[Season],
				SOURCE.[SeasonType],
				SOURCE.[GameStatus],
				SOURCE.[GameDay],
				SOURCE.[GameDateTime],
				SOURCE.[AwayTeam],
				SOURCE.[HomeTeam],
				SOURCE.[AwayTeamID],
				SOURCE.[HomeTeamID],
				SOURCE.[AwayTeamScore],
				SOURCE.[HomeTeamScore],
				SOURCE.[GameUpdated],
				SOURCE.[Period],
				SOURCE.[TimeRemainingMinutes],
				SOURCE.[TimeRemainingSeconds],
				SOURCE.[GlobalGameID],
				SOURCE.[GlobalAwayTeamID],
				SOURCE.[GlobalHomeTeamID],
				SOURCE.[TournamentID],
				SOURCE.[Bracket],
				SOURCE.[Round],
				SOURCE.[AwayTeamSeed],
				SOURCE.[HomeTeamSeed],
				SOURCE.[TournamentDisplayOrder],
				SOURCE.[TournamentDisplayOrderForHomeTeam],
				SOURCE.[IsClosed],
				SOURCE.[GameEndDateTime],
				SOURCE.[HomeRotationNumber],
				SOURCE.[AwayRotationNumber],
				SOURCE.[Channel],
				SOURCE.[NeutralVenue],
				SOURCE.[DateTimeUTC],
				SOURCE.[Attendance],
				SOURCE.[StadiumID],
				SOURCE.[Created]
			);

	IF OBJECT_ID('tempdb..#GameSchedules') IS NOT NULL DROP TABLE #GameSchedules

END
GO


