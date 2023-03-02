USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 03.01.23>
-- Description: <Description, , A view that selects from ConferenceTeams. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
-- Only Return Stat Rows Associated with a Game 
-- =============================================

IF EXISTS (
		SELECT * 
		FROM sys.views v
		INNER JOIN sys.schemas s
			ON s.[schema_id] = v.[schema_id]
		WHERE s.[name] = 'ncaa_cbb'
		AND v.[name] = 'vw_ConferenceTeams'
	)
	DROP VIEW [ncaa_cbb].[vw_ConferenceTeams]
GO

CREATE VIEW [ncaa_cbb].[vw_ConferenceTeams] AS
SELECT
	[ConferenceID], 
	[TeamID] 
FROM [ncaa_cbb].[Conferenceteams]

GO





