--[[
 Hero selection module for D2E.
 This file basically just separates the functions related to hero selection from
 the other functions present in D2E.
]]
local exeptions = {}

local OnPickTable = {}

SELECTION_DURATION_LIMIT = 90

CURRENT_TIME = SELECTION_DURATION_LIMIT
--Constant parameters

CM_MODE_CURRENT_STAGE = -1

PICKED_PLAYERS = {}
SELECTED_HEROES = {}

local IsOver = {}

local captains = 0

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
"npc_dota_hero_antimage",
"npc_dota_hero_lycan",
"npc_dota_hero_tidehunter",
"npc_dota_hero_zuus",
"npc_dota_hero_omniknight",
"npc_dota_hero_chaos_knight",
"npc_dota_hero_silencer",
"npc_dota_hero_centaur",
"npc_dota_hero_invoker",
"npc_dota_hero_storm_spirit",
"npc_dota_hero_elder_titan",
"npc_dota_hero_crystal_maiden",
"npc_dota_hero_enigma",
"npc_dota_hero_arc_warden",
"npc_dota_hero_terrorblade",
"npc_dota_hero_skeleton_king",
"npc_dota_hero_bloodseeker",
"npc_dota_hero_beastmaster",
"npc_dota_hero_axe",
"npc_dota_hero_rubick",
"npc_dota_hero_brewmaster",
"npc_dota_hero_juggernaut",
"npc_dota_hero_earth_spirit",
"npc_dota_hero_ember_spirit",
"npc_dota_hero_oracle",
"npc_dota_hero_lina",
"npc_dota_hero_pudge",
"npc_dota_hero_rattletrap",
"npc_dota_hero_dazzle",
"npc_dota_hero_meepo",
"npc_dota_hero_necrolyte",
"npc_dota_hero_obsidian_destroyer",
"npc_dota_hero_dark_seer",
"npc_dota_hero_sniper",
"npc_dota_hero_faceless_void",
"npc_dota_hero_shadow_demon",
"npc_dota_hero_night_stalker",
"npc_dota_hero_pugna",
"npc_dota_hero_treant",
"npc_dota_hero_life_stealer",
"npc_dota_hero_lone_druid",
"npc_dota_hero_kunkka",
"npc_dota_hero_sven",
"npc_dota_hero_ursa",
"npc_dota_hero_ancient_apparition",
"npc_dota_hero_templar_assassin",
"npc_dota_hero_spectre",
"npc_dota_hero_alchemist",
---"npc_dota_hero_clinkz",
"npc_dota_hero_weaver",
"npc_dota_hero_gyrocopter",
"npc_dota_hero_venomancer",
"npc_dota_hero_troll_warlord",
"npc_dota_hero_razor",
---"npc_dota_hero_tinker",
"npc_dota_hero_vengefulspirit",
"npc_dota_hero_legion_commander",
"npc_dota_hero_tusk",
"npc_dota_hero_skywrath_mage",
"npc_dota_hero_nevermore",
"npc_dota_hero_dragon_knight",
"npc_dota_hero_viper",
"npc_dota_hero_bane",
"npc_dota_hero_slark",
"npc_dota_hero_spirit_breaker",
"npc_dota_hero_doom_bringer",
"npc_dota_hero_undying",
"npc_dota_hero_windrunner",
"npc_dota_hero_magnataur",
"npc_dota_hero_riki",
"npc_dota_hero_furion",
"npc_dota_hero_sand_king",
"npc_dota_hero_lich",
"npc_dota_hero_phantom_lancer",
"npc_dota_hero_visage",
"npc_dota_hero_slardar",
"npc_dota_hero_phantom_assassin",
"npc_dota_hero_shredder",
"npc_dota_hero_shadow_shaman",
"npc_dota_hero_enchantress",
"npc_dota_hero_abyssal_underlord",
"npc_dota_hero_lion",
"npc_dota_hero_earthshaker",
"npc_dota_hero_abaddon",
"npc_dota_hero_death_prophet",
----"npc_dota_hero_morphling",
"npc_dota_hero_monkey_king",
"npc_dota_hero_bounty_hunter",
"npc_dota_hero_warlock",
"npc_dota_hero_jakiro",
"npc_dota_hero_disruptor",
"npc_dota_hero_bristleback",
"npc_dota_hero_pangolier",
"npc_dota_hero_batrider",
"npc_dota_hero_nyx_assassin"
}

local CAPTAINS = {}
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
20 pick radiant]]

local PICKED_HEROES = {}

local CURRENT_CAPTAIN = {}

local END_PICK = false
--Class definition
if CaptainsMode == nil then
	CaptainsMode = {}
	CaptainsMode.__index = CaptainsMode
end
nCAPTAINS = 0
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
end

function CaptainsMode:OnIntervalThink()
  if nCAPTAINS > 0 then
    CURRENT_TIME = CURRENT_TIME - 1
    if CURRENT_TIME <= 0 then
      CaptainsMode:OnNextStage()
    end
    CustomNetTables:SetTableValue("captains_mode", "timer", {time = CURRENT_TIME, pick_stage = CM_MODE_CURRENT_STAGE})
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
  nCAPTAINS = nCAPTAINS + 1
  CAPTAINS[team] = playerid
  DeepPrintTable(CAPTAINS)
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
    while picked_players[heroes[temp]] do
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
  		nHero:RespawnHero(false, true, false)
  	end)
    PICKED_PLAYERS[playerid] = {}
    PICKED_PLAYERS[playerid].IsPicked = true
    PICKED_PLAYERS[playerid].hero = hero

    SELECTED_HEROES[hero] = true

    CustomNetTables:SetTableValue("captains_mode", "picked_players", PICKED_PLAYERS)
    local player = PlayerResource:GetPlayer(playerid)
    CustomGameEventManager:Send_ServerToPlayer(player, "EndPick", {})
  end
  return nil
end

--[[function CaptainsMode:OnConnectFull(keys)
    local playerid = 0----keys.PlayerID
	  local player = PlayerResource:GetPlayer(playerid)
    print("Player has reconected")
    print(playerid)
    Timers:CreateTimer(0.1, function()
	    CustomGameEventManager:Send_ServerToPlayer(player, "UpdateOnConnection", PICKED_PLAYERS)
    end)
end]]
