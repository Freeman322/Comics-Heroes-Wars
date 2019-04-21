--Class definition
if Vote == nil then
  Vote = {}
  Vote.__index = Vote
end

RESULT = {}
RESULT[DOTA_TEAM_BADGUYS] = {}
RESULT[DOTA_TEAM_GOODGUYS] = {}

VOTES_TO_WIN_RADIANT = 5;
VOTES_TO_WIN_DIRE = 5;

function Vote:OnInit()
    if GetMapName() == "dota_overthrow" then
      return
    end
    CustomGameEventManager:RegisterListener("vote_get", Dynamic_Wrap(Vote, 'RegisterVote'))
    CustomNetTables:SetTableValue( "globals", "votes", {} )

    GameRules:GetGameModeEntity():SetThink( "OnThink", Vote, 10 )
end


function Vote:RegisterVote(data)
  local pID = data['pID']
  local team = data['team']

  if RESULT[team][pID] then return end

  RESULT[team][pID] = true
  CustomNetTables:SetTableValue( "globals", "votes", RESULT )
end

function Vote:OnThink()
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    VOTES_TO_WIN_DIRE = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
    VOTES_TO_WIN_RADIANT = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
    if Util:GetArrayLength(RESULT[DOTA_TEAM_GOODGUYS]) == VOTES_TO_WIN_RADIANT and VOTES_TO_WIN_RADIANT > 0 then
      GameRules:EndGame(DOTA_TEAM_GOODGUYS) return
    end
    if Util:GetArrayLength(RESULT[DOTA_TEAM_BADGUYS]) == VOTES_TO_WIN_DIRE and VOTES_TO_WIN_DIRE > 0 then
      GameRules:EndGame(DOTA_TEAM_BADGUYS) return
    end

    for i = 0, DOTA_MAX_PLAYERS do
      local team = PlayerResource:GetTeam(i)
      if PlayerResource:GetConnectionState(i) >= DOTA_CONNECTION_STATE_DISCONNECTED and PlayerResource:IsValidPlayerID(i) and not RESULT[team][i] then
        RESULT[team][i] = true
        CustomNetTables:SetTableValue( "globals", "votes", RESULT )
      end
    end
  end

  return 10
end
