USE [sports];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.26.23>
-- Description: <Description, , A view that provisions a date range based on StadiumTeams. >
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
		AND v.[name] = 'vw_StadiumTeams'
	)
	DROP VIEW [ncaa_cbb].[vw_StadiumTeams]
GO

CREATE VIEW [ncaa_cbb].[vw_StadiumTeams] AS 
SELECT
	[StadiumID],
	[TeamID],
	[GlobalTeamID]
FROM [ncaa_cbb].[StadiumTeams]