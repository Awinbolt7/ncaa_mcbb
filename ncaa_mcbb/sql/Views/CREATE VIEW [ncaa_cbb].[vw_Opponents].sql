USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 03.01.23>
-- Description: <Description, , A view that selects from Teams. >
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
		AND v.[name] = 'vw_Opponents'
	)
	DROP VIEW [ncaa_cbb].[vw_Opponents]
GO

CREATE VIEW [ncaa_cbb].[vw_Opponents] AS
SELECT
	[TeamID], 
	[TeamKey], 
	[GlobalTeamID], 
	[TeamLogoUrl]
FROM [ncaa_cbb].[Teams]

GO


