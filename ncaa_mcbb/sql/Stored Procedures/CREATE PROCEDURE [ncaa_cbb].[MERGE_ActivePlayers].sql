USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.25.23>
-- Description: <Description, , A Stored Procedure that merges Active Players. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================

CREATE PROCEDURE [ncaa_cbb].[MERGE_ActivePlayers]
AS
BEGIN

	IF OBJECT_ID('tempdb..#Players') IS NOT NULL DROP TABLE #Players

	/*** TEAMS ***/
	SELECT DISTINCT
		PA.[PlayerID] ,
		PA.[FirstName] ,
		PA.[LastName] ,
		PA.[TeamID] ,
		PA.[Team] ,
		PA.[Jersey] ,
		PA.[Position] ,
		PA.[Class] ,
		PA.[Height] ,
		PA.[Weight] ,
		PA.[BirthCity] ,
		PA.[BirthState] ,
		PA.[HighSchool] ,
		PA.[GlobalTeamID] ,
		PA.[InjuryStartDate] ,
		GETDATE() AS [Created]
	INTO #Players
	FROM [etl].[Players_Active] PA

	--merge
	MERGE [ncaa_cbb].[ActivePlayers] AS TARGET
	USING #Players AS SOURCE
	ON (TARGET.[PlayerID] = SOURCE.[PlayerID])

	WHEN MATCHED
		THEN 
			UPDATE SET
			TARGET.[PlayerID] = SOURCE.[PlayerID],
			TARGET.[FirstName] = SOURCE.[FirstName],
			TARGET.[LastName] = SOURCE.[LastName],
			TARGET.[TeamID] = SOURCE.[TeamID],
			TARGET.[Team] = SOURCE.[Team],
			TARGET.[Jersey] = SOURCE.[Jersey],
			TARGET.[Position] = SOURCE.[Position],
			TARGET.[Class] = SOURCE.[Class],
			TARGET.[Height] = SOURCE.[Height],
			TARGET.[Weight] = SOURCE.[Height],
			TARGET.[BirthCity] = SOURCE.[BirthCity],
			TARGET.[BirthState] = SOURCE.[BirthState],
			TARGET.[HighSchool] = SOURCE.[HighSchool],
			TARGET.[GlobalTeamID] = SOURCE.[GlobalTeamID],
			TARGET.[InjuryStartDate] = SOURCE.[InjuryStartDate],
			TARGET.[LastUpdated] = SOURCE.[Created]
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT
			(
				[PlayerID] ,
				[FirstName] ,
				[LastName] ,
				[TeamID] ,
				[Team] ,
				[Jersey] ,
				[Position] ,
				[Class] ,
				[Height] ,
				[Weight] ,
				[BirthCity] ,
				[BirthState] ,
				[HighSchool] ,
				[GlobalTeamID] ,
				[InjuryStartDate] ,
				[Created]
			)
			VALUES
			(
				SOURCE.[PlayerID] ,
				SOURCE.[FirstName] ,
				SOURCE.[LastName] ,
				SOURCE.[TeamID] ,
				SOURCE.[Team] ,
				SOURCE.[Jersey] ,
				SOURCE.[Position] ,
				SOURCE.[Class] ,
				SOURCE.[Height] ,
				SOURCE.[Weight] ,
				SOURCE.[BirthCity] ,
				SOURCE.[BirthState] ,
				SOURCE.[HighSchool] ,
				SOURCE.[GlobalTeamID] ,
				SOURCE.[InjuryStartDate] ,
				SOURCE.[Created]
			);
	--ran as batch
	--WHEN NOT MATCHED BY SOURCE
	--	THEN DELETE;

	IF OBJECT_ID('tempdb..#Players') IS NOT NULL DROP TABLE #Players

END
GO


