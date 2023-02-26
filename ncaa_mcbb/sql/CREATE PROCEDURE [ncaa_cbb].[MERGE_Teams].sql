SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.09.23>
-- Description: <Description, , A Stored Procedure that merges Teams. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================

CREATE PROCEDURE [ncaa_cbb].[MERGE_Teams]
AS
BEGIN

	IF OBJECT_ID('tempdb..#Teams') IS NOT NULL DROP TABLE #Teams

	/*** TEAMS ***/
	SELECT DISTINCT
		LH.[TeamID], 
		LH.[TeamKey],
		LH.[TeamActive],
		LH.[School],
		LH.[TeamName],
		LH.[ApRank],
		LH.[Wins],
		LH.[Losses],
		LH.[ConferenceWins],
		LH.[ConferenceLosses],
		LH.[GlobalTeamID],
		LH.[TeamLogoUrl],
		LH.[ShortDisplayName],
		GETDATE() AS [Created]
	INTO #Teams
	FROM [etl].[League_LeagueHierarchy] LH

	--merge
	MERGE [ncaa_cbb].[Teams] AS TARGET
	USING #Teams AS SOURCE
	ON (TARGET.[TeamID] = SOURCE.[TeamID])

	WHEN MATCHED
		THEN 
			UPDATE SET
			TARGET.[TeamID] = SOURCE.[TeamID], 
			TARGET.[TeamKey] = SOURCE.[TeamKey],
			TARGET.[TeamActive] = SOURCE.[TeamActive],
			TARGET.[School] = SOURCE.[School],
			TARGET.[TeamName] = SOURCE.[TeamName],
			TARGET.[ApRank] = SOURCE.[ApRank],
			TARGET.[Wins] = SOURCE.[Wins],
			TARGET.[Losses] = SOURCE.[Losses],
			TARGET.[ConferenceWins] = SOURCE.[ConferenceWins],
			TARGET.[ConferenceLosses] = SOURCE.[ConferenceLosses],
			TARGET.[GlobalTeamID] = SOURCE.[GlobalTeamID],
			TARGET.[TeamLogoUrl] = SOURCE.[TeamLogoUrl],
			TARGET.[ShortDisplayName] = SOURCE.[ShortDisplayName],
			TARGET.[LastUpdated] = SOURCE.[Created]
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT
			(
				[TeamID], 
				[TeamKey],
				[TeamActive],
				[School],
				[TeamName],
				[ApRank],
				[Wins],
				[Losses],
				[ConferenceWins],
				[ConferenceLosses],
				[GlobalTeamID],
				[TeamLogoUrl],
				[ShortDisplayName],
				[Created]
			)
			VALUES
			(
				SOURCE.[TeamID], 
				SOURCE.[TeamKey],
				SOURCE.[TeamActive],
				SOURCE.[School],
				SOURCE.[TeamName],
				SOURCE.[ApRank],
				SOURCE.[Wins],
				SOURCE.[Losses],
				SOURCE.[ConferenceWins],
				SOURCE.[ConferenceLosses],
				SOURCE.[GlobalTeamID],
				SOURCE.[TeamLogoUrl],
				SOURCE.[ShortDisplayName],
				SOURCE.[Created]
			)
	--ran as batch
	WHEN NOT MATCHED BY SOURCE
		THEN DELETE;

	IF OBJECT_ID('tempdb..#Teams') IS NOT NULL DROP TABLE #Teams

END
GO


