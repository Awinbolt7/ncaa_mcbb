USE [sports];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.26.23>
-- Description: <Description, , A view that provisions columns from the [ncaa_cbb].[Stadiums] Table. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
-- 
-- =============================================

IF EXISTS (
		SELECT * 
		FROM sys.views v
		INNER JOIN sys.schemas s
			ON s.[schema_id] = v.[schema_id]
		WHERE s.[name] = 'ncaa_cbb'
		AND v.[name] = 'vw_Stadiums'
	)
	DROP VIEW [ncaa_cbb].[vw_Stadiums]
GO

CREATE VIEW [ncaa_cbb].[vw_Stadiums] AS
SELECT
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
	[GeoLong]
	--[Created],
	--[LastUpdated]
FROM [ncaa_cbb].[Stadiums]