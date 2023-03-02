SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.09.23>
-- Description: <Description, , A Stored Procedure that merges Conferences. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================

CREATE PROCEDURE [ncaa_cbb].[MERGE_Conferences]
AS
BEGIN

	IF OBJECT_ID('tempdb..#Conferences') IS NOT NULL DROP TABLE #Conferences

	/*** CONFERENCES ***/
	SELECT DISTINCT
		LH.[ConferenceID], 
		LH.[ConferenceName],
		GETDATE() AS [Created]
	INTO #Conferences
	FROM [etl].[League_LeagueHierarchy] LH

	--merge
	MERGE [ncaa_cbb].[Conferences] AS TARGET
	USING #Conferences AS SOURCE
	ON (TARGET.[ConferenceID] = SOURCE.[ConferenceID])

	WHEN MATCHED
		THEN 
			UPDATE SET
			TARGET.[ConferenceName] = SOURCE.[ConferenceName],
			TARGET.[LastUpdated] = SOURCE.[Created]
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT
			(
				[ConferenceID], 
				[ConferenceName],
				[Created]
			)
			VALUES
			(
				SOURCE.[ConferenceID], 
				SOURCE.[ConferenceName],
				SOURCE.[Created]
			)
	--ran as batch
	WHEN NOT MATCHED BY SOURCE
		THEN DELETE;

	IF OBJECT_ID('tempdb..#Conferences') IS NOT NULL DROP TABLE #Conferences

END
GO


