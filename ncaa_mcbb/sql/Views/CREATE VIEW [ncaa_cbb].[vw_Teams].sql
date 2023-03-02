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
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================


CREATE VIEW [ncaa_cbb].[vw_Teams] AS
SELECT
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
	[ShortDisplayName]
FROM [ncaa_cbb].[Teams]

GO


