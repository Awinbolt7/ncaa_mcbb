SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.09.23>
-- Description: <Description, , A Stored Procedure that merges StadiumTeams. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================

CREATE PROCEDURE [ncaa_cbb].[MERGE_StadiumTeams]
AS
BEGIN

	IF OBJECT_ID('tempdb..#StadiumTeams') IS NOT NULL DROP TABLE #StadiumTeams

	/*** StadiumTeams ***/
	SELECT DISTINCT
		LH.[StadiumID],
		LH.[TeamID],
		LH.[GlobalTeamID],
		GETDATE() AS [Created]
	INTO #StadiumTeams
	FROM [etl].[League_LeagueHierarchy] LH

	--merge
	MERGE [ncaa_cbb].[StadiumTeams] AS TARGET
	USING #StadiumTeams AS SOURCE
	ON (
		TARGET.[StadiumID] = SOURCE.[StadiumID]
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
				[StadiumID],
				[TeamID],
				[GlobalTeamID],
				[Created]
			)
			VALUES
			(
				SOURCE.[StadiumID],
				SOURCE.[TeamID],
				SOURCE.[GlobalTeamID],
				SOURCE.[Created]
			)
	--ran as batch
	WHEN NOT MATCHED BY SOURCE
		THEN DELETE;

	IF OBJECT_ID('tempdb..#StadiumTeams') IS NOT NULL DROP TABLE #StadiumTeams

END
GO


