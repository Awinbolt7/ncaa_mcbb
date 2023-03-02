USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.26.23>
-- Description: <Description, , A view that provisions a date range based on Conferences. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--
-- =============================================


CREATE VIEW [ncaa_cbb].[vw_Conferences] AS
SELECT
	[ConferenceID],
	[ConferenceName]
FROM [ncaa_cbb].[Conferences]

GO


