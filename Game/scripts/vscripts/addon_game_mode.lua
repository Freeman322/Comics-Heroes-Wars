require "timers"
require('attachments')
require('Pick')
require('Util')
require('Trades')
require('Vote')
require('playertables')
require('utils/Talents')
require('tdm')
require('reports')
require('addon_init')
require('CaptainsMode')
require('Stats')
require('Event')

local vCenter = Vector( 706.149, 3112.51, 235.403 )
local iCone = 0.08715

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
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bane.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context)
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
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context)
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
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts", context)
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
	PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_grimstroke.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_grimstroke.vsndevts", context )

	PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_zoom.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/heroes/hero_kyloren.vsndevts", context )


    PrecacheResource("model", "models/pets/kawaii_pet/kawaii.vmdl", context)
	PrecacheResource("model", "models/development/invisiblebox.vmdl", context)
	PrecacheResource("model", "models/items/courier/amaterasu/amaterasu.vmdl", context)
	PrecacheResource("model", "models/pets/drodo/drodo.vmdl", context)
	PrecacheResource("model", "models/heroes/hero_elsa/elsa.vmdl", context)
    PrecacheResource("model", "models/pets/osky/osky.vmdl", context)
    PrecacheResource("model", "models/pets/per_jopka/arsene.vmdl", context)
    PrecacheResource("model", "models/pets/per_jopka/attachments.vmdl", context)
    PrecacheResource("model", "models/heroes/invoker_kid/invoker_kid.vmdl", context)
    PrecacheResource("model", "models/heroes/dark_willow/dark_willow_wisp.vmdl", context)
	PrecacheResource("model", "models/pets/icewrack_wolf/icewrack_wolf.vmdl", context)
	PrecacheResource("model", "models/items/courier/onibi_lvl_21/onibi_lvl_21.vmdl", context)
	PrecacheResource("model", "models/heroes/invoker_kid/invoker_kid_cape.vmdl", context)
	PrecacheResource("model", "models/heroes/invoker_kid/invoker_kid_hair.vmdl", context)

    PrecacheResource("model", "models/heroes/storm_spirit/storm_spirit.vmdl", context)
    PrecacheResource("model", "models/heroes/storm_spirit/storm_hat.vmdl", context)
    PrecacheResource("model", "models/items/storm_spirit/tormenta_arms/tormenta_arms.vmdl", context)
    PrecacheResource("model", "models/items/storm_spirit/raikage_ares_armor/raikage_ares_armor.vmdl", context)

    PrecacheResource("model", "models/pets/nezuko_pet/nezuko.vmdl", context)
    PrecacheResource("model", "models/pets/nezuko_pet/hair.vmdl", context)

    PrecacheResource("particle", "particles/econ/courier/courier_trail_orbit/courier_trail_orbit.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/storm_spirit/storm_spirit_orchid_hat/storm_spirit_orchid_hat_ribbon.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/storm_spirit/storm_spirit_tormenta_armor/storm_spirit_tormenta_ambient.vpcf", context)

    PrecacheResource("particle", "particles/yellow_water_effect/yellow_water.vpcf", context)
    PrecacheResource("particle", "particles/platinum_emblem/platinum_emblem.vpcf", context)
    PrecacheResource("particle", "particles/econ/pets/pet_drodo_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_onibi/courier_onibi_black_lvl21_ambient.vpcf", context)
    PrecacheResource("particle", "particles/star_emblem/star_emblem_hero_effect.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/ti9/ti9_emblem_effect.vpcf", context)
    
	PrecacheResource("particle", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context)
	PrecacheResource("particle", "particles/rain_fx/econ_weather_underwater.vpcf", context)
	PrecacheResource("particle", "particles/rain_fx/econ_snow.vpcf", context)
	PrecacheResource("particle", "particles/econ/pets/otto_ambient.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_drow/drow_base_attack.vpcf", context)
    PrecacheResource("particle", "particles/red_emblem/red_emblem.vpcf", context)
    PrecacheResource("particle", "particles/red_wateryellow_water_effect/red_water.vpcf", context)
    PrecacheResource("particle", "particles/hero_effects/green_hero_effect_ground.vpcf", context)
    PrecacheResource("particle", "particles/star_emblem_3/star_emblem_3_effect.vpcf", context)

	PrecacheResource("soundfile", "soundevents/custom_sounds.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/hero_zoom.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/hero_manhattan.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/soundevents_conquest.vsndevts", context )
	PrecacheResource("soundfile", "soundevents/event_lich_king.vsndevts", context )
	PrecacheResource("particle", "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf", context )
	PrecacheResource("particle", "particles/rain_fx/econ_weather_aurora.vpcf", context )
	PrecacheResource("particle", "particles/rain_fx/econ_weather_sirocco.vpcf", context )
	PrecacheResource("particle", "particles/rain_fx/econ_rain.vpcf", context )
	PrecacheResource("particle", "particles/rain_fx/econ_moonlight.vpcf", context )
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
	PrecacheResource("model", "models/pets/celty_pet/celty.vmdl", context)

	print("PRECASHE ENDED")
end

DOTA_DAMAGE_MULTIPLIER_MAGICAL_HEAL = 0.35
DOTA_DAMAGE_MULTIPLIER_MAGICAL_CRIT = 1.0
DOTA_DAMAGE_MULTIPLIER_MAGICAL_CRIT_CHANCE = 25
DOTA_GOLD_TICK_TIME = 1
DOTA_GOLD_PER_TICK = 8

function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end

function GameMode:InitGameMode()
    GameRules:SetTimeOfDay( 0.75 )
    GameRules:SetHeroRespawnEnabled( true )
    GameRules:SetUseUniversalShopMode( true )
    GameRules:SetHeroSelectionTime( 0.0 )
    GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 20 )

    Convars:SetBool( "dota_suggest_disable", true )

    if GetMapName() == "dota_captains_mode" then GameRules:SetPreGameTime( 700.0 ) else GameRules:SetPreGameTime( 120.0 ) end

    GameRules:SetPostGameTime( 60.0 )
    GameRules:SetTreeRegrowTime( 60.0 )
    GameRules:SetHeroMinimapIconScale( 0.7 )
    GameRules:SetCreepMinimapIconScale( 0.7 )
    GameRules:SetRuneMinimapIconScale( 0.7 )

    GameRules:SetGoldTickTime( 0 ) --- ЗАЕБАЛ ЖИРНЫЙ, СУКА, ПРИДЕТСЯ САМОМУ ДЕЛАТЬ ИЗ_ЗА ТЕБЯ!
    GameRules:SetGoldPerTick( 0 )

    GameRules:GetGameModeEntity():SetFixedRespawnTime(10)
    GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
    GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
    GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
    GameRules:SetUseBaseGoldBountyOnHeroes(false)

    GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_wisp" )

    if GetMapName() == "free_for_all" then
        tdm:start()
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
        17400, --- 19
        20600, --- 20
        22400, --- 21
        25600, --- 22
        28400, --- 23
        30400, --- 24
        35000, --- 25

        50000, --- 26
        55000, --- 27
        60000, --- 28
        80000, --- 29
        100000, --- 30

        ---50000, --- 31
        ---53000, --- 32
       --- 56000, --- 33
        ----59000, --- 34
       ---- 62000,]]--
    }

    GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)

    Convars:SetInt("dota_wait_for_players_to_load_timeout", 260)
    Convars:SetInt("dota_combine_models", 1 )
    SendToServerConsole( "dota_combine_models 1" )

    -- Hook into game events allowing reload of functions at run time
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( GameMode, "OnNPCSpawned" ), self )
    ListenToGameEvent( "player_reconnected", Dynamic_Wrap( GameMode, 'OnPlayerReconnected' ), self )
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, 'OnEntityKilled' ), self )
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, "OnGameRulesStateChange" ), self )
    ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( GameMode, "OnAbilityLearned" ), self )

    GameRules:GetGameModeEntity():SetThink( "OnIntervalThink", self, 10 )

    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap( GameMode, "DmgFilter" ), self)
    GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap( GameMode, "ModifierFilter" ), self)
    GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap( GameMode, "OrderFilter" ), self)
    GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "GoldFilter"), self)

    Util:OnInit()
    Trades:Init()
    Vote:OnInit()

    GameRules.Globals = {};
    GameRules.Players = {}
    GameRules.Players[DOTA_TEAM_BADGUYS] = {}
    GameRules.Players[DOTA_TEAM_GOODGUYS] = {}

    GameRules.Globals.Event = {}

    GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE , true ) --Double Damage
    GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_HASTE, true ) --Haste
    GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ILLUSION, false ) --Illusion
    GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_INVISIBILITY, true ) --Invis
    GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_REGENERATION, true ) --Regen
    GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ARCANE, true ) --Arcane
    GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_BOUNTY, true ) --Bounty
 
    Timers:CreateTimer(5, function() GameMode:GoldTickTimer() return DOTA_GOLD_TICK_TIME end)
end

function GameMode:GoldTickTimer()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        for i = 0, DOTA_MAX_PLAYERS - 1 do
            if PlayerResource:IsValidPlayerID(i) and PlayerResource:GetConnectionState(i) <= 2 then
                PlayerResource:ModifyGold(i, DOTA_GOLD_PER_TICK, true, DOTA_ModifyGold_Unspecified)
            end 
        end
    end 
end


function GameMode:GoldFilter(ftable)
	local reason = ftable.reason_const
	local pid = ftable.player_id_const
	local gold = ftable.gold

    if reason == DOTA_ModifyGold_AbandonedRedistribute or reason == DOTA_ModifyGold_GameTick then
        return false
    end

	return true
end


function GameMode:OnAllPlayersLoaded()
	if GetMapName() == "dota_captains_mode" then CaptainsMode:Start() else Pick:Start() end

	Util:Setup()
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
	stats.get_data()
	stats.get_all_inventories()
end

function GameMode:OnGameEnded(keys)
	if GameRules:IsCheatMode() == false and IsInToolsMode() == false then
		if PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) > 0 and PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS) > 0 then
			if GetMapName() ~= "free_for_all" then
				if GameRules:IsCheatMode() == false then
					stats.roll()
					stats.set_data()
				end
			end
		end
	end
end

function GameMode:OnGameInProgress()
	GameRules.Players[DOTA_TEAM_GOODGUYS] = Util:GetPlayersForTeam(DOTA_TEAM_GOODGUYS)
	GameRules.Players[DOTA_TEAM_BADGUYS] = Util:GetPlayersForTeam(DOTA_TEAM_BADGUYS)
end

function GameMode:OnIntervalThink()
	if #GameRules.Players[DOTA_TEAM_GOODGUYS] > 0 and #GameRules.Players[DOTA_TEAM_BADGUYS] > 0 then
		if GameRules:IsCheatMode() == false and IsInToolsMode() == false then
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS  then
				Util:CheckGameState()
			end
		end
    end
    
	return 10
end

function GameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc:HasAbility("creeps_gangsta_ability") then npc:FindAbilityByName("creeps_gangsta_ability"):SetLevel(1) end

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
end

function GameMode:DmgFilter(ftable)
    if pcall(function ()
        local attacker
        if ftable.entindex_attacker_const then attacker = EntIndexToHScript(ftable.entindex_attacker_const) end
        local victim = EntIndexToHScript(ftable.entindex_victim_const)
        local damage = ftable.damage
        if attacker ~= nil then
            if victim:Attribute_GetIntValue("bFollowPointAttack", 0) == 1 then
                victim:ModifyHealth(victim:GetHealth() - 1, nil, true, 0)

                ftable.damage = 0
                return false
            end
            if victim:HasModifier("modifier_franklin_global_retrocausality_friendly") and victim:HasModifier("modifier_thanos_decimation") == false then
                local modifier = victim:FindModifierByName("modifier_franklin_global_retrocausality_friendly")
                if modifier then
                    local target = EntIndexToHScript(modifier:GetTarget())
                    if target:IsAlive() and not attacker:IsAncient() then
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

    Util:OnDamageWasApplied(ftable)

    return true
end

function GameMode:GetCompositeDamage(damage, target)
    local magical_damage = damage/2
    local physical_damage = damage/2
    local armor = target:GetPhysicalArmorValue( false )
    local magical_armor = target:GetMagicalArmorValue()/100

    local mult = (1 - (0.06 * armor)) / (1 + (0.06 * armor))

    local phys_damage_comp = physical_damage*mult

    local mag_damage = magical_damage*(1 - magical_armor)

    return magical_damage + phys_damage_comp
end

function printd( msg )
	CustomGameEventManager:Send_ServerToAllClients("OnErrorOccupied", {data = msg})
end

function CDOTAGamerules:printd( msg, pID )
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "OnErrorOccupied", {data = msg})
end

function GameMode:ModifierFilter(params)
	local ability_entindex = params.entindex_ability_const
	local parent_entindex = params.entindex_parent_const
	local modifier = params.name_const
	local caster_entindex = params.entindex_caster_const or parent_entindex

	if ability_entindex and parent_entindex then
		Util:OnModifierWasApplied( EntIndexToHScript(ability_entindex), EntIndexToHScript(parent_entindex), EntIndexToHScript(caster_entindex), modifier)
	end

	if not ability_entindex and parent_entindex then
		Util:OnModifierWasApplied( nil, EntIndexToHScript(parent_entindex), EntIndexToHScript(caster_entindex), modifier)
	end

	return true
end

function GameMode:OnAbilityLearned(params)
	Util:LearnedAbility( params )
end

function GameMode:OrderFilter(params)
    local unit = EntIndexToHScript(params.units["0"])

    if unit:HasModifier("modifier_cosmos_space_warp") then
        if params.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or params.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
            local target = Vector(params.position_x, params.position_y, params.position_z)

            local movement = target - unit:GetAbsOrigin()
            local targetPos = unit:GetAbsOrigin() - movement


            params.position_x = targetPos.x
            params.position_y = targetPos.y
            params.position_z = targetPos.z
        end
        if params.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or params.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then
            local target = params.entindex_target

            local units = FindUnitsInRadius( unit:GetTeamNumber(), unit:GetOrigin(), unit, 99999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
            if #units > 0 then
                params.entindex_target = units[1]:entindex()
            end
        end
        if params.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
            local target = Vector(params.position_x, params.position_y, params.position_z)

            local movement = target - unit:GetAbsOrigin()
            local targetPos = unit:GetAbsOrigin() - movement


            params.position_x = targetPos.x
            params.position_y = targetPos.y
            params.position_z = targetPos.z
        end
    end

    if unit:HasModifier("cosmos_q_continuum_modifier") then
        if params.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or params.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
            local targetPos = vCenter + RandomVector(1) * RandomFloat(0, 10000)

            params.position_x = targetPos.x
            params.position_y = targetPos.y
            params.position_z = targetPos.z
        end
    end

    return true
end
