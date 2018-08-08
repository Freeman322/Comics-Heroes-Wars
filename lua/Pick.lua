if Pick == nil then
  Pick = {}
  Pick.__index = Pick
end

HERO_TABLE = {}
PLAYER_TABLE = {}
BANS = {}
BANS[DOTA_TEAM_GOODGUYS] = {}
BANS[DOTA_TEAM_BADGUYS] = {}
BANS["TOTAL"] = 0
TIMER = 70
CAN_ENTER_GAME = false
MAX_BANS_PER_TEAM = 5

local heroes = {
  "npc_dota_hero_antimage",
  "npc_dota_hero_lycan",
  "npc_dota_hero_tidehunter",
  "npc_dota_hero_zuus",
  "npc_dota_hero_omniknight",
  "npc_dota_hero_chaos_knight",
  "npc_dota_hero_silencer",
 ---- "npc_dota_hero_centaur",
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
----  "npc_dota_hero_viper",
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
  "npc_dota_hero_miraak",
  ---"npc_dota_hero_batrider",
  "npc_dota_hero_nyx_assassin"
}


function Pick:Start()
  CustomGameEventManager:RegisterListener("hero_picked", Dynamic_Wrap(Pick, 'OnPick'))
  CustomGameEventManager:RegisterListener("random_hero", Dynamic_Wrap(Pick, 'OnRandomHeroSelected'))
  CustomGameEventManager:RegisterListener("hero_banned", Dynamic_Wrap(Pick, 'OnBan'))

  GameRules:GetGameModeEntity():SetThink("OnIntervalThink", Pick, 1)
  Convars:RegisterCommand( "try_connect", Dynamic_Wrap(Pick, 'OnConnectFull'), "Test", FCVAR_CHEAT )
  if IsInToolsMode() then
    TIMER = 5
  end
end


function Pick:OnIntervalThink()
  if TIMER >= 0 then
    CustomNetTables:SetTableValue("pick", "timer", {time = TIMER})
    TIMER = TIMER - 1
  else
    return nil
  end

  return 1
end

function Pick:OnPick(params)
  local hero = params.hero
  local playerid = params.playerID
  local team = PlayerResource:GetTeam(playerid)

  if PLAYER_TABLE[playerid] then
    return
  end
  if HERO_TABLE[hero] then
    return
  end
  if Pick:IsHeroBanned(hero) == true then
    return
  end

  if TIMER >= 50 then 
    return
  end

  local gold = 1000;
  local HasRandomed = false;
  if PlayerResource:HasRandomed(playerid) then
    gold = 800;
    HasRandomed = true;
  end

  HERO_TABLE[hero] = hero

  PLAYER_TABLE[playerid] = {}

  PLAYER_TABLE[playerid].playerid = playerid
  PLAYER_TABLE[playerid].hero = hero
  PLAYER_TABLE[playerid].isRandomed = HasRandomed



  PrecacheUnitByNameAsync( hero, function()
	  local nHero = PlayerResource:ReplaceHeroWith(playerid, hero, gold, 0)
	  nHero:RespawnHero(false, false)
  end)
  CustomNetTables:SetTableValue("pick", "heroes", PLAYER_TABLE)
end


function Pick:OnRandomHeroSelected(params)
  local playerid = params.playerID

  if TIMER >= 50 then 
    return
  end
  
  local temp = RandomInt(1, #heroes)

  while HERO_TABLE[hero_name] do
    temp = RandomInt(1, #heroes)
  end
  local hero_name = heroes[temp]

  local keys = {}
  keys.hero = hero_name
  keys.playerID = playerid
  PlayerResource:SetHasRandomed(playerid)
  Pick:OnPick(keys)
end

function Pick:OnConnectFull(  )
  Timers:CreateTimer(1, function()
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(0), "OnConnectFull", {})
    return nil
  end)
end

function Pick:OnBan(params)
	local hero = params.hero
	local playerid = params.playerID
	local team = PlayerResource:GetTeam(playerid)
	if HERO_TABLE[hero_name] then 
		return 
	end
	if #BANS[team] >= MAX_BANS_PER_TEAM then 
		return
	end
	BANS["TOTAL"] = BANS["TOTAL"] + 1
	table.insert(BANS[team], hero)
	CustomNetTables:SetTableValue("pick", "bans", BANS)
end

function Pick:IsHeroBanned(heroname)
  for _,v in pairs(BANS[DOTA_TEAM_GOODGUYS]) do
      if heroname == v then 
        return true
      end
  end
  for _,c in pairs(BANS[DOTA_TEAM_BADGUYS]) do
     if heroname == c then 
        return true
      end
  end
  return false
end