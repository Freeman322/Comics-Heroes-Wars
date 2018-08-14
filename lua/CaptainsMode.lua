SELECTION_DURATION_LIMIT = 100

CURRENT_TIME = SELECTION_DURATION_LIMIT

CM_MODE_CURRENT_STAGE = -1

PICKED_PLAYERS = {}
PICKED_HEROES = {}
CAPTAINS = {}
SELECTED_HEROES = {}

local STAGES = {
    [1] = {
        pick = false,
        team = 2,
        number = 1,
    },
    [2] = {
        pick = false,
        team = 3,
        number = 1,
    },
    [3] = {
        pick = false,
        team = 2,
        number = 2,
    },
    [4] = {
        pick = false,
        team = 3,
        number = 2,
    },
    [5] = {
        pick = true,
        team = 2,
        number = 1,
    },
    [6] = {
        pick = true,
        team = 3,
        number = 1,
    },
    [7] = {
        pick = true,
        team = 3,
        number = 2,
    },
    [8] = {
        pick = true,
        team = 2,
        number = 2,
    },
    [9] = {
        pick = false,
        team = 2,
        number = 3,
    },
    [10] = {
        pick = false,
        team = 3,
        number = 3,
    },
    [11] = {
        pick = false,
        team = 2,
        number = 4,
    },
    [12] = {
        pick = false,
        team = 3,
        number = 4,
    },
    [13] = {
        pick = true,
        team = 3,
        number = 3,
    },
    [14] = {
        pick = true,
        team = 2,
        number = 3,
    },
    [15] = {
        pick = true,
        team = 3,
        number = 4,
    },
    [16] = {
        pick = true,
        team = 2,
        number = 4,
    },
    [17] = {
        pick = false,
        team = 3,
        number = 5,
    },
    [18] = {
        pick = false,
        team = 2,
        number = 5,
    },
    [19] = {
        pick = true,
        team = 3,
        number = 5,
    },
    [20] = {
        pick = true,
        team = 2,
        number = 5,
    },}

local heroes = {
  
}

--[[
  0 - pick captaint
  1 - ban radiant
  2 - ban dire
  3- bam radiant
  4-ban dire
  5 - pick radiant
  6,7 pick dire
  8 pick radiant
  9 - ban radiant
  10 - ban dire
  11- ban radiant
  12-ban dire
  13 picj dire
  14 pick radiant
  15 pick dire
  16 pick radiant
  17 ban radiant
  18 ban dire
  19 pick dire
  20 pick radiant
]]

local END_PICK = false
--Class definition
if CaptainsMode == nil then
    CaptainsMode = {}
    CaptainsMode.__index = CaptainsMode
end
--[[
	Start
	Call this function from your gamemode once the gamestate changes
	to pre-game to start the hero selection.
]]
function CaptainsMode:Start()
    CustomGameEventManager:RegisterListener("captain_selected", Dynamic_Wrap(CaptainsMode, 'OnCaptainSelected'))
    CustomGameEventManager:RegisterListener("hero_selected", Dynamic_Wrap(CaptainsMode, 'OnHeroSelected'))
    CustomGameEventManager:RegisterListener("selected_hero_picked", Dynamic_Wrap(CaptainsMode, 'OnPick'))

    ---Convars:RegisterCommand( "try_connect_cm_mode", Dynamic_Wrap(CaptainsMode, 'OnConnectFull'), "Test", FCVAR_CHEAT )

    GameRules:GetGameModeEntity():SetThink("OnIntervalThink", CaptainsMode, 1)
    CM_MODE_CURRENT_STAGE = 1
    
    heroes = Util:GetAllHeroes()

    CURRENT_TIME = 180
end

function CaptainsMode:OnIntervalThink()
    if CAPTAINS then
        CURRENT_TIME = CURRENT_TIME - 1
        if CURRENT_TIME <= 0 then
            local data = {}
            data.playerID = -1
            data.team = STAGES[CM_MODE_CURRENT_STAGE]["team"]
            data.hero = self:GetRandomHeroName()
            self:OnHeroSelected(data) 

            ----CaptainsMode:OnNextStage()
        end
        CustomNetTables:SetTableValue("captains_mode", "timer", {time = CURRENT_TIME, pick_stage = CM_MODE_CURRENT_STAGE, stage_data = STAGES[CM_MODE_CURRENT_STAGE]})
        if CM_MODE_CURRENT_STAGE > 20 then
            return nil
        end
    end
    return 1
end

function CaptainsMode:OnCaptainSelected(params)
    local playerid = params.playerID
    local team = PlayerResource:GetTeam(playerid)

    if CAPTAINS[team] then
        return
    end

    CAPTAINS[team] = playerid

    CustomNetTables:SetTableValue("captains_mode", "captains", CAPTAINS)
end

function CaptainsMode:OnNextStage()
    CM_MODE_CURRENT_STAGE = CM_MODE_CURRENT_STAGE + 1
    CURRENT_TIME = SELECTION_DURATION_LIMIT

    if STAGES[CM_MODE_CURRENT_STAGE] then
        local curr_stage = {}
        curr_stage.stage = CM_MODE_CURRENT_STAGE
        curr_stage.IsPick = STAGES[CM_MODE_CURRENT_STAGE]["pick"]
        curr_stage.team = STAGES[CM_MODE_CURRENT_STAGE]["team"]
        curr_stage.number = STAGES[CM_MODE_CURRENT_STAGE]["number"]

        CustomNetTables:SetTableValue("captains_mode", "stage", curr_stage)
    end
    if CM_MODE_CURRENT_STAGE > 20 then
        CustomNetTables:SetTableValue("captains_mode", "end_pick", PICKED_HEROES)
        return nil
    end
end

function CaptainsMode:OnHeroSelected(params)
    local playerid = params.playerID
    local hero = params.hero
    local team = params.team

    if STAGES[CM_MODE_CURRENT_STAGE]["team"] ~= team then
        return
    end
    if PICKED_HEROES[hero] then
        return
    end

    PICKED_HEROES[hero] = {}
    PICKED_HEROES[hero].IsPick = STAGES[CM_MODE_CURRENT_STAGE]["pick"]
    PICKED_HEROES[hero].team = STAGES[CM_MODE_CURRENT_STAGE]["team"]
    PICKED_HEROES[hero].number = STAGES[CM_MODE_CURRENT_STAGE]["number"]
    PICKED_HEROES[hero].isUsed = true
    CustomNetTables:SetTableValue("captains_mode", "heroes", PICKED_HEROES)
    CaptainsMode:OnNextStage()
end

function CaptainsMode:GetRandomHeroName()
    local temp = RandomInt(1, #heroes)
    while PICKED_PLAYERS[heroes[temp]] do
        temp = RandomInt(1, #heroes)
    end
    return heroes[temp]
end

function CaptainsMode:OnPick(params)
    local playerid = params.playerID
    local hero = params.hero
    local team = params.team
    if SELECTED_HEROES[hero] then
        return
    end
    if PICKED_HEROES[hero] then
        if PICKED_HEROES[hero].team ~= team then
            return
        end
        if PICKED_HEROES[hero].IsPick ~= true then
            return
        end
        PrecacheUnitByNameAsync( hero, function()
            local nHero = PlayerResource:ReplaceHeroWith(playerid, hero, 2000, 0)
            nHero:RespawnHero(false, false)
        end)
        PICKED_PLAYERS[playerid] = {}
        PICKED_PLAYERS[playerid].IsPicked = true
        PICKED_PLAYERS[playerid].hero = hero
        PICKED_PLAYERS[playerid].team = team

        SELECTED_HEROES[hero] = true

        CustomNetTables:SetTableValue("captains_mode", "picked_players", PICKED_PLAYERS)
        local player = PlayerResource:GetPlayer(playerid)
        CustomGameEventManager:Send_ServerToPlayer(player, "EndPick", {})
    end
    return nil
end

function CaptainsMode:GetCaptains()
  local result = {}
  for id, data in pairs(PLAYERS) do
    if data.captain == true then 
      table.insert( result, data )
    end 
  end

  return result
end