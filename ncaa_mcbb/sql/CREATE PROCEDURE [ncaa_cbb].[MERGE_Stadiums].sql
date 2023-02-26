SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.09.23>
-- Description: <Description, , A Stored Procedure that merges Stadiums. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================

CREATE PROCEDURE [ncaa_cbb].[MERGE_Stadiums]
AS
BEGIN

	IF OBJECT_ID('tempdb..#Stadiums') IS NOT NULL DROP TABLE #Stadiums

	/*** Stadiums ***/
	SELECT DISTINCT
		LH.[StadiumID], 
		LH.[StadiumActive],
		LH.[StadiumName],
		LH.[Address],
		LH.[City],
		LH.[State],
		LH.[Zip],
		LH.[Country],
		LH.[Capacity],
		LH.[GeoLat],
		LH.[GeoLong],
		GETDATE() AS [Created]
	INTO #Stadiums
	FROM [etl].[League_LeagueHierarchy] LH

	--merge
	MERGE [ncaa_cbb].[Stadiums] AS TARGET
	USING #Stadiums AS SOURCE
	ON (TARGET.[StadiumID] = SOURCE.[StadiumID])

	WHEN MATCHED
		THEN 
			UPDATE SET
			TARGET.[StadiumActive] = SOURCE.[StadiumActive],
			TARGET.[StadiumName] = SOURCE.[StadiumName],
			TARGET.[Address] = SOURCE.[Address],
			TARGET.[City] = SOURCE.[City],
			TARGET.[State] = SOURCE.[State],
			TARGET.[Zip] = SOURCE.[Zip],
			TARGET.[Country] = SOURCE.[Country],
			TARGET.[Capacity] = SOURCE.[Capacity],
			TARGET.[GeoLat] = SOURCE.[GeoLat],
			TARGET.[GeoLong] = SOURCE.[GeoLong],
			TARGET.[LastUpdated] = SOURCE.[Created]
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT
			(
				[StadiumID], 
				[StadiumActive],
				[StadiumName],
				[Address],
				[City],
				[State],
				[Zip],
				[Country],
				[Capacity],
				[GeoLat],
				[GeoLong],
				[Created]
			)
			VALUES
			(
				SOURCE.[StadiumID], 
				SOURCE.[StadiumActive],
				SOURCE.[StadiumName],
				SOURCE.[Address],
				SOURCE.[City],
				SOURCE.[State],
				SOURCE.[Zip],
				SOURCE.[Country],
				SOURCE.[Capacity],
				SOURCE.[GeoLat],
				SOURCE.[GeoLong],
				SOURCE.[Created]
			)
	--ran as batch
	WHEN NOT MATCHED BY SOURCE
		THEN DELETE;

	IF OBJECT_ID('tempdb..#Stadiums') IS NOT NULL DROP TABLE #Stadiums

END
GO


