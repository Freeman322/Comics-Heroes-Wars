Event = class({})

function Event:Start()
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( Event, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( Event, 'OnEntityKilled' ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( Event, "OnGameRulesStateChange" ), self )

	GameRules:GetGameModeEntity():SetThink("CheckEventState", Event, 1)

	LinkLuaModifier("modifier_escape","modifiers/modifier_escape.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_range","modifiers/modifier_attack_range.lua", LUA_MODIFIER_MOTION_NONE)
end

function Event:CheckEventState()	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		Event:_CheckForDefeat()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function Event:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end

	if spawnedUnit:IsRealHero() then 
		for i = 1, 35 do
			spawnedUnit:HeroLevelUp(false)
		end
		PlayerResource:ModifyGold(spawnedUnit:GetPlayerOwnerID(), 10000, true, DOTA_ModifyGold_Unspecified)
	end
end

function Event:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end

	local bAllPlayersDead = true
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if not PlayerResource:HasSelectedHero( nPlayerID ) then
				bAllPlayersDead = false
			else
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hero and hero:IsAlive() then
					bAllPlayersDead = false
				end
			end
		end
	end

	if bAllPlayersDead then
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
		return
	end
end


function Event:OnEntityKilled( event )
	pcall(function () 
		local killedUnit = EntIndexToHScript( event.entindex_killed )
		if killedUnit then
			if killedUnit:IsRealHero() then
				local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
				newItem:SetPurchaseTime( 0 )
				newItem:SetPurchaser( killedUnit )

				local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
				tombstone:SetContainedItem( newItem )
				tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )

				FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true )	
			end
			if killedUnit:GetUnitName() == "npc_dota_creature_boss_hulk" then 
				local mod = killedUnit:FindModifierByName("modifier_hulk")
				if mod then mod:ReincarnateTime() end 
			end  
		end
	end)	
end

function Event:EndGame()

end

function Event:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		Event:OnGameLoaded()
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	elseif nNewState == DOTA_GAMERULES_STATE_POST_GAME then
	end
end

function HulkDead( params )

end

function Event:OnGameLoaded()
	PrecacheUnitByNameAsync("npc_dota_creature_boss_hulk", function()
		local unit = CreateUnitByName( "npc_dota_creature_boss_hulk", Vector(-644, 546, 128), true, nil, nil, DOTA_TEAM_BADGUYS)
		
		SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_hulk/econs/head.vmdl"}):FollowEntity(unit, true)
		SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_hulk/econs/hammer.vmdl"}):FollowEntity(unit, true)
	end)
end 

