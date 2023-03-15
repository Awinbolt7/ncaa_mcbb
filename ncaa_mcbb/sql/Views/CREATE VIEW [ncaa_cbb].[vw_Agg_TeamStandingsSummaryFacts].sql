USE [sports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Author, , Awin>
-- Create Date: <Create Date, , 03.12.23>
-- Description: <Description, , A view that selects from ActivePlayers. >
-- Notes:
-- <1, , Created>
-- =============================================

-- =============================================
-- Notes
-- =============================================
--	Depends on [vw_TeamStandingFacts] - Should be materialized to a table
-- =============================================

IF EXISTS (
		SELECT * 
		FROM sys.views v
		INNER JOIN sys.schemas s
			ON s.[schema_id] = v.[schema_id]
		WHERE s.[name] = 'ncaa_cbb'
		AND v.[name] = 'vw_Agg_TeamStandingsSummaryFacts'
	)
	DROP VIEW [ncaa_cbb].[vw_Agg_TeamStandingsSummaryFacts]
GO

CREATE VIEW [ncaa_cbb].[vw_Agg_TeamStandingsSummaryFacts] AS
SELECT
	[GlobalTeamID],
	[is_div1_team],
	[total_games],
	[total_wins],
	[total_losses],
	[total_conference_games],
	[total_div1_games],
	[total_div1_wins],
	[total_div1_losses],
	[total_away_games],
	[total_away_wins],
	[total_away_losses],
	[total_home_games],
	[total_home_wins],
	[total_home_losses],
	CAST(CAST([total_wins] AS DECIMAL(18,9))/CAST(NULLIF([total_games],0) AS DECIMAL(18,9)) AS DECIMAL(18,9)) AS [win_percentage],
	CAST(CAST([total_div1_wins] AS DECIMAL(18,9))/CAST(NULLIF([total_div1_games],0) AS DECIMAL(18,9)) AS DECIMAL(18,9)) AS [div1_win_percentage],
	CAST(CAST([total_away_wins] AS DECIMAL(18,9))/CAST(NULLIF([total_away_games],0) AS DECIMAL(18,9)) AS DECIMAL(18,9)) AS [away_win_percentage],
	CAST(CAST([total_home_wins] AS DECIMAL(18,9))/CAST(NULLIF([total_home_games],0) AS DECIMAL(18,9)) AS DECIMAL(18,9))  AS [home_win_percentage]
FROM (
	SELECT 
		[GlobalTeamID] AS [GlobalTeamID],
		MAX([is_div1_team]) AS [is_div1_team],
		SUM([is_home]) + SUM([is_away]) AS [total_games],
		SUM([is_win]) AS [total_wins],
		SUM([is_loss]) AS [total_losses],
		SUM([in_conference_game]) AS [total_conference_games],
		SUM([div1_game]) AS [total_div1_games],
		SUM([div1_win]) AS [total_div1_wins],
		SUM([div1_loss]) AS [total_div1_losses],
		SUM([is_away]) AS [total_away_games],
		SUM([is_home]) AS [total_home_games],
		SUM([away_win]) AS [total_away_wins],
		SUM([home_win]) AS [total_home_wins],
		SUM([away_loss]) AS [total_away_losses],
		SUM([home_loss]) AS [total_home_losses]
	FROM 
	(
		SELECT 
			TS.[GlobalTeamID],
			--CT.[ConferenceID],
			--CTO.[ConferenceID],
			CASE WHEN CT.[ConferenceID] = -1 
				THEN 0
				ELSE 1
			END AS [is_div1_team],
			CASE WHEN CTO.ConferenceID = -1
				THEN 0
				ELSE 1
			END AS [opp_is_div1_team],
			CASE WHEN CT.[ConferenceID] = CTO.[ConferenceID]
				THEN 1
				ELSE 0
			END AS [in_conference_game],
			TS.[is_away],
			TS.[is_home],
			TS.[is_win],
			TS.[is_loss],
			CASE WHEN TS.[is_away] = 1 AND TS.[is_win] = 1
				THEN 1
				ELSE 0
			END AS [away_win],
			CASE WHEN TS.[is_home] = 1 AND TS.[is_win] = 1
				THEN 1
				ELSE 0 
			END AS [home_win],
			CASE WHEN TS.[is_away] = 1 AND TS.[is_loss] = 1
				THEN 1
				ELSE 0
			END AS [away_loss],
			CASE WHEN TS.[is_home] = 1 AND TS.[is_loss] = 1
				THEN 1
				ELSE 0 
			END AS [home_loss],
			CASE WHEN CTO.[ConferenceID] <> -1 AND CT.[ConferenceID] <> -1
				THEN 1
				ELSE 0
			END AS [div1_game],
			CASE WHEN CTO.[ConferenceID] <> -1 AND TS.[is_win] = 1
				THEN 1
				ELSE 0
			END AS [div1_win],
			CASE WHEN CTO.[ConferenceID] <> -1 AND TS.[is_loss] = 1
				THEN 1
				ELSE 0
			END AS [div1_loss]
		FROM [ncaa_cbb].[vw_TeamStandingFacts] TS
		--GlobalTeam
		LEFT JOIN [ncaa_cbb].[Conferenceteams] CT
			ON CT.[GlobalTeamID] = TS.[GlobalTeamID]
		--GlobalOpponent
		LEFT JOIN [ncaa_cbb].[Conferenceteams] CTO
			ON CTO.[GlobalTeamID] = TS.[GlobalOpponentID]
	) AS A
	GROUP BY [GlobalTeamID]
) AS B