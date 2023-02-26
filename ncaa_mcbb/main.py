try:
    #init globals
    from config import config, cbb, globals
    import os,datetime,requests, pandas as pd
    #pd.set_option('display.max_columns', None)
    over_write, sql_import = False, True
    if sql_import:
        from config import pysql
        alcsql = pysql.alcsql()

    # init class, uses request class instead of spotipy
    colors, file_handler = globals.colors(), globals.file_handler()
except Exception as e:
    print(e)
    exit
    
#this needs to go into a class
def convert_date(year):
    date_list = []
    current_date = datetime.datetime.now().date()
    for month in range(1,13):
        if month > 4 and month < 11:
            continue
        else:
            for day in range(1, 32):
                try:
                    date = datetime.date(year, month, day)
                    if date <= current_date:
                        date = datetime.datetime(year, month, day)
                        date_list.append(date.strftime("%Y-%b-%d"))
                except ValueError:
                    pass
    return date_list

def validate_status_code(status_code):
    try:
        if status_code == 200:
            return True
        elif status_code == 403:
            print(colors.fail_color + str(status_code) + colors.logging_color + str( 'waiting ...'))
            return False
    except ValueError:
        print(colors.fail_color + str(ValueError))
        
class sdio(object):
    
    base_url = config.base_url
    def get_payload(self,base_url,sport,response_format,api_type,dict_endpoint,header):
        try:
            #https://api.sportsdata.io/v3/cbb/scores/json/LeagueHierarchy
            #https://api.sportsdata.io/v3/cbb/scores/json/League/LeagueHierarchy
            endpoint = base_url + sport + '/' + api_type  + '/' + response_format + '/' + dict_endpoint
            s = requests.get(endpoint, headers=header)
            
            return True, s
        except Exception as e:
            print(colors.fail_color + str(e))
            return False, None

class cbb(object):
    # This is the documentation for SportsDataIO's NCAA Basketball API. All of our API endpoints can be accessed via an HTTP GET request using your API key. The API key can be passed either as a query parameter or using the following HTTP request header.
    # Ocp-Apim-Subscription-Key: {key}

    #date format 2017-DEC-01
    #team format The abbreviation of the requested team. Examples: SF, NYY.
    #teamid format Unique ID of team. Example 1 integer
    #numberofgames How many games to return. Example all, 10, 25 string
    #gameid The GameID of an CBB game. GameIDs can be found in the Games API. Valid entries are 14620 or 16905
    #minutes Only returns player statistics that have changed in the last X minutes. You specify how many minutes in time to go back. Valid entries are: 1 or 2. string
    #playerid Unique FantasyData Player ID.Example:60008094. int    
    #Data goes back to 2018
    api_key = '70080f481d684aaa9d060454e9c9c435'
    
    request_header = {
        'Ocp-Apim-Subscription-Key': api_key
    }
    
    years_list = ['2023'] #['2019','2020','2021','2022']
    
    relative_sport = 'cbb'
    relative_response_format = 'json'
    relative_api_type = ['scores','stats']
    
    relative_url_dict ={
        'League' : [
                'LeagueHierarchy',
                #combined in LeagueHierarchy
                #'Stadiums',
                #'teams',
                'TeamSeasonStats/{season}'
                ],
        'Game' : [
            'AreAnyGamesInProgress',
            'GamesByDate/{date}',
            'Games/{season}',
            'TeamSchedule/{season}/{team}',
            'CurrentSeason',
            'TeamGameStatsBySeason/{season}/{teamid}/{numberofgames}',
            'TeamGameStatsByDate/{date}',
            'Tournament/{season}',
            'BoxScore/{gameid}',
            'BoxScores/{date}',
            'BoxScoresDelta/{date}/{minutes}',
            'PlayerGameStatsBySeason/{season}/{playerid}/{numberofgames}',
            'PlayerGameStatsByDate/{date}',
            'PlayerSeasonStats/{season}',
            'PlayerSeasonStatsByTeam/{season}/{team}'
                ],
        'Players' : [
            'InjuredPlayers',
            'Players',
            'Player/{playerid}',
            'Players/{team}',
            'teams'
                ]
        
    }
    
    def League_LeagueHierarchy(self,payload):
        try:
            #{"ConferenceID":1,
            #"Name":"American Athletic",
            #"Teams":[{
                # "TeamID":4,
                # "Key":"CIN",
                # "Active":true,
                # "School":"Cincinnati",
                # "Name":"Bearcats",
                # "ApRank":null,
                # "Wins":16,
                # "Losses":8,
                # "ConferenceWins":7,
                # "ConferenceLosses":4,
                # "GlobalTeamID":60000004,
                # "ConferenceID":1,
                # "Conference":"American Athletic",
                # "TeamLogoUrl":"https:\/\/s3-us-west-2.amazonaws.com\/static.fantasydata.com\/logos\/ncaa\/4.png",
                # "ShortDisplayName":"CIN",
                # "Stadium":{
                    # "StadiumID":86,
                    # "Active":true,
                    # "Name":"Fifth Third Arena",
                    # "Address":null,
                    # "City":"Cincinnati",
                    # "State":"OH",
                    # "Zip":null,
                    # "Country":null,
                    # "Capacity":12012,
                    # "GeoLat":39.131101,
                    # "GeoLong":-84.514207}},
            # cols = [#conference
            #         'ConferenceID','ConferenceName',
            #         #Team
            #         'TeamID','TeamKey','TeamActive','School',
            #         'TeamName','ApRank','Wins','Losses','ConferenceWins','ConferenceLosses',
            #         'GlobalTeamID','ConferenceID','Conference','TeamLogoUrl',
            #         'ShortDisplayName',
            #         #stadium
            #         'StadiumID','StadiumActive','StadiumName',
            #         'Address','City','State','Zip',
            #         'Country','Capacity','GeoLat','GeoLong']
            #master_df = pd.DataFrame(columns=cols)
            master_df = pd.DataFrame()
            if payload.ok:
                #payloads are lists
                payload = payload.json()
                for row in payload:
                    ConferenceID = [row['ConferenceID']]
                    ConferenceName = [row['Name']]
                    Teams = row['Teams']
                    for Team in Teams:
                        TeamID = Team['TeamID'],
                        TeamKey = Team['Key'],
                        TeamActive = Team['Active'],
                        School = Team['School'],
                        TeamName = Team['Name'],
                        ApRank = Team['ApRank'],
                        Wins = Team['Wins'],
                        Losses = Team['Losses'],
                        ConferenceWins = Team['ConferenceWins'],
                        ConferenceLosses = Team['ConferenceLosses'],
                        GlobalTeamID = Team['GlobalTeamID'],
                        TeamLogoUrl = Team['TeamLogoUrl'],
                        ShortDisplayName = Team['ShortDisplayName'],
                        st = Team['Stadium']
                        StadiumID = st['StadiumID'],
                        StadiumActive = st['Active'],
                        StadiumName = st['Name'],
                        Address = st['Address'],
                        City = st['City'],
                        State = st['State'],
                        Zip = st['Zip'],
                        Country = st['Country'],
                        Capacity = st['Capacity'],
                        GeoLat = st['GeoLat'],
                        GeoLong = st['GeoLong']
                    
                        append_df = pd.DataFrame({
                            'ConferenceID': ConferenceID,
                            'ConferenceName': ConferenceName,
                            'TeamID' : TeamID,
                            'TeamKey' : TeamKey,
                            'TeamActive' : TeamActive,
                            'School' : School,
                            'TeamName' : TeamName,
                            'ApRank' : ApRank,
                            'Wins' : Wins,
                            'Losses' : Losses,
                            'ConferenceWins' : ConferenceWins,
                            'ConferenceLosses' : ConferenceLosses,
                            'GlobalTeamID' : GlobalTeamID,
                            'TeamLogoUrl' : TeamLogoUrl,
                            'ShortDisplayName' : ShortDisplayName,
                            'StadiumID' : StadiumID,
                            'StadiumActive' : StadiumActive,
                            'StadiumName' : StadiumName,
                            'Address' : Address,
                            'City' : City,
                            'State' : State,
                            'Zip' : Zip,
                            'Country' : Country, 
                            'Capacity' : Capacity,
                            'GeoLat' : GeoLat,
                            'GeoLong' : GeoLong
                        })

                        append_df.reset_index(inplace=True, drop=True)
                        master_df = pd.concat([master_df,append_df],axis=0)
               
            return True, master_df 
        except Exception as e:
            print(colors.fail_color + str(e))
            return False, None
    
    def Game_Schedules(self,payload):
        try:
                        #{"GameID":11851,
            # "Season":2018,
            # "SeasonType":1,
            # "Status":"Final",
            # "Day":"2017-11-10T00:00:00",
            # "DateTime":"2017-11-10T12:00:00",
            # "AwayTeam":"SAVST",
            # "HomeTeam":"CIN",
            # "AwayTeamID":194,
            # "HomeTeamID":4,
            # "AwayTeamScore":41,
            # "HomeTeamScore":57,
            # "Updated":"2018-10-22T16:06:45",
            # "Period":"F",
            # "TimeRemainingMinutes":null,
            # "TimeRemainingSeconds":null,
            ## "PointSpread":null,
            ## "OverUnder":null,
            ## "AwayTeamMoneyLine":null,
            ## "HomeTeamMoneyLine":null,
            # "GlobalGameID":60011851,
            # "GlobalAwayTeamID":60000194,
            # "GlobalHomeTeamID":60000004,
            # "TournamentID":null,
            # "Bracket":null,
            # "Round":null,
            # "AwayTeamSeed":null,
            # "HomeTeamSeed":null,
            ## "AwayTeamPreviousGameID":null,
            ## "HomeTeamPreviousGameID":null,
            ## "AwayTeamPreviousGlobalGameID":null,
            ## "HomeTeamPreviousGlobalGameID":null,
            # "TournamentDisplayOrder":null,
            # "TournamentDisplayOrderForHomeTeam":"Scrambled",
            # "IsClosed":true,
            # "GameEndDateTime":"2017-11-10T14:30:00",
            # "HomeRotationNumber":null,
            # "AwayRotationNumber":null,
            # "TopTeamPreviousGameId":null,
            # "BottomTeamPreviousGameId":null,
            # "Channel":"ESP3",
            # "NeutralVenue":null,
            # "AwayPointSpreadPayout":null,
            # "HomePointSpreadPayout":null,
            # "OverPayout":null,
            # "UnderPayout":null,
            # "DateTimeUTC":"2017-11-10T17:00:00",
            # "Attendance":null,
            # "Stadium":null,
            # "Periods":[]}
            master_df = pd.DataFrame()
            if payload.ok:
                #payloads are lists
                payload = payload.json()
                for row in payload:
                    GameID = [row['GameID']]
                    Season = [row['Season']]
                    SeasonType = [row['SeasonType']]
                    GameStatus = [row['Status']]
                    GameDay = [row['Day']]
                    GameDateTime = [row['DateTime']]
                    AwayTeam = [row['AwayTeam']]
                    HomeTeam = [row['HomeTeam']]
                    AwayTeamID = [row['AwayTeamID']]
                    HomeTeamID = [row['HomeTeamID']]
                    AwayTeamScore = [row['AwayTeamScore']]
                    HomeTeamScore = [row['HomeTeamScore']]
                    GameUpdated = [row['Updated']]
                    Period = [row['Period']]
                    TimeRemainingMinutes = [row['TimeRemainingMinutes']]
                    TimeRemainingSeconds = [row['TimeRemainingSeconds']]
                    GlobalGameID = [row['GlobalGameID']]
                    GlobalAwayTeamID = [row['GlobalAwayTeamID']]
                    GlobalHomeTeamID = [row['GlobalHomeTeamID']]
                    TournamentID = [row['TournamentID']]
                    Bracket = [row['Bracket']]
                    Round = [row['Round']]
                    AwayTeamSeed = [row['AwayTeamSeed']]
                    HomeTeamSeed = [row['HomeTeamSeed']]
                    TournamentDisplayOrder = [row['TournamentDisplayOrder']]
                    TournamentDisplayOrderForHomeTeam = [row['TournamentDisplayOrderForHomeTeam']]
                    IsClosed = [row['IsClosed']]
                    GameEndDateTime = [row['GameEndDateTime']]
                    HomeRotationNumber = [row['HomeRotationNumber']]
                    AwayRotationNumber = [row['AwayRotationNumber']]
                    Channel = [row['Channel']]
                    NeutralVenue = [row['NeutralVenue']]
                    DateTimeUTC = [row['DateTimeUTC']]
                    Attendance = [row['Attendance']]
                    GameEndDateTime = [row['GameEndDateTime']]
                    #Stadium = [row['Stadium']]
                    if row['Stadium'] is not None:
                        st = row['Stadium']
                        StadiumID = st['StadiumID'],
                        StadiumActive = st['Active'],
                        StadiumName = st['Name'],
                        Address = st['Address'],
                        City = st['City'],
                        State = st['State'],
                        Zip = st['Zip'],
                        Country = st['Country'],
                        Capacity = st['Capacity'],
                        GeoLat = st['GeoLat'],
                        GeoLong = st['GeoLong']
                    
                        append_df = pd.DataFrame({
                            'GameID' : GameID,
                            'Season' : Season,
                            'SeasonType' : SeasonType,
                            'GameStatus' : GameStatus,
                            'GameDay' : GameDay,
                            'GameDateTime' : GameDateTime,
                            'AwayTeam' : AwayTeam,
                            'HomeTeam' : HomeTeam,
                            'AwayTeamID' : AwayTeamID,
                            'HomeTeamID' : HomeTeamID,
                            'AwayTeamScore' : AwayTeamScore,
                            'HomeTeamScore' : HomeTeamScore,
                            'GameUpdated' : GameUpdated,
                            'Period' : Period,
                            'TimeRemainingMinutes' : TimeRemainingMinutes,
                            'TimeRemainingSeconds' : TimeRemainingSeconds,
                            'GlobalGameID' : GlobalGameID,
                            'GlobalAwayTeamID' : GlobalAwayTeamID,
                            'GlobalHomeTeamID' : GlobalHomeTeamID,
                            'TournamentID' : TournamentID,
                            'Bracket' : Bracket,
                            'Round' : Round,
                            'AwayTeamSeed' : AwayTeamSeed,
                            'HomeTeamSeed' : HomeTeamSeed,
                            'TournamentDisplayOrder' : TournamentDisplayOrder,
                            'TournamentDisplayOrderForHomeTeam' : TournamentDisplayOrderForHomeTeam,
                            'IsClosed' : IsClosed,
                            'GameEndDateTime' : GameEndDateTime,
                            'HomeRotationNumber' : HomeRotationNumber,
                            'AwayRotationNumber' : AwayRotationNumber,
                            'Channel' : Channel,
                            'NeutralVenue' : NeutralVenue,
                            'DateTimeUTC' : DateTimeUTC,
                            'Attendance' : Attendance,
                            'StadiumID' : StadiumID,
                            'StadiumActive' : StadiumActive,
                            'StadiumName' : StadiumName,
                            'Address' : Address,
                            'City' : City,
                            'State' : State,
                            'Zip' : Zip,
                            'Country' : Country, 
                            'Capacity' : Capacity,
                            'GeoLat' : GeoLat,
                            'GeoLong' : GeoLong,
                            'GameEndDateTime' : GameEndDateTime
                        })
                    else:
                        append_df = pd.DataFrame({
                            'GameID' : GameID,
                            'Season' : Season,
                            'SeasonType' : SeasonType,
                            'GameStatus' : GameStatus,
                            'GameDay' : GameDay,
                            'GameDateTime' : GameDateTime,
                            'AwayTeam' : AwayTeam,
                            'HomeTeam' : HomeTeam,
                            'AwayTeamID' : AwayTeamID,
                            'HomeTeamID' : HomeTeamID,
                            'AwayTeamScore' : AwayTeamScore,
                            'HomeTeamScore' : HomeTeamScore,
                            'GameUpdated' : GameUpdated,
                            'Period' : Period,
                            'TimeRemainingMinutes' : TimeRemainingMinutes,
                            'TimeRemainingSeconds' : TimeRemainingSeconds,
                            'GlobalGameID' : GlobalGameID,
                            'GlobalAwayTeamID' : GlobalAwayTeamID,
                            'GlobalHomeTeamID' : GlobalHomeTeamID,
                            'TournamentID' : TournamentID,
                            'Bracket' : Bracket,
                            'Round' : Round,
                            'AwayTeamSeed' : AwayTeamSeed,
                            'HomeTeamSeed' : HomeTeamSeed,
                            'TournamentDisplayOrder' : TournamentDisplayOrder,
                            'TournamentDisplayOrderForHomeTeam' : TournamentDisplayOrderForHomeTeam,
                            'IsClosed' : IsClosed,
                            'GameEndDateTime' : GameEndDateTime,
                            'HomeRotationNumber' : HomeRotationNumber,
                            'AwayRotationNumber' : AwayRotationNumber,
                            'Channel' : Channel,
                            'NeutralVenue' : NeutralVenue,
                            'DateTimeUTC' : DateTimeUTC,
                            'Attendance' : Attendance,
                            'GameEndDateTime' : GameEndDateTime
                        })
                        

                    append_df.reset_index(inplace=True, drop=True)
                    master_df = pd.concat([master_df,append_df],axis=0)
                    
                    #print(master_df)
            
            
            #print(master_df.dtypes)
                           
            return True, master_df 
        except Exception as e:
            print(colors.fail_color + str(e))
            return False, None
        
    def Game_PlayerGameStatsByDate(self,payload):
        try:
            #{"StatID":374031,
            #"TeamID":177,
            #"PlayerID":60001145,
            # "SeasonType":1,
            # "Season":2018,
            # "Name":"Jimond Ivey",
            # "Team":"AKRON",
            # "Position":"G",
            # # "FanDuelSalary":null,
            # # "DraftKingsSalary":null,
            # # "FantasyDataSalary":null,
            # #"YahooSalary":null,
            # "InjuryStatus":null,
            # "InjuryBodyPart":null,
            # "InjuryStartDate":null,
            # "InjuryNotes":null,
            # # "FanDuelPosition":null,
            # # "DraftKingsPosition":null,
            # # "YahooPosition":null,
            # "OpponentRank":null,
            # "OpponentPositionRank":null,
            # "GlobalTeamID":60000177,
            # "GameID":16187,
            # "OpponentID":179,
            # "Opponent":"BUF",
            # "Day":"2018-02-27T00:00:00",
            # "DateTime":"2018-02-27T19:00:00",
            # "HomeOrAway":"AWAY",
            # "IsGameOver":true,
            # "GlobalGameID":60016187,
            # "GlobalOpponentID":60000179,
            # "Updated":"2021-02-02T16:04:28",
            # "Games":1,
            # "FantasyPoints":32.9,
            # "Minutes":39,
            # "FieldGoalsMade":6,
            # "FieldGoalsAttempted":13,
            # "FieldGoalsPercentage":43.7,
            # "EffectiveFieldGoalsPercentage":52.4,
            # "TwoPointersMade":2,
            # "TwoPointersAttempted":7,
            # "TwoPointersPercentage":34.9,
            # "ThreePointersMade":3,
            # "ThreePointersAttempted":7,
            # "ThreePointersPercentage":52.4,
            # "FreeThrowsMade":2,
            # "FreeThrowsAttempted":2,
            # "FreeThrowsPercentage":104.9,
            # "OffensiveRebounds":3,
            # "DefensiveRebounds":4,
            # "Rebounds":8,
            # "OffensiveReboundsPercentage":12.1,
            # "DefensiveReboundsPercentage":18.1,
            # "TotalReboundsPercentage":15.0,
            # "Assists":7,
            # "Steals":0,
            # "BlockedShots":0,
            # "Turnovers":1,
            # "PersonalFouls":3,
            # "Points":16,
            # "TrueShootingAttempts":13.5,
            # "TrueShootingPercentage":60.5,
            # "PlayerEfficiencyRating":19.4,
            # "AssistsPercentage":33.0,
            # "StealsPercentage":0.0,
            # "BlocksPercentage":0.0,
            # "TurnOversPercentage":7.9,
            # "UsageRatePercentage":19.6,
            # # "FantasyPointsFanDuel":32.9,
            # # "FantasyPointsDraftKings":35.4,"
            # # FantasyPointsYahoo":null}
            master_df = pd.DataFrame()
            if payload.ok:
                #payloads are lists
                payload = payload.json()
                for row in payload:
                    StatID = [row['StatID']]
                    TeamID = [row['TeamID']]
                    PlayerID = [row['PlayerID']]
                    SeasonType = [row['SeasonType']]
                    Season = [row['Season']]
                    PlayerName = [row['Name']]
                    Team = [row['Team']]
                    Position = [row['Position']]
                    InjuryStatus = [row['InjuryStatus']]
                    InjuryBodyPart = [row['InjuryBodyPart']]
                    InjuryStartDate = [row['InjuryStartDate']]
                    InjuryNotes = [row['InjuryNotes']]
                    OpponentRank = [row['OpponentRank']]
                    OpponentPositionRank = [row['OpponentPositionRank']]
                    GlobalTeamID = [row['GlobalTeamID']]
                    GameID = [row['GameID']]
                    OpponentID = [row['OpponentID']]
                    Opponent = [row['Opponent']]
                    Day = [row['Day']]
                    DateTime = [row['DateTime']]
                    HomeOrAway = [row['HomeOrAway']]
                    IsGameOver = [row['IsGameOver']]
                    GlobalGameID = [row['GlobalGameID']]
                    GlobalOpponentID = [row['GlobalOpponentID']]
                    StatUpdated = [row['Updated']]
                    Games = [row['Games']]
                    Minutes = [row['Minutes']]
                    FieldGoalsMade = [row['FieldGoalsMade']]
                    FieldGoalsAttempted = [row['FieldGoalsAttempted']]
                    FieldGoalsPercentage = [row['FieldGoalsPercentage']]
                    EffectiveFieldGoalsPercentage = [row['EffectiveFieldGoalsPercentage']]
                    TwoPointersMade = [row['TwoPointersMade']]
                    TwoPointersAttempted = [row['TwoPointersAttempted']]
                    ThreePointersMade = [row['ThreePointersMade']]
                    ThreePointersAttempted = [row['ThreePointersAttempted']]
                    FreeThrowsMade = [row['FreeThrowsMade']]
                    FreeThrowsAttempted = [row['FreeThrowsAttempted']]
                    OffensiveRebounds = [row['OffensiveRebounds']]
                    DefensiveRebounds = [row['DefensiveRebounds']]
                    Rebounds = [row['Rebounds']]
                    OffensiveReboundsPercentage = [row['OffensiveReboundsPercentage']]
                    DefensiveReboundsPercentage = [row['DefensiveReboundsPercentage']]
                    TotalReboundsPercentage = [row['TotalReboundsPercentage']]
                    Assists = [row['Assists']]
                    Steals = [row['Steals']]
                    BlockedShots = [row['BlockedShots']]
                    Turnovers = [row['Turnovers']]
                    PersonalFouls = [row['PersonalFouls']]
                    Points = [row['Points']]
                    TrueShootingAttempts = [row['TrueShootingAttempts']]
                    TrueShootingPercentage = [row['TrueShootingPercentage']]
                    PlayerEfficiencyRating = [row['PlayerEfficiencyRating']]
                    AssistsPercentage = [row['AssistsPercentage']]
                    StealsPercentage = [row['StealsPercentage']]
                    BlocksPercentage = [row['BlocksPercentage']]
                    TurnOversPercentage = [row['TurnOversPercentage']]
                    UsageRatePercentage = [row['UsageRatePercentage']]
                    
                    append_df = pd.DataFrame({
                        'StatID' : StatID,
                        'TeamID' : TeamID,
                        'PlayerID' : PlayerID,
                        'SeasonType' : SeasonType,
                        'Season' : Season,
                        'PlayerName' : PlayerName,
                        'Team' : Team,
                        'Position' : Position,
                        'InjuryStatus' : InjuryStatus,
                        'InjuryBodyPart' : InjuryBodyPart,
                        'InjuryStartDate' : InjuryStartDate,
                        'InjuryNotes' : InjuryNotes,
                        'OpponentRank' : OpponentRank,
                        'OpponentPositionRank' : OpponentPositionRank,
                        'GlobalTeamID' : GlobalTeamID,
                        'GameID' : GameID,
                        'OpponentID' : OpponentID,
                        'Opponent' : Opponent,
                        'Day' : Day,
                        'DateTime' : DateTime,
                        'HomeOrAway' : HomeOrAway,
                        'IsGameOver' : IsGameOver,
                        'GlobalGameID' : GlobalGameID,
                        'GlobalOpponentID' : GlobalOpponentID,
                        'StatUpdated' : StatUpdated,
                        'Games' : Games,
                        'Minutes' : Minutes,
                        'FieldGoalsMade' : FieldGoalsMade,
                        'FieldGoalsAttempted' : FieldGoalsAttempted,
                        'FieldGoalsPercentage' : FieldGoalsPercentage,
                        'EffectiveFieldGoalsPercentage' : EffectiveFieldGoalsPercentage,
                        'TwoPointersMade' : TwoPointersMade,
                        'TwoPointersAttempted' : TwoPointersAttempted,
                        'ThreePointersMade' : ThreePointersMade,
                        'ThreePointersAttempted' : ThreePointersAttempted,
                        'FreeThrowsMade' : FreeThrowsMade,
                        'FreeThrowsAttempted' : FreeThrowsAttempted,
                        'OffensiveRebounds' : OffensiveRebounds,
                        'DefensiveRebounds' : DefensiveRebounds,
                        'Rebounds' : Rebounds,
                        'OffensiveReboundsPercentage' : OffensiveReboundsPercentage,
                        'DefensiveReboundsPercentage' : DefensiveReboundsPercentage,
                        'TotalReboundsPercentage' : TotalReboundsPercentage,
                        'Assists' : Assists,
                        'Steals' : Steals,
                        'BlockedShots' : BlockedShots,
                        'Turnovers' : Turnovers,
                        'PersonalFouls' : PersonalFouls,
                        'Points' : Points,
                        'TrueShootingAttempts' : TrueShootingAttempts,
                        'TrueShootingPercentage' : TrueShootingPercentage,
                        'PlayerEfficiencyRating' : PlayerEfficiencyRating,
                        'AssistsPercentage' : AssistsPercentage,
                        'StealsPercentage' : StealsPercentage,
                        'BlocksPercentage' : BlocksPercentage,
                        'TurnOversPercentage' : TurnOversPercentage,
                        'UsageRatePercentage' : UsageRatePercentage,
                    })

                    append_df.reset_index(inplace=True, drop=True)
                    master_df = pd.concat([master_df,append_df],axis=0)
               
            return True, master_df 
        except Exception as e:
            print(colors.fail_color + str(e))
            return False, None

    def Players_Active(self,payload):
        try:
            #{"PlayerID":60000075,
            # "FirstName":"Jalen",
            # "LastName":"Reynolds",
            # "TeamID":305,
            # "Team":"SOUTH",
            # "Jersey":12,
            # "Position":"F",
            # "Class":"Junior",
            # "Height":78,
            # "Weight":245,
            # "BirthCity":"Detroit",
            # "BirthState":"MI",
            # "HighSchool":"Brewster Academy",
            # "SportRadarPlayerID":"",
            # "RotoworldPlayerID":null,
            # "RotoWirePlayerID":null,
            # "FantasyAlarmPlayerID":null,
            # "GlobalTeamID":60000305,
            # "InjuryStatus":"Scrambled",
            # "InjuryBodyPart":"Scrambled",
            # "InjuryNotes":"Scrambled",
            # "InjuryStartDate":null}
            
            master_df = pd.DataFrame()
            if payload.ok:
                #payloads are lists
                payload = payload.json()
                for row in payload:
                    PlayerID = [row['PlayerID']]
                    FirstName = [row['FirstName']]
                    LastName = [row['LastName']]
                    TeamID = [row['TeamID']]
                    Team = [row['Team']]
                    Jersey = [row['Jersey']]
                    Position = [row['Position']]
                    Class = [row['Class']]
                    Height = [row['Height']]
                    Weight = [row['Weight']]
                    BirthCity = [row['BirthCity']]
                    BirthState = [row['BirthState']]
                    HighSchool = [row['HighSchool']]
                    GlobalTeamID = [row['GlobalTeamID']]
                    InjuryStatus = [row['InjuryStatus']]
                    InjuryBodyPart = [row['InjuryBodyPart']]
                    InjuryNotes = [row['InjuryNotes']]
                    InjuryStartDate = [row['InjuryStartDate']]
                    
                    append_df = pd.DataFrame({
                        'PlayerID' : PlayerID,
                        'FirstName' : FirstName,
                        'LastName' : LastName,
                        'TeamID' : TeamID,
                        'Team' : Team,
                        'Jersey' : Jersey,
                        'Position' : Position,
                        'Class' : Class,
                        'Height' : Height,
                        'Weight' : Weight,
                        'BirthCity' : BirthCity,
                        'BirthState' : BirthState,
                        'HighSchool' : HighSchool,
                        'GlobalTeamID' : GlobalTeamID,
                        'InjuryStatus' : InjuryStatus,
                        'InjuryBodyPart' : InjuryBodyPart,
                        'InjuryNotes' : InjuryNotes,
                        'InjuryStartDate' : InjuryStartDate
                    })
                    
                    append_df.reset_index(inplace=True, drop=True)
                    master_df = pd.concat([master_df,append_df],axis=0)
            
            return True, master_df
        except ValueError as e:
            print(colors.fail_color + str(e))
            return False, None

class wrapper(object):
    def wrapper_league_hierarchy(self):
        try:
            status, s = sdio.get_payload(base_url=config.base_url,sport=cbb.relative_sport,response_format=cbb.relative_response_format,api_type=cbb.relative_api_type[0],dict_endpoint=endpoint,header=cbb.request_header)
            if status:
                    status, df = cbb.League_LeagueHierarchy(payload=s)
                    if status:
                        schema, table = 'etl', 'League_LeagueHierarchy'
                        print(colors.light_fail_color + 'truncing {}.{}...'.format(schema, table))
                        alcsql.truncate_table(schema,table)
                        alcsql.import_table(df,schema,table)
                        schema, procedure_list = 'ncaa_cbb', ['MERGE_Conferences','MERGE_ConferenceTeams','MERGE_Stadiums','MERGE_StadiumTeams','MERGE_Teams']
                        for procedure in procedure_list:
                            print(colors.light_success_color + 'Executing {}.{} SP...'.format(schema, procedure))
                            alcsql.execute_stored_proc(schema,procedure)
            return True, 200 
        except ValueError:
            return False, ValueError
    
    def wrapper_game_schedules(self):
        try:
            for year in cbb.years_list:
                print(str(year))
                status, s = sdio.get_payload(base_url=config.base_url,sport=cbb.relative_sport,response_format=cbb.relative_response_format,api_type=cbb.relative_api_type[0],dict_endpoint=endpoint.replace('{season}',str(year)),header=cbb.request_header)
                # urlist[:-1]: - once fully loaded, check via sql to only load in latest years
                if status:
                        status, df = cbb.Game_Schedules(payload=s)
                        if status:
                            schema, table = 'etl', 'Game_Schedules'
                            print(colors.light_fail_color + 'truncing {}.{}...'.format(schema, table))
                            alcsql.truncate_table(schema,table)
                            alcsql.import_table(df,schema,table)
                            schema, procedure_list = 'ncaa_cbb', ['MERGE_GameSchedules']
                            for procedure in procedure_list:
                                print(colors.light_success_color + 'Executing {}.{} SP...'.format(schema, procedure))
                                alcsql.execute_stored_proc(schema,procedure)
            return True, 200 
        except ValueError:
            return False, ValueError

    def wrapper_game_stats(self):
        try:
            
            schema, table, i = 'etl', 'Game_GameStats', 0
            print(colors.light_fail_color + 'truncing {}.{}...'.format(schema, table))
            alcsql.truncate_table(schema,table)
            for year in cbb.years_list:
                print(str(year))
                date_list = convert_date(int(year))
                for d in date_list:
                    print(colors.logging_color + str(d))
                    #print(type(d))
                    dobj = datetime.datetime.strptime(d, '%Y-%b-%d')
                    #begin_season, end_season = datetime.datetime.strptime('2022-11-01', '%Y-%m-%d'), datetime.datetime.strptime('2022-03-14', '%Y-%m-%d')
                    #only get regular season
                    # print(dobj)
                    # print(begin_season)
                    # print(end_season)
                    if dobj.month > 3:
                        continue
                    data_check = False
                    if year == cbb.years_list[-1]:
                        status, df = alcsql.execute_query(
                            f'''SELECT DISTINCT [day] as [data_check]
                            FROM [ncaa_cbb].[GameStats]
                            WHERE [day] = CONVERT(DATETIME, '{str(d)}')
                            '''
                            )
                        if df.empty:
                            data_check = status
                    if data_check:
                        status, s = sdio.get_payload(base_url=config.base_url,sport=cbb.relative_sport,response_format=cbb.relative_response_format,api_type=cbb.relative_api_type[1],dict_endpoint=endpoint.replace('{date}',str(d)),header=cbb.request_header)
                        # urlist[:-1]: - once fully loaded, check via sql to only load in latest years
                        status = validate_status_code(s.status_code)
                        if status and not s.content == b'[]':
                                status, df = cbb.Game_PlayerGameStatsByDate(payload=s)
                                if status:
                                    schema, table = 'etl', 'Game_GameStats'
                                    print(colors.light_success_color + 'importing {}.{}...'.format(schema, table))
                                    alcsql.import_table(df,schema,table)
                                    i = i + 1                   
                if i > 0:
                    schema, procedure_list = 'ncaa_cbb', ['MERGE_GameStats']
                    for procedure in procedure_list:
                        print(colors.light_success_color + 'Executing {}.{} SP...'.format(schema, procedure))
                        alcsql.execute_stored_proc(schema,procedure)       
                        print(colors.light_fail_color + 'truncing {}.{}...'.format(schema, table))
                        schema, table = 'etl', 'Game_GameStats'
                        alcsql.truncate_table(schema,table)      
                else:
                    pass
                
            return True, 200 
        except ValueError:
            return False, ValueError
        
    def wrapper_players_active(self):
        try:

            status, s = sdio.get_payload(base_url=config.base_url,sport=cbb.relative_sport,response_format=cbb.relative_response_format,api_type=cbb.relative_api_type[0],dict_endpoint=endpoint,header=cbb.request_header)
            # urlist[:-1]: - once fully loaded, check via sql to only load in latest years
            if status:
                    status, df = cbb.Players_Active(payload=s)
                    if status:
                        x=1
                        schema, table = 'etl', 'Players_Active'
                        print(colors.light_fail_color + 'truncing {}.{}...'.format(schema, table))
                        #alcsql.truncate_table(schema,table)
                        alcsql.import_table(df,schema,table)
                        # schema, procedure_list = 'ncaa_cbb', ['MERGE_Conferences','MERGE_ConferenceTeams','MERGE_Stadiums','MERGE_StadiumTeams','MERGE_Teams']
                        # for procedure in procedure_list:
                        #     print(colors.light_success_color + 'Executing {}.{} SP...'.format(schema, procedure))
                        #     alcsql.execute_stored_proc(schema,procedure)

            return True, 200 
        except ValueError:
            return False, ValueError

sdio, cbb, wrapper = sdio(), cbb(), wrapper()
call_list = list(cbb.relative_url_dict.keys())

for k in cbb.relative_url_dict:
    endpoints_list = cbb.relative_url_dict[k]
    print(colors.logging_color + 'Trying ' + colors.light_success_color + str(k) + colors.logging_color + ' endpoints from sport ...')
    for endpoint in endpoints_list:
            # if k == call_list[0]:
            #     if endpoint == 'LeagueHierarchy':
            #         status, status_code = wrapper.wrapper_league_hierarchy()

            # if k == call_list[1]:
            #     if endpoint == 'Games/{season}':
            #         status, status_code = wrapper.wrapper_game_schedules()
                                        
            #     if endpoint == 'PlayerGameStatsByDate/{date}':
            #         status, status_code = wrapper.wrapper_game_stats()
                    
            if k == call_list[2]:
                if endpoint == 'Players':
                    status, status_code = wrapper.wrapper_players_active()
                # if endpoint == 'Player/{playerid}':
                    # status, df = alcsql.execute_query('SELECT DISTINCT [PlayerID] FROM [ncaa_cbb].')
                    # for year in cbb.years_list:
                    #     print(str(year))
                    #     status, s = sdio.get_payload(base_url=config.base_url,sport=cbb.relative_sport,response_format=cbb.relative_response_format,api_type=cbb.relative_api_type[0],dict_endpoint=endpoint.replace('{playerID}',str(year)),header=cbb.request_header)
                    #     # urlist[:-1]: - once fully loaded, check via sql to only load in latest years
                    #     if status:
                    #             status, df = cbb.Game_Schedules(payload=s)
                    #             if status:
                    #                 schema, table = 'etl', 'Game_Schedules'
                    #                 print(colors.light_fail_color + 'truncing {}.{}...'.format(schema, table))
                    #                 #alcsql.truncate_table(schema,table)
                    #                 alcsql.import_table(df,schema,table)
                    #                 #schema, procedure_list = 'ncaa_cbb', ['MERGE_Conferences','MERGE_ConferenceTeams','MERGE_Stadiums','MERGE_StadiumTeams','MERGE_Teams']
                    #                 #for procedure in procedure_list:
                    #                     #print(colors.light_success_color + 'Executing {}.{} SP...'.format(schema, procedure))
                    #                     #alcsql.execute_stored_proc(schema,procedure)