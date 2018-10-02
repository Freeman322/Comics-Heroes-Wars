FreeForAll = class({})

LinkLuaModifier("modifier_gold_overthrow", "modifiers/modifier_gold_overthrow.lua", LUA_MODIFIER_MOTION_NONE)

SCORE = {}
MAX_KILLS = 50
IS_GAME_ENDED = false

function FreeForAll:Start()
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( FreeForAll, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( FreeForAll, 'OnEntityKilled' ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( FreeForAll, "OnGameRulesStateChange" ), self )
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
	GameRules:GetGameModeEntity():SetThink("CheckEventState", FreeForAll, 1)

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

function FreeForAll:CheckEventState()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		FreeForAll:_CheckForDefeat()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function FreeForAll:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit:IsRealHero() then
		spawnedUnit:AddNewModifier(spawnedUnit, spawnedUnit:GetAbilityByIndex(0), "modifier_gold_overthrow", nil)
		return
	end
end

function FreeForAll:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS or IS_GAME_ENDED then
		return
	end
end

function FreeForAll:OnEntityKilled( event )
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

function FreeForAll:EndGame()
end

function FreeForAll:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		for _, player in pairs(HeroList:GetAllHeroes()) do 
			player:AddNewModifier(player, player:GetAbilityByIndex(0), "modifier_gold_overthrow", nil)
		end
	elseif nNewState == DOTA_GAMERULES_STATE_POST_GAME then
	end
end

