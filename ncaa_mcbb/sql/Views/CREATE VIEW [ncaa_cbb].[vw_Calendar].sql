USE [sports];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 02.26.23>
-- Description: <Description, , A view that provisions a date range based on vw_GameStats. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
-- This needs to go back into a subquery in favor of a CTE AW
-- =============================================

IF EXISTS (
		SELECT * 
		FROM sys.views v
		INNER JOIN sys.schemas s
			ON s.[schema_id] = v.[schema_id]
		WHERE s.[name] = 'ncaa_cbb'
		AND v.[name] = 'vw_Calendar'
	)
	DROP VIEW [ncaa_cbb].[vw_Calendar]
GO

CREATE VIEW [ncaa_cbb].[vw_Calendar] AS
WITH [calendar] AS
(
			SELECT  
				TOP (DATEDIFF(DAY, 
		(
			SELECT
				MIN([day])
			FROM [ncaa_cbb].[vw_GameStats]
		), 
		(
			SELECT
				MAX([day])
			FROM [ncaa_cbb].[vw_GameStats]
		)
	) + 1
)		
	Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, 
	(
		SELECT
			MIN([day])
		FROM [ncaa_cbb].[vw_GameStats]
	)
)
	FROM sys.all_objects a
	CROSS JOIN sys.all_objects b
)
SELECT
	ROW_NUMBER() OVER(ORDER BY [date]) AS [row_num],
	[date],
	CAST(TRIM(REPLACE(CAST(CAST([date] AS DATE) AS NVARCHAR(20)),'-','')) AS [bigint]) AS [date_key],
	DATEADD(DAY,-6,DATEADD(DAY , 8-DATEPART(WEEKDAY,[date]),[date])) AS [week_start],
	DATEADD(DAY , 8-DATEPART(WEEKDAY,[date]),[date]) AS [week_end],
	CONVERT(NVARCHAR(2), [date], 101) AS [month_number],
	CAST(FORMAT([date], 'MMMM') AS NVARCHAR(15)) AS [month_name],
	CAST(LEFT(FORMAT([date], 'MMMM'),3) AS NVARCHAR(3)) AS [month_short_name],
	CAST(YEAR([date]) AS SMALLINT) AS [year],
	CAST(CAST(YEAR([date]) AS NVARCHAR) + ' ' + CAST(FORMAT([date], 'MMMM') AS NVARCHAR(15)) AS NVARCHAR(25)) AS [year_month],
	CAST(CAST(YEAR([date]) AS NVARCHAR) + '-' + CONVERT(NVARCHAR(2), [date], 101) AS NVARCHAR(10)) AS [year_month_number],
	DATEADD(YEAR,-1,[date]) AS [date_prior_year],
	DATEADD(MONTH,-1,[date]) AS [date_prior_month],
	CASE WHEN [date] > CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END AS [is_future],
	CASE WHEN [date] < DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) - 1, 1, 1 ) THEN 1 ELSE 0 END AS [no_prior_year]
FROM [calendar]
GO