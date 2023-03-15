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
--	Depends on [vw_TeamStandingFacts],[vw_Agg_TeamStandingsSummaryFacts] - Should be materialized to a table
--	Depends on [vw_TeamStandingFacts] - Should be materialized to a table
--	Rating Percentage Index RPI = (0.25 x Team's winning percentage) + (0.50 x Opponents' average winning percentage) + (0.25 x Opponents' opponents' average winning percentage)
--  Strength of Schedule (Total Wins + Total Losses + RPI)
--	Strength of Schedule 
-- =============================================
IF EXISTS (
		SELECT * 
		FROM sys.views v
		INNER JOIN sys.schemas s
			ON s.[schema_id] = v.[schema_id]
		WHERE s.[name] = 'ncaa_cbb'
		AND v.[name] = 'vw_Agg_TeamStrengthSummaryFacts'
	)
	DROP VIEW [ncaa_cbb].[vw_Agg_TeamStrengthSummaryFacts]
GO

CREATE VIEW [ncaa_cbb].[vw_Agg_TeamStrengthSummaryFacts] AS

SELECT 
		B.[School],
		B.[GlobalTeamID],
		B.[total_games],
		B.[total_wins],
		B.[total_losses],
		B.[div1_win_percentage],
		B.[avg_opp_win_percentage],
		B.[avg_opp_opp_win_percentage],
		B.[rating_percentage_index],
		B.[strength],
		DENSE_RANK() OVER(ORDER BY B.[strength] DESC) AS [strength_rank]
FROM
(
	SELECT
		T.[School],
		A.[GlobalTeamID],
		A.[total_games],
		A.[total_wins],
		A.[total_losses],
		A.[div1_win_percentage],
		A.[avg_opp_win_percentage],
		A.[avg_opp_opp_win_percentage],
		(.25 * [div1_win_percentage]) + (.5 * avg_opp_win_percentage) + (.25 * [avg_opp_opp_win_percentage]) AS [rating_percentage_index],
		(([total_wins] + [total_losses]) + ((.25 * [div1_win_percentage]) + (.5 * avg_opp_win_percentage) + (.25 * [avg_opp_opp_win_percentage]) * 100) / [total_games]) AS [strength]

	FROM
	(
		SELECT
			--[GameID],
			--div1 games only
			TS.[GlobalTeamID],
			ATS.[total_games],
			ATS.[total_wins],
			ATS.[total_losses],
			ATS.[div1_win_percentage],
			AVG(OATS.[div1_win_percentage]) AS [avg_opp_win_percentage],
			AVG(OOATS.[div1_win_percentage]) AS [avg_opp_opp_win_percentage]
		FROM [ncaa_cbb].[vw_TeamStandingFacts] TS
		--GlobalTeam
		INNER JOIN [ncaa_cbb].[vw_Agg_TeamStandingsSummaryFacts] ATS
			ON ATS.[GlobalTeamID] = TS.[GlobalTeamID]
		--OppTeam
			INNER JOIN
			(
				SELECT
					TS.[GlobalTeamID],
					TS.[GlobalOpponentID],
					OATS.[div1_win_percentage]
				FROM [ncaa_cbb].[vw_TeamStandingFacts] TS
				--OppTeam
				INNER JOIN [ncaa_cbb].[vw_Agg_TeamStandingsSummaryFacts] OATS
					ON OATS.[GlobalTeamID] = TS.[GlobalOpponentID]
			) AS OATS
			ON OATS.[GlobalTeamID] = TS.[GlobalOpponentID]
		--OpponentsOppsTeam
			INNER JOIN
			(
				SELECT
					TS.[GlobalTeamID],
					TS.[GlobalOpponentID],
					OATS.[div1_win_percentage]
				FROM [ncaa_cbb].[vw_TeamStandingFacts] TS
				--OppTeam
				INNER JOIN [ncaa_cbb].[vw_Agg_TeamStandingsSummaryFacts] OATS
					ON OATS.[GlobalTeamID] = TS.[GlobalOpponentID]
			) AS OOATS
			ON OOATS.GlobalTeamID = OATS.[GlobalOpponentID]
		GROUP BY
			TS.[GlobalTeamID],
			ATS.[total_games],
			ATS.[total_wins],
			ATS.[total_losses],
			ATS.[div1_win_percentage]
	) AS A
	LEFT JOIN [ncaa_cbb].Teams T
	ON T.[GlobalTeamID] = A.[GlobalTeamID]
) AS B
GO