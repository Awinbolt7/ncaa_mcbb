USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.26.23>
-- Description: <Description, , A view that provisions a date range based on Teams. >
-- Notes:
-- <1, , Created>
-- <2, , Removed Stats, JOINED Conferences with assumption that Team/Conferences is 1 to 1 AW 03.05.23>
-- <3, , Removed TeamID in favor of GlobalTeamID AW 03.05.23>
-- =============================================

-- =============================================
-- Notes
-- =============================================
-- Stats in this dimension are incomplete
-- =============================================

IF EXISTS (
		SELECT * 
		FROM sys.views v
		INNER JOIN sys.schemas s
			ON s.[schema_id] = v.[schema_id]
		WHERE s.[name] = 'ncaa_cbb'
		AND v.[name] = 'vw_Teams'
	)
	DROP VIEW [ncaa_cbb].[vw_Teams]
GO

CREATE VIEW [ncaa_cbb].[vw_Teams] AS
SELECT
	--[TeamID], 
	--T.[TeamKey], 
	T.[TeamActive], 
	T.[School], 
	T.[TeamName], 
	T.[ApRank], 
	--[Wins], 
	--[Losses], 
	--[ConferenceWins], 
	--[ConferenceLosses], 
	T.[GlobalTeamID], 
	T.[TeamLogoUrl], 
	T.[ShortDisplayName],
	C.[ConferenceName]
FROM [ncaa_cbb].[Teams] T
INNER JOIN [ncaa_cbb].[Conferenceteams] CT
	ON CT.[GlobalTeamID] = T.[GlobalTeamID]
INNER JOIN [ncaa_cbb].[Conferences] C
	ON C.[ConferenceID] = CT.[ConferenceID]

GO


