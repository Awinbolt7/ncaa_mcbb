SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.09.23>
-- Description: <Description, , A Stored Procedure that merges ConferenceTeams. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================

CREATE PROCEDURE [ncaa_cbb].[MERGE_ConferenceTeams]
AS
BEGIN

	IF OBJECT_ID('tempdb..#ConferenceTeams') IS NOT NULL DROP TABLE #ConferenceTeams

	/*** ConferenceTeams ***/
	SELECT DISTINCT
		LH.[ConferenceID],
		LH.[TeamID],
		LH.[GlobalTeamID],
		GETDATE() AS [Created]
	INTO #ConferenceTeams
	FROM [etl].[League_LeagueHierarchy] LH

	--merge
	MERGE [ncaa_cbb].[ConferenceTeams] AS TARGET
	USING #ConferenceTeams AS SOURCE
	ON (
		TARGET.[ConferenceID] = SOURCE.[ConferenceID]
		AND TARGET.[GlobalTeamID] = SOURCE.[GlobalTeamID]
	)

	WHEN MATCHED
		THEN 
			UPDATE SET
				TARGET.[TeamID] = SOURCE.[TeamID],
				TARGET.[LastUpdated] = SOURCE.[Created]
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT
			(
				[ConferenceID],
				[TeamID],
				[GlobalTeamID],
				[Created]
			)
			VALUES
			(
				SOURCE.[ConferenceID],
				SOURCE.[TeamID],
				SOURCE.[GlobalTeamID],
				SOURCE.[Created]
			)
	--ran as batch
	WHEN NOT MATCHED BY SOURCE
		THEN DELETE;

	IF OBJECT_ID('tempdb..#ConferenceTeams') IS NOT NULL DROP TABLE #ConferenceTeams

END
GO


