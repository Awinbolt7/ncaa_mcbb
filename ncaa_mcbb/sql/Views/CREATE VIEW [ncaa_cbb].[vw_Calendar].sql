USE [sports]
GO

/****** Object:  View [ncaa_cbb].[vw_Calendar]    Script Date: 3/2/2023 6:25:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 03.03.23>
-- Description: <Description, , A view that provisions a date range based on vw_GameStateFacts. >
-- Notes:
-- <1, , Created> 
-- <2, , Changed from Snake to Pascal 03.03.23 AW>
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
			FROM [ncaa_cbb].[vw_GameStatFacts]
		), 
		(
			SELECT
				MAX([day])
			FROM [ncaa_cbb].[vw_GameStatFacts]
		)
	) + 1
)		
	Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, 
	(
		SELECT
			MIN([day])
		FROM [ncaa_cbb].[vw_GameStatFacts]
	)
)
	FROM sys.all_objects a
	CROSS JOIN sys.all_objects b
)
SELECT
	ROW_NUMBER() OVER(ORDER BY [date]) AS [RowNum],
	[Date],
	CAST(TRIM(REPLACE(CAST(CAST([date] AS DATE) AS NVARCHAR(20)),'-','')) AS [bigint]) AS [DateKey],
	DATEADD(DAY,-6,DATEADD(DAY , 8-DATEPART(WEEKDAY,[date]),[date])) AS [WeekStart],
	DATEADD(DAY , 8-DATEPART(WEEKDAY,[date]),[date]) AS [WeekEnd],
	CONVERT(NVARCHAR(2), [date], 101) AS [MonthNumber],
	CAST(FORMAT([date], 'MMMM') AS NVARCHAR(15)) AS [MonthName],
	CAST(LEFT(FORMAT([date], 'MMMM'),3) AS NVARCHAR(3)) AS [MonthShortName],
	CAST(YEAR([date]) AS SMALLINT) AS [Year],
	CAST(CAST(YEAR([date]) AS NVARCHAR) + ' ' + CAST(FORMAT([date], 'MMMM') AS NVARCHAR(15)) AS NVARCHAR(25)) AS [YearMonth],
	CAST(CAST(YEAR([date]) AS NVARCHAR) + '-' + CONVERT(NVARCHAR(2), [date], 101) AS NVARCHAR(10)) AS [YearMonthNumber],
	DATEADD(YEAR,-1,[date]) AS [DatePriorYear],
	DATEADD(MONTH,-1,[date]) AS [DatePriorMonth],
	CASE WHEN [date] > CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END AS [IsFuture],
	CASE WHEN [date] < DATEFROMPARTS ( DATEPART(yyyy, GETDATE()) - 1, 1, 1 ) THEN 1 ELSE 0 END AS [NoPriorYear]
FROM [calendar]
GO


