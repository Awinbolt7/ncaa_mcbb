USE [sports];
GO

IF NOT EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = 'Conferences')
BEGIN
	CREATE TABLE [ncaa_cbb].[Conferences]
	(
		[ConferenceID] [smallint] NOT NULL,
		[ConferenceName] [nvarchar](50) NOT NULL,
		[Created] [datetime] NULL,
		[LastUpdated] [datetime] NULL
	)
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = 'Teams')
BEGIN
	CREATE TABLE [ncaa_cbb].[Teams]
	(
		[TeamID] [smallint] NOT NULL,
		[TeamKey] [nvarchar](10) NULL,
		[TeamActive] [bit] NOT NULL DEFAULT(0),
		[School] [varchar](255) NULL,
		[TeamName] [varchar](75) NULL,
		[ApRank] [smallint] NULL,
		[Wins] [smallint] NULL,
		[Losses] [smallint] NULL,
		[ConferenceWins] [smallint] NULL,
		[ConferenceLosses] [smallint] NULL,
		[GlobalTeamID] [bigint] NULL,
		[TeamLogoUrl] [nvarchar](255) NULL,
		[ShortDisplayName] [nvarchar](25),
		[Created] [datetime] NULL,
		[LastUpdated] [datetime] NULL
		)
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = 'Stadiums')
BEGIN
	CREATE TABLE [ncaa_cbb].[Stadiums]
	(
		[StadiumID] [int] NULL,
		[StadiumActive] [bit] NULL,
		[StadiumName] [nvarchar](255) NULL,
		[Address] [nvarchar](255) NULL,
		[City] [nvarchar](75) NULL,
		[State] [nvarchar](5) NULL,
		[Zip] [nvarchar](15) NULL,
		[Country] [nvarchar](5) NULL,
		[Capacity] [int] NULL,
		[GeoLat] [decimal](18,9) NULL,
		[GeoLong] [decimal](18,9) NULL,
		[Created] [datetime] NULL,
		[LastUpdated] [datetime] NULL
	)
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = 'ConferenceTeams')
BEGIN
	CREATE TABLE [ncaa_cbb].[Conferenceteams]
	(
		[ConferenceID] [smallint] NULL,
		[TeamID] [smallint] NULL,
		[GlobalTeamID] [bigint] NULL,
		[Created] [datetime] NULL,
		[LastUpdated] [datetime] NULL
	)
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = 'StadiumTeams')
BEGIN
	CREATE TABLE [ncaa_cbb].[StadiumTeams]
	(
		[StadiumID] [int] NULL,
		[TeamID] [smallint] NULL,
		[GlobalTeamID] [bigint] NULL,
		[Created] [datetime] NULL,
		[LastUpdated] [datetime] NULL
	)
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = 'GameStats')
BEGIN

	CREATE TABLE [ncaa_cbb].[GameStats]
	(
		[StatID] [bigint] NULL,
		[TeamID] [smallint] NULL,
		[PlayerID] [bigint] NULL,
		[SeasonType] [tinyint] NULL,
		[Season] [nvarchar](5) NULL,
		[PlayerName] [nvarchar](255) NULL,
		[Team] [nvarchar](25) NULL,
		[Position] [nvarchar](5) NULL,
		[InjuryStatus] [nvarchar](75) NULL,
		[InjuryBodyPart] [nvarchar](75) NULL,
		[InjuryStartDate] [datetime] NULL,
		[InjuryNotes] [nvarchar](4000) NULL,
		[OpponentRank] [smallint] NULL,
		[OpponentPositionRank] [smallint] NULL,
		[GlobalTeamID] [bigint] NULL,
		[GameID] [bigint] NULL,
		[OpponentID] [smallint] NULL,
		[Opponent] [nvarchar](25) NULL,
		[Day] [datetime] NULL,
		[DateTime] [datetime] NULL,
		[HomeOrAway] [nvarchar](10) NULL,
		[IsGameOver] [bit] NULL DEFAULT(1),
		[GlobalGameID] [bigint] NULL,
		[GlobalOpponentID] [bigint] NULL,
		[StatUpdated] [datetime] NULL,
		[Games] [tinyint] NULL,
		[Minutes] [smallint] NULL,
		[FieldGoalsMade] [smallint] NULL,
		[FieldGoalsAttempted] [smallint] NULL,
		[FieldGoalsPercentage] [decimal](18,9) NULL,
		[EffectiveFieldGoalsPercentage] [decimal](18,9) NULL,
		[TwoPointersMade] [smallint] NULL,
		[TwoPointersAttempted] [smallint] NULL,
		[ThreePointersMade] [smallint] NULL,
		[ThreePointersAttempted] [smallint] NULL,
		[FreeThrowsMade] [smallint] NULL,
		[FreeThrowsAttempted] [smallint] NULL,
		[OffensiveRebounds] [smallint] NULL,
		[DefensiveRebounds] [smallint] NULL,
		[Rebounds] [smallint] NULL,
		[OffensiveReboundsPercentage] [decimal](18,9) NULL,
		[DefensiveReboundsPercentage] [decimal](18,9) NULL,
		[TotalReboundsPercentage] [decimal](18,9) NULL,
		[Assists] [smallint] NULL,
		[Steals] [smallint] NULL,
		[BlockedShots] [smallint] NULL,
		[Turnovers] [smallint] NULL,
		[PersonalFouls] [smallint] NULL,
		[Points] [smallint] NULL,
		[TrueShootingAttempts] [decimal](18,9) NULL,
		[TrueShootingPercentage] [decimal](18,9) NULL,
		[PlayerEfficiencyRating] [decimal](18,9) NULL,
		[AssistsPercentage] [decimal](18,9) NULL,
		[StealsPercentage] [decimal](18,9) NULL,
		[BlocksPercentage] [decimal](18,9) NULL,
		[TurnOversPercentage] [decimal](18,9) NULL,
		[UsageRatePercentage] [decimal](18,9) NULL,
		[Created] [datetime] NULL,
		[LastUpdated] [datetime] NULL
	)

END
GO

IF NOT EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = 'GameSchedules')
BEGIN
	CREATE TABLE [ncaa_cbb].[GameSchedules]
	(
		[GameID] [bigint] NULL,
		[Season] [nvarchar](5) NULL,
		[SeasonType] [tinyint] NULL,
		[GameStatus] [nvarchar](25) NULL,
		[GameDay] [datetime] NULL,
		[GameDateTime] [datetime] NULL,
		[AwayTeam] [nvarchar](25) NULL,
		[HomeTeam] [nvarchar](25) NULL,
		[AwayTeamID] [smallint] NULL,
		[HomeTeamID] [smallint] NULL,
		[AwayTeamScore] [smallint] NULL,
		[HomeTeamScore] [smallint] NULL,
		[GameUpdated] [datetime] NULL,
		[Period] [nvarchar](5) NULL,
		[TimeRemainingMinutes] [smallint] NULL,
		[TimeRemainingSeconds] [smallint] NULL,
		[GlobalGameID] [bigint] NULL,
		[GlobalAwayTeamID] [bigint] NULL,
		[GlobalHomeTeamID] [bigint] NULL,
		[TournamentID] [bigint] NULL,
		[Bracket] [nvarchar](255) NULL,
		[Round] [nvarchar](255) NULL,
		[AwayTeamSeed] [tinyint] NULL,
		[HomeTeamSeed] [tinyint] NULL,
		[TournamentDisplayOrder] [nvarchar](255) NULL,
		[TournamentDisplayOrderForHomeTeam] [nvarchar](255) NULL,
		[IsClosed] [bit] NULL DEFAULT(1),
		[GameEndDateTime] [datetime] NULL,
		[HomeRotationNumber] [int] NULL,
		[AwayRotationNumber] [int] NULL,
		[Channel] [nvarchar](75) NULL,
		[NeutralVenue] [bit] NULL DEFAULT(0),
		[DateTimeUTC] [datetime] NULL,
		[Attendance] [int] NULL,
		[StadiumID] [int] NULL,
		[Created] [datetime] NULL,
		[LastUpdated] [datetime] NULL
		)
END
GO

IF NOT EXISTS (SELECT * FROM [sys].[tables] WHERE [name] = 'ActivePlayers')
BEGIN
	CREATE TABLE [ncaa_cbb].[ActivePlayers]
	(
		[PlayerID] [bigint] NULL,
		[FirstName] [varchar](50) NULL,
		[LastName] [varchar](75) NULL,
		[TeamID] [smallint] NULL,
		[Team] [nvarchar](10) NULL,
		[Jersey] [tinyint] NULL,
		[Position] [nvarchar](5) NULL,
		[Class] [nvarchar](50) NULL,
		[Height] [smallint] NULL,
		[Weight] [smallint] NULL,
		[BirthCity] [nvarchar](75) NULL,
		[BirthState] [nvarchar](75) NULL,
		[HighSchool] [nvarchar](255) NULL,
		[GlobalTeamID] [bigint] NULL,
		[InjuryStartDate] [datetime] NULL,
		[Created] [datetime] NULL,
		[LastUpdated] [datetime] NULL
	) 
END
GO