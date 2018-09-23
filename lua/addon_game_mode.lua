-- Generated from template
require "timers"
require('notifications')
require('attachments')
require('statcollection/init')
require('Pick')
require('Util')
require('Trades')
require('Vote')
require('playertables')
require('utils/Talents')
require('Network')
require('FreeForAll')
require('addon_init')
require('CaptainsMode')
require('heroes/Responses')

if GameMode == nil then
	GameMode = class({})
end

function Precache( context )
	print("PRECASHE STARTED")
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_puck.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_broodmother.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_witch_doctor.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_crystal_maiden.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bane.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_storm_spirit.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_rubick.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_drow_ranger.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_arc_warden.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_furion.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_weaver.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_monkey_king.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context )

	PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_zoom.vsndevts", context)


	PrecacheResource("model", "models/development/invisiblebox.vmdl", context)
	PrecacheResource("particle", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context)
	PrecacheResource("particle", "particles/rain_fx/econ_weather_underwater.vpcf", context)
	PrecacheResource("particle", "particles/rain_fx/econ_snow.vpcf", context)

	PrecacheResource("soundfile", "soundevents/custom_sounds.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/hero_zoom.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/hero_manhattan.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
    PrecacheResource("soundfile", "soundevents/soundevents_conquest.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/event_lich_king.vsndevts", context )
    PrecacheResource("particle", "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf", context )
    PrecacheResource("particle", "particles/rain_fx/econ_weather_aurora.vpcf", context )
    PrecacheResource("particle", "particles/rain_fx/econ_weather_sirocco.vpcf", context )
    PrecacheResource("particle", "particles/rain_fx/econ_weather_pestilence.vpcf", context )
    PrecacheResource("particle", "particles/rain_fx/econ_weather_spring.vpcf", context )
	PrecacheItemByNameSync( "item_bag_of_gold", context )
	PrecacheResource("particle", "particles/econ/events/ti7/hero_levelup_ti7_flash_hit_magic.vpcf", context )

	PrecacheResource("soundfile", "soundevents/sounds_miraak.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/event.vsndevts", context )

	PrecacheResource("model", "models/creeps/lane_creeps/creep_bad_melee_diretide/creep_bad_melee_diretide.vmdl", context)
	PrecacheResource("model", "models/creeps/creep_meee_mega/creep_melee_enemy.vmdl", context)
	PrecacheResource("model", "models/creeps/creeps_range/radiant/creep_ranged.vmdl", context)
	PrecacheResource("model", "models/creeps/creeps_range/radiant/creep_ranged_mega.vmdl", context)
	PrecacheResource("model", "models/heroes/hero_ragnaros/ragnaros_skirt.vmdl", context)
	PrecacheResource("model", "models/items/abaddon/feathers/feathers_weapon.vmdl", context)
	PrecacheResource("model", "models/b2/weapon/weapon.vmdl", context)
	PrecacheResource("model", "models/items/abaddon/sword_iceshard/sword_iceshard.vmdl", context)

	if GetMapName() == "the_summoning_event" then
		PrecacheResource("model", 		"models/npc/npc_dingus/dingus.vmdl", context)
		PrecacheResource("model", 		"models/creeps/omniknight_golem/omniknight_golem.vmdl", context)
		PrecacheResource("model", 		"models/creeps/thief/thief_01_archer.vmdl", context)
		PrecacheResource("particle", 	"particles/units/heroes/hero_drow/drow_base_attack.vpcf", context )

		PrecacheItemByNameSync( "item_book_of_knowledge", context )
	end
	
	print("PRECASHE ENDED")
end


---CONSTANTS 

DOTA_DAMAGE_MULTIPLIER_MAGICAL_HEAL = 0.35
DOTA_DAMAGE_MULTIPLIER_MAGICAL_CRIT = 0.75
DOTA_DAMAGE_MULTIPLIER_MAGICAL_CRIT_CHANCE = 25
-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
	Convars:SetInt("dota_wait_for_players_to_load_timeout", 240)
end
function GameMode:InitGameMode()
	GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetHeroRespawnEnabled( true )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetHeroSelectionTime( 0.0 )
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 20 )

	if GetMapName() == "dota_captains_mode" then GameRules:SetPreGameTime( 700.0 ) else GameRules:SetPreGameTime( 120.0 ) end

	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetHeroMinimapIconScale( 0.7 )
	GameRules:SetCreepMinimapIconScale( 0.7 )
	GameRules:SetRuneMinimapIconScale( 0.7 )
	GameRules:SetGoldTickTime( 1 )
	GameRules:SetGoldPerTick( 13 )
	GameRules:GetGameModeEntity():SetFixedRespawnTime(10)
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)

	if GetMapName() == "the_summoning_event" then
		GameRules:SetCustomGameTeamMaxPlayers(3, 0)
		GameRules:SetCustomGameTeamMaxPlayers(2, 6)
		GameRules:SetHeroRespawnEnabled( false )
		GameRules:GetGameModeEntity():SetBuybackEnabled( false )
		GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
		GameRules:SetPostGameTime( 60.0 )
		GameRules:SetTreeRegrowTime( 900.0 )
		GameRules:SetHeroMinimapIconScale( 0.5 )
		GameRules:SetCreepMinimapIconScale( 0.5 )
		GameRules:SetRuneMinimapIconScale( 0.5 )
		GameRules:SetGoldTickTime( 1 )
		GameRules:SetGoldPerTick( 1 )

		GameRules:SetPreGameTime( 20.0 )
	end

	if GetMapName() == "free_for_all" then
		FreeForAll:Start()
		GameRules:GetGameModeEntity():SetFixedRespawnTime(5)
		GameRules:SetCustomGameTeamMaxPlayers(3, 1)
		GameRules:SetCustomGameTeamMaxPlayers(2, 1)
		GameRules:SetCustomGameTeamMaxPlayers(6, 1)
		GameRules:SetCustomGameTeamMaxPlayers(7, 1)
		GameRules:SetCustomGameTeamMaxPlayers(8, 1)
		GameRules:SetCustomGameTeamMaxPlayers(9, 1)
		GameRules:SetCustomGameTeamMaxPlayers(10, 1)
		GameRules:SetCustomGameTeamMaxPlayers(11, 1)
		GameRules:SetCustomGameTeamMaxPlayers(12, 1)
		GameRules:SetCustomGameTeamMaxPlayers(13, 1)

		GameRules:SetGoldTickTime( 1 )
		GameRules:SetGoldPerTick( 25 )
	end

	XP_PER_LEVEL_TABLE = {
		0, 	   --- 1
		300,   --- 2
		500,   --- 3
		800,   --- 4
		1200,  --- 5
		1700,  --- 6
		2300,  --- 7
		3000,  --- 8
		3800,  --- 9
		4700,  --- 10
		5700,  --- 11
		6800,  --- 12
		8000,  --- 13
		9300,  --- 14
		10700, --- 15
		12200, --- 16
		13800, --- 17
		15400, --- 18

		22400, --- 19
		24600, --- 20
		27000, --- 21
		29600, --- 22
		32400, --- 23
		35400, --- 24
		38600, --- 25

		40000, --- 26
		42000, --- 27
		44000, --- 28
		46000, --- 29
		48000, --- 30

		50000, --- 31
		53000, --- 32
		56000, --- 33
		59000, --- 34
		62000,
	}

	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)

	if GetMapName() == "the_summoning_event" then GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_thief" ) else GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_wisp" ) end

	Convars:SetInt("dota_wait_for_players_to_load_timeout", 240)
	Convars:SetInt("dota_combine_models", 0 )

	-- Hook into game events allowing reload of functions at run time
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( GameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "player_reconnected", Dynamic_Wrap( GameMode, 'OnPlayerReconnected' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, "OnGameRulesStateChange" ), self )

	ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( GameMode, "OnAbilityLearned" ), self )

	-- Register OnThink with the game engine so it is called every 0.25 seconds
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 )

	self.countdownEnabled = true
	CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )

	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap( GameMode, "DmgFilter" ), self)
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap( GameMode, "InventoryFilter" ), self)

	GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap( GameMode, "AbilityTuningValueFilter" ), self)
	GameRules:GetGameModeEntity():SetHealingFilter(Dynamic_Wrap( GameMode, "HealingFilter" ), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap( GameMode, "ModifierFilter" ), self)
	GameRules:GetGameModeEntity():SetTrackingProjectileFilter(Dynamic_Wrap( GameMode, "ProjectileFilter" ), self)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap( GameMode, "OrderFilter" ), self)

	SendToServerConsole( "dota_combine_models 0" )	
	self._tPlayerIDToAccountRecord = {}

	Util:OnInit()
	Trades:Init()
	Vote:OnInit()
	GameRules.Globals = {};
	GameRules.Globals.Couriers = {};
	GameRules.Globals.Quests = {};
	GameRules.Globals.Compendium = {};
	_G.Players = {}
	_G.Players[DOTA_TEAM_BADGUYS] = {}
	_G.Players[DOTA_TEAM_GOODGUYS] = {}

	GameRules.Globals.Event = {}
end
function GameMode:OnGameRulesStateChange(keys)
  local newState = GameRules:State_Get()
  if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
    self.bSeenWaitForPlayers = true
 	 elseif newState == DOTA_GAMERULES_STATE_INIT then
	elseif newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		GameMode:OnGameStarted(keys)
  elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
    GameMode:OnAllPlayersLoaded()
    if USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS then
      for i=0,9 do
        if PlayerResource:IsValidPlayer(i) then
          local color = TEAM_COLORS[PlayerResource:GetTeam(i)]
          PlayerResource:SetCustomPlayerColor(i, color[1], color[2], color[3])
        end
      end
    end
  elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    GameMode:OnGameInProgress()
	elseif newState == DOTA_GAMERULES_STATE_POST_GAME then
		GameMode:OnGameEnded(keys)
  	end
end
function GameMode:OnGameStarted(keys)
	Network:GetData("stats", 0)
	Network:GetInventories()
end
function GameMode:OnGameEnded(keys)
	if GameRules:IsCheatMode() == false and IsInToolsMode() == false then
		local playes_rad = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
		local playes_dire = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
		if playes_rad > 0 and playes_dire > 0 then
			if GetMapName() ~= "free_for_all" then
				if GameRules:IsCheatMode() == false then 
					Network:RollDrop()
					Network:GetData("stats", 1)
					Util:TryGetCompendiumData()
				end
			end
		end
	end
end
function GameMode:OnGameInProgress()
	_G.Players[DOTA_TEAM_GOODGUYS] = Util:GetPlayersForTeam(DOTA_TEAM_GOODGUYS)
	_G.Players[DOTA_TEAM_BADGUYS] = Util:GetPlayersForTeam(DOTA_TEAM_BADGUYS)


	Network:CheckGameState()
end
function GameMode:OnThink()
	local playes_rad = PlayerResource:GetPlayerCountForTeam(2)
	local playes_dire = PlayerResource:GetPlayerCountForTeam(3)
	if playes_rad > 0 and playes_dire > 0 then
		if GameRules:IsCheatMode() == false and IsInToolsMode() == false then
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and GetMapName() ~= "dota_overthrow" then
				Util:CheckGameState()
			end
		end
	end
	if (GameRules:GetGameTime() / 60) >= NIAN_CREEP_TIME then
	  NIAN_CREEP_TIMER = NIAN_CREEP_TIMER + 1
	  if NIAN_CREEP_TIMER >= NIAN_CREEP_PEREOD then
	    local radiant_spawn = Entities:FindByName(nil, "radiant_spawner_beast")
	    local dire_spawn = Entities:FindByName(nil, "dire_spawner_beast")
	    local waypoint_radiant = Entities:FindByName( nil, "lane_mid_pathcorner_goodguys_1")
	    local waypoint_dire = Entities:FindByName( nil, "lane_mid_pathcorner_badguys_1")

	    PrecacheUnitByNameAsync("npc_dota_beast", function()
	    local unit = CreateUnitByName( "npc_dota_beast", radiant_spawn:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	    unit:SetInitialGoalEntity( waypoint_radiant )
	    end)

	    PrecacheUnitByNameAsync("npc_dota_beast", function()
	    local unit = CreateUnitByName( "npc_dota_beast", dire_spawn:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	    unit:SetInitialGoalEntity( waypoint_dire )
	    end)
	    NIAN_CREEP_TIMER = 0
	  end
	end
	return 1
end
function GameMode:OnNPCSpawned(keys)
  local npc = EntIndexToHScript(keys.entindex)

  if npc:IsRealHero() and npc.bFirstSpawned == nil then
      npc.bFirstSpawned = true
      Util:OnHeroInGame(npc)
  end
end
function GameMode:OnEntityKilled( keys )
  local killedUnit = EntIndexToHScript( keys.entindex_killed )

  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  -- Put code here to handle when an entity gets killed
   if killedUnit:GetUnitName() == "npc_dota_creature_yaz" and killerEntity:IsRealHero() then
   		local playerName = tostring(PlayerResource:GetPlayerName(tonumber(killerEntity:GetPlayerOwnerID())))

     	EmitGlobalSound("diretide_select_target_Stinger")

     	local res = playerName .. " killed Yaz'!"
    	GameRules:SendCustomMessage(res, 0, 0)
    end
    if killedUnit:IsRealHero() then
		if GetMapName() == "dota_overthrow" and GetTeamHeroKills(killerEntity:GetTeam()) >= 50 then
			GameRules:SetSafeToLeave( true )
			GameRules:SetGameWinner( killerEntity:GetTeam() )
		end
    end
end
function GameMode:DmgFilter(ftable)
	if pcall(function ()
			local attacker
			if ftable.entindex_attacker_const then attacker = EntIndexToHScript(ftable.entindex_attacker_const) end
			local victim = EntIndexToHScript(ftable.entindex_victim_const)
			local damage = ftable.damage
  
			  if attacker ~= nil then
				  if victim:HasModifier("modifier_franklin_global_retrocausality_friendly") then
					  local modifier = victim:FindModifierByName("modifier_franklin_global_retrocausality_friendly")
					  if modifier then
						  local target = EntIndexToHScript(modifier:GetTarget())
						  if target:IsAlive() then 
							  target:ModifyHealth(target:GetHealth() - damage, modifier:GetAbility(), true, 0)
						  end
						  ftable.damage = 0
					  end					
				  end
				  if attacker:HasModifier( "modifier_tzeentch_warp_connection" ) then
					  local modifier = attacker:FindModifierByName("modifier_tzeentch_warp_connection")
					  if attacker:GetTeamNumber() == modifier:GetCaster():GetTeamNumber() then
						  ftable.damage = ftable.damage * modifier:GetAbility():GetSpecialValueFor("damage_amplification")
					  else
						  ftable.damage = ftable.damage * modifier:GetAbility():GetSpecialValueFor("damage_reducrion")
					  end
					  return true
				  end
				  if victim:HasModifier( "modifier_item_ritual_rapier_active" ) then
					  local restore = damage
  
					  local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
					  local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, attacker)
					  ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())
  
					  attacker:Heal(restore, attacker)
				  end
				  if victim:HasModifier( "modifier_thanos_believer" ) and not victim:HasModifier("modifier_item_timepiece")  then 
					  if damage > victim:GetHealth() then 
						  local modifer = victim:FindModifierByName("modifier_thanos_believer")
						  if modifer and modifer:GetAbility():IsCooldownReady() then
							  modifer:GetAbility():StartCooldown(modifer:GetAbility():GetCooldown(modifer:GetAbility():GetLevel()))
							  victim:AddNewModifier( victim, modifer, "modifier_item_aeon_disk_buff", {duration = modifer:GetAbility():GetDuration()} )
							  victim:AddNewModifier( victim, modifer, "modifier_item_lotus_orb_active", {duration = modifer:GetAbility():GetDuration()} ) 
  
							  ftable.damage = 0
						  end
					  end
				  end
				  if victim:HasModifier( "item_time_gem" ) then
					  if damage > victim:GetHealth() then 
						  local modifer = victim:FindModifierByName("item_time_gem")
						  if modifer ~= nil then
							  if modifer:OnTime(attacker, victim) then 
								  ftable.damage = 0
								  return false
							  end					
						  end 
					  end					
				  end
				  if victim:HasModifier( "modifier_item_dawnbreaker" ) and not victim:HasModifier("modifier_item_timepiece")  then 
					  if damage > victim:GetHealth() then 
						  local modifer = victim:FindModifierByName("modifier_item_dawnbreaker")
						  if modifer:GetAbility():IsCooldownReady() then 
							  ftable.damage = 0
						  end
						  modifer:SoulTransform() 
						  return false
					  end					
				  end
				  if victim:HasModifier( "modifier_item_dawnbreaker_active" ) then 
					  return false
				  end
				  if attacker:HasItemInInventory("item_soul_urn") and ftable.damagetype_const > 1 then
					  if RollPercentage(DOTA_DAMAGE_MULTIPLIER_MAGICAL_CRIT_CHANCE) then
						  ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_POINT_FOLLOW, victim)
						  ftable.damage = ftable.damage + (ftable.damage * DOTA_DAMAGE_MULTIPLIER_MAGICAL_CRIT)
					  end
				  end
				  if attacker:HasItemInInventory("item_ethernal_dagon_scepter") and ftable.damagetype_const > 1 then
					  local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
					  local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, attacker)
					  ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())


					  attacker:Heal(ftable.damage * DOTA_DAMAGE_MULTIPLIER_MAGICAL_HEAL, attacker)
				  end
				  if attacker:HasModifier("modifier_item_adamachi_core") and ftable.damagetype_const > 1 then
					  local restore = damage*0.15
					  local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
					  local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, attacker)
					  ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())
					  attacker:Heal(restore, attacker)
				  end
				  if victim:HasModifier("modifier_zatana_eclipse") then
					  if _G.attackers_table[victim] == nil then
						  _G.attackers_table[victim] = {}
					  end
					  _G.attackers_table[victim][attacker] = _G.attackers_table[victim][attacker] or {}
					  _G.attackers_table[victim][attacker].damage = (_G.attackers_table[victim][attacker].damage or 0) + (damage or 0)
					  return false
				  end
				  if ftable.entindex_inflictor_const then
					  local ability = EntIndexToHScript(ftable.entindex_inflictor_const)
					  if ability:GetName() == "joker_land_mines" or ability:GetName() == "joker_remote_mines" then
						  local new_damage = GameMode:GetCompositeDamage(ftable.damage, victim)
						  ftable.damage = new_damage
  
						  if ability:GetCaster():HasTalent("special_bonus_unique_joker") then 
							  ftable.damage = ftable.damage + ability:GetCaster():FindTalentValue("special_bonus_unique_joker")
						  end
					  end
				  end
				  if attacker:GetUnitName() == "npc_dota_kracken" and victim:IsBuilding() then
					  ftable.damage = ftable.damage / 4
				  end
			  end	
			  if victim:HasModifier("modifier_ares_terrorize") then
				  local dmf = ftable.damage
				  ftable.damage = 0
  
				  local buff = victim:FindModifierByName("modifier_ares_terrorize")
				  victim:ModifyHealth(victim:GetHealth() - dmf, buff:GetAbility(), true, 0)
			  end
		end) then else
		printd("We have an eror in dmg filter")
		print("We have an eror in dmg filter")
	end
	return true
end

function GameMode:UpdateTowersAbilities()
	--[[LinkLuaModifier("modifier_backdoor_tower", "modifiers/modifier_backdoor_tower.lua", LUA_MODIFIER_MOTION_NONE)

    local towers = Entities:FindAllByClassname("npc_dota_tower")
    for k, tower in pairs(towers) do
		tower:AddNewModifier(tower, nil, "modifier_backdoor_tower", nil)
        for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
            local current_ability = tower:GetAbilityByIndex(i)
            if current_ability ~= nil then
                if current_ability:GetLevel() == 0 then
                    current_ability:SetLevel(4)
                end
            end
        end
    end]]--
    
	local towers = Entities:FindAllByClassname("dota_fountain")
    for k, tower in pairs(towers) do
        for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
            local current_ability = tower:GetAbilityByIndex(i)
            if current_ability ~= nil then
                if current_ability:GetLevel() == 0 then
                    current_ability:SetLevel(4)
                end
            end
        end
    end
    local forts = Entities:FindAllByClassname("npc_dota_fort")
    for k, fort in pairs(towers) do
        for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
           local current_ability = fort:GetAbilityByIndex(i)
           if current_ability ~= nil then
                if current_ability:GetLevel() == 0 then
                    current_ability:SetLevel(4)
                end
            end
        end
    end
end

function GameMode:InventoryFilter(params)
	local item_name = EntIndexToHScript(params.item_entindex_const) or nil
	if item_name then 
		if item_name:GetName() == "item_inf_balvanka" and GetMapName() == "dota_captains_mode" then return false end 
	end

	return true
end

function GameMode:GetCompositeDamage(damage, target)
    local magical_damage = damage/2
    local physical_damage = damage/2
    local armor = target:GetPhysicalArmorValue()
    local magical_armor = target:GetMagicalArmorValue()/100

    local mult = (1 - (0.06 * armor)) / (1 + (0.06 * armor))

    local phys_damage_comp = physical_damage*mult

    local mag_damage = magical_damage*(1 - magical_armor)

    return magical_damage + phys_damage_comp
end

function GameMode:OnAllPlayersLoaded()
	GameMode:UpdateTowersAbilities()

	LinkLuaModifier("modifier_creeps", "modifiers/modifier_creeps.lua", LUA_MODIFIER_MOTION_NONE)
	Timers:CreateTimer(1, function()
		local creeps = Entities:FindAllByClassname("npc_dota_creep_lane")
		for _,npc in pairs(creeps) do
			if not npc:HasModifier("modifier_creeps") then
				npc:AddNewModifier(npc, nil, "modifier_creeps", nil)
			end
		end

		local catapultes = Entities:FindAllByClassname("npc_dota_creep_siege")
		for _,catapulte in pairs(catapultes) do
			if not catapulte:HasModifier("modifier_creeps") then
				catapulte:AddNewModifier(catapulte, nil, "modifier_creeps", nil)
			end
		end
        return 1
	end)
	
    if IsInToolsMode() == false and GetMapName() == "the_summoning_event" then 
	   ---EmitGlobalSound("intro.predator_update")
    end

	local playes_rad = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	local playes_dire = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
	local IsCalibraiting = false
	if playes_rad > 0 and playes_dire > 0 then
		IsCalibraiting = true
	end

	CustomNetTables:SetTableValue( "rating", "rating_cal", {cal = IsCalibraiting} )
	if GetMapName() == "dota" or GetMapName() == "dota_captains_mode" then
		local forts = Entities:FindAllByClassname('npc_dota_fort')
		for k, v in pairs(forts) do
			if v:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				_G.Dire_fort = v
			else
				_G.Radiant_fort = v
			end
		end
	end
	if GetMapName() == "the_summoning_event" then
		Event:Start()
	elseif GetMapName() == "dota_captains_mode" then
		CaptainsMode:Start()
	else
		Pick:Start()
	end
end

function printd( msg )
	CustomGameEventManager:Send_ServerToAllClients("OnErrorOccupied", {data = msg})
end

function CDOTAGamerules:printd( msg, pID )
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "OnErrorOccupied", {data = msg})
end

function GameMode:AbilityTuningValueFilter(params)
	return true
end

function GameMode:HealingFilter(params)
	return true
end

function GameMode:ModifierFilter(params)
	local ability_entindex = params.entindex_ability_const
	local parent_entindex = params.entindex_parent_const
	local modifier = params.name_const
	local caster_entindex = params.entindex_caster_const or parent_entindex

	---ability, unit, caster, modifier
	if ability_entindex and parent_entindex then 
		Util:OnModifierWasApplied( EntIndexToHScript(ability_entindex), EntIndexToHScript(parent_entindex), EntIndexToHScript(caster_entindex), modifier)
	end 
	if not ability_entindex and parent_entindex then 
		Util:OnModifierWasApplied( nil, EntIndexToHScript(parent_entindex), EntIndexToHScript(caster_entindex), modifier)
	end 
	return true
end

function GameMode:ProjectileFilter(params)
	return true
end

function GameMode:OrderFilter(params)
	return true
end

function GameMode:OnAbilityLearned(params)
	Util:LearnedAbility( params )
end