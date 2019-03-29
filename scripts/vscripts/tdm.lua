tdm = class({})

LinkLuaModifier("modifier_tdm", "modifiers/modifier_tdm.lua", LUA_MODIFIER_MOTION_NONE)

SCORE = {}
MAX_KILLS = 50
IS_GAME_ENDED = false

function tdm:start()
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( tdm, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( tdm, 'OnEntityKilled' ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( tdm, "OnGameRulesStateChange" ), self )
	
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
	GameRules:GetGameModeEntity():SetThink("CheckEventState", tdm, 1)

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

	SCORE[DOTA_TEAM_GOODGUYS] = 0
	SCORE[DOTA_TEAM_BADGUYS] = 0
	SCORE[DOTA_TEAM_CUSTOM_1] = 0
	SCORE[DOTA_TEAM_CUSTOM_2] = 0
	SCORE[DOTA_TEAM_CUSTOM_3] = 0
	SCORE[DOTA_TEAM_CUSTOM_4] = 0
	SCORE[DOTA_TEAM_CUSTOM_5] = 0
	SCORE[DOTA_TEAM_CUSTOM_6] = 0
	SCORE[DOTA_TEAM_CUSTOM_7] = 0
	SCORE[DOTA_TEAM_CUSTOM_8] = 0
end

function tdm:CheckEventState()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		tdm:_CheckForDefeat()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function tdm:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit:IsRealHero() then
		spawnedUnit:AddNewModifier(spawnedUnit, spawnedUnit:GetAbilityByIndex(0), "modifier_tdm", nil)
		return
	end
end

function tdm:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS or IS_GAME_ENDED then
		return
	end
end

function tdm:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local attacker = EntIndexToHScript( event.entindex_attacker )
	if killedUnit:IsRealHero() and attacker:IsRealHero() then
		SCORE[attacker:GetTeamNumber()] = SCORE[attacker:GetTeamNumber()] + 1
		if SCORE[attacker:GetTeamNumber()] >= MAX_KILLS then 
			CustomNetTables:SetTableValue("gamemode", "winner", {teamID = attacker:GetTeamNumber()})
			GameRules:SetGameWinner(SCORE[attacker:GetTeamNumber()])
		end
	end
		
end

function tdm:end_game()
end

function tdm:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		for _, player in pairs(HeroList:GetAllHeroes()) do 
			player:AddNewModifier(player, player:GetAbilityByIndex(0), "modifier_tdm", nil)
		end
	elseif nNewState == DOTA_GAMERULES_STATE_POST_GAME then
	end
end

