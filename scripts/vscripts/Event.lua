Event = class({})

DESCOVER_EXP = 100
KILLED_UNIT_EXP = 25
local BOOKS = 0

function Event:Start()
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( Event, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( Event, 'OnEntityKilled' ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( Event, "OnGameRulesStateChange" ), self )

	GameRules:GetGameModeEntity():SetThink("CheckEventState", Event, 1)

	LinkLuaModifier("modifier_escape","modifiers/modifier_escape.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_attack_range","modifiers/modifier_attack_range.lua", LUA_MODIFIER_MOTION_NONE)

	self._iTime = 0

	self.DropTable = LoadKeyValues("scripts/npc/drop.txt")

	CustomGameEventManager:RegisterListener("on_buy_hero", Dynamic_Wrap(Event, 'OnHeroSelected'))
	CustomGameEventManager:RegisterListener("on_buy_item", Dynamic_Wrap(Event, 'OnTryBuyItem'))
	CustomGameEventManager:RegisterListener("on_buy_game_item", Dynamic_Wrap(Event, 'OnBuyGameItem'))
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
		--[[for i=1, 35 do
			spawnedUnit:HeroLevelUp(false)
		end
		PlayerResource:ModifyGold(spawnedUnit:GetPlayerOwnerID(), 10000, true, DOTA_ModifyGold_Unspecified)]]--

		GameRules.Globals.Event[spawnedUnit:GetPlayerOwnerID()] = {}
	end
end

function Event:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end

	GameRules:SetTimeOfDay(0)

	if HeroList:GetHeroCount() == 0 then GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS) return end 

	if not GameRules:IsGamePaused() then
		self._iTime = self._iTime + 1
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
		Event:EndGame()
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
		return
	end	
end

function Event:OnEntityKilled( event )
	pcall(function () 
		local killedUnit = EntIndexToHScript( event.entindex_killed )
		if killedUnit then
			if killedUnit:IsRealHero() then
				GameRules:SetSafeToLeave(true)
				Event:SavePlayer(killedUnit:GetPlayerOwnerID(), 0)
			else
				if RollPercentage(15) then
					local newItem = CreateItem( "item_bag_of_gold", nil, nil )
					newItem:SetPurchaseTime( 0 )
					local goldToDrop = 100
					newItem:SetCurrentCharges( goldToDrop )
					local spawnPoint = killedUnit:GetAbsOrigin()
					local drop = CreateItemOnPositionSync( spawnPoint, newItem )
					newItem:LaunchLoot( true, 300, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 350 ) ) )
				end

				Event:OnDrop(killedUnit)

				if event.entindex_attacker then 
					local attacker = EntIndexToHScript(event.entindex_attacker) 
					if attacker:IsRealHero() then 
						GameRules.Globals.Event[attacker:GetPlayerOwnerID()]["exp"] = (GameRules.Globals.Event[attacker:GetPlayerOwnerID()]["exp"] or 0) + KILLED_UNIT_EXP
						Event:UpdateExp({exp = GameRules.Globals.Event[attacker:GetPlayerOwnerID()]["exp"]}, attacker:GetPlayerOwner())
						EmitAnnouncerSoundForPlayer("Event.ExpGained", player:GetPlayerID())
						ParticleManager:CreateParticle("particles/econ/events/ti7/hero_levelup_ti7_flash_hit_magic.vpcf", PATTACH_POINT_FOLLOW, attacker)
					end
				end
			end
		end
	end)	
end

function Event:OnDrop(unit)
	local DropInfo = self.DropTable[unit:GetUnitName()]
	if DropInfo then
		Event:OnBossKilled(unit:GetUnitName())	
        for item_name,chance in pairs(DropInfo) do
            if RollPercentage(chance) then
                local item = CreateItem(item_name, nil, nil)
                local pos = unit:GetAbsOrigin()
                local drop = CreateItemOnPositionSync( pos, item )
                local pos_launch = pos + RandomVector(RandomFloat(150,200))
                item:LaunchLoot(false, 200, 0.75, pos_launch)
            end
		end
    end
end

function Event:EndGame()

end

function Event:OnBuyGameItem(data)
	if GameRules.Globals.Event[data.PlayerID]["exp"] and GameRules.Globals.Event[data.PlayerID]["exp"] >= tonumber(data.price) then
		GameRules.Globals.Event[data.PlayerID]["exp"] = GameRules.Globals.Event[data.PlayerID]["exp"] - tonumber(data.price)

		local hero = PlayerResource:GetPlayer(data.PlayerID):GetAssignedHero()
		local item_ = CreateItem(data.item, hero, hero)
		hero:AddItem(item_)

		CustomNetTables:SetTableValue("event", "players", GameRules.Globals.Event)
		return 
	end
end

function Event:_Spawn()
	
end

function Event:_SpawnBoss()
	
end

function Event:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		---EmitAnnouncerSound("Event.Intro")
	elseif nNewState == DOTA_GAMERULES_STATE_POST_GAME then
	end
end

------------TRIGGERS--------------------
function OnCityDescovered( params )
	local area_id = 0

	Event:PlayerDescoveredArea({id = area_id, area = "City"}, params.activator:GetPlayerOwner())
end

function OnWharfDescovered( params )
	local area_id = 1

	Event:PlayerDescoveredArea({id = area_id, area = "Wharf"}, params.activator:GetPlayerOwner())
end

function OnLighthouseDescovered( params )
	local area_id = 2

	Event:PlayerDescoveredArea({id = area_id, area = "Lighthouse"}, params.activator:GetPlayerOwner())
end

function OnFarmDescovered( params )
	local area_id = 3

	Event:PlayerDescoveredArea({id = area_id, area = "Farm"}, params.activator:GetPlayerOwner())
end

function OnGraveDescovered( params )
	local area_id = 4

	Event:PlayerDescoveredArea({id = area_id, area = "Grave"}, params.activator:GetPlayerOwner())
end

function OnDivideDescovered( params )
	local area_id = 5

	Event:PlayerDescoveredArea({id = area_id, area = "Great Divide"}, params.activator:GetPlayerOwner())
end

function OnTempleDescovered( params )
	local area_id = 6

	Event:PlayerDescoveredArea({id = area_id, area = "Temple"}, params.activator:GetPlayerOwner())
end

function OnVoidDescovered( params )
	local area_id = 7

	Event:PlayerDescoveredArea({id = area_id, area = "Void"}, params.activator:GetPlayerOwner())
end

function OnArenaDescovered( params )
	local area_id = 8

	Event:PlayerDescoveredArea({id = area_id, area = "Arena"}, params.activator:GetPlayerOwner())
end

function OnMillDescovered( params )
	local area_id = 9

	Event:PlayerDescoveredArea({id = area_id, area = "Mill"}, params.activator:GetPlayerOwner())
end

function OnOgrDied( params )

end

function OnWraithKingKilled( params )

end

function OnPudgeDied( params )

end

function OnPhantomDied( params )

end

function OnUnderlordDied( params )

end


function OnTerrorbladeDied( params )

end


function OnVoidDied( params )

end


function OnWillowDied( params )

end


function OnSeaGhoulDied( params )

end


function OnReptileDied( params )
	if IsServer() then
		CustomGameEventManager:Send_ServerToAllClients("on_boss_killed", {name = "npc_dota_creature_boss_reptile"})

		for k,v in pairs(GameRules.Globals.Event) do
			v["exp"] = (v["exp"] or 0) + 10000		
		end

		CustomNetTables:SetTableValue("event", "players", GameRules.Globals.Event)
	end 
end


function OnShyDied( params )
	if IsServer() then
		CustomGameEventManager:Send_ServerToAllClients("on_boss_killed", {name = "npc_dota_creature_boss_shy_guy"})

		for k,v in pairs(GameRules.Globals.Event) do
			v["exp"] = (v["exp"] or 0) + 50000		
		end

		CustomNetTables:SetTableValue("event", "players", GameRules.Globals.Event)
	end 
end

------ESCAPE FUNCTIONS

function OnStartEscape( params )
	local player = params.activator:GetPlayerOwner()
	local hero = params.activator

	if not GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then return end

	if not hero:HasModifier("modifier_escape") then hero:AddNewModifier(hero, nil, "modifier_escape", {duration = 8}) end 
end

function OnEscapeEnd( params )
	local player = params.activator:GetPlayerOwner()
	local hero = params.activator

	if hero:HasModifier("modifier_escape") then hero:RemoveModifierByName("modifier_escape") end 
end


function Event:PlayerDescoveredArea( data, player )
	if IsServer() then 
		print(GameRules.Globals.Event[player:GetPlayerID()])
		if not GameRules.Globals.Event[player:GetPlayerID()][data.id] then 
			CustomGameEventManager:Send_ServerToPlayer(player, "on_area_discovered", data)

			GameRules.Globals.Event[player:GetPlayerID()][data.id] = true
			GameRules.Globals.Event[player:GetPlayerID()]["exp"] = (GameRules.Globals.Event[player:GetPlayerID()]["exp"] or 0) + DESCOVER_EXP

			Event:UpdateExp({exp = GameRules.Globals.Event[player:GetPlayerID()]["exp"]}, player)

			EmitAnnouncerSoundForPlayer("Event.AreaDiscovered", player:GetPlayerID())
		end
	end
end

function Event:OnPlayerEscaped( hero )
	Event:SavePlayer(hero:GetPlayerOwnerID(), 1)
	GameRules:SetSafeToLeave(true)

	UTIL_Remove(hero)
end

function Event:UpdateExp( data, player )
	CustomNetTables:SetTableValue("event", "players", GameRules.Globals.Event)
end

function Event:OnBossKilled(params)
	CustomGameEventManager:Send_ServerToAllClients("on_boss_killed", {name = params})

	for k,v in pairs(GameRules.Globals.Event) do
		print(k,v)
		v["exp"] = (v["exp"] or 0) + 1000		
	end

	CustomNetTables:SetTableValue("event", "players", GameRules.Globals.Event)
end

function Event:TryBuyHero(steam, id, hero, playerID)
	local data = {}
	data.type = 1
	data.data = {}
	data.data.steam_id = steam
	data.data.hero_id = id

	local connection = CreateHTTPRequestScriptVM('POST', "http://pggames.pw/games/chw/src/Event/Event.php")
	local encoded_data = json.encode(data)
	connection:SetHTTPRequestGetOrPostParameter('payload', encoded_data)
	connection:Send (function(result_keys)
		local result = tonumber(result_keys["Body"])
		if result == 1 then 
			if id == 1 then 
				hero:SetOriginalModel("models/creeps/omniknight_golem/omniknight_golem.vmdl")
				hero:ModifyStrength(hero:GetStrength() + 200)
				hero:SetBaseMoveSpeed(240)
				hero:SetPhysicalArmorBaseValue(20)

				hero:SetBaseHealthRegen(80)

				hero:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)
			elseif id == 2 then 
				hero:SetOriginalModel("models/creeps/thief/thief_01_archer.vmdl")
				hero:SetRangedProjectileName("particles/units/heroes/hero_drow/drow_base_attack.vpcf")
				hero:ModifyAgility(hero:GetAgility() + 190)
				hero:SetBaseMoveSpeed(340)
				hero:SetPhysicalArmorBaseValue(-20)
				hero:ModifyStrength(hero:GetStrength() - 10)

				hero:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

				hero:AddNewModifier(hero, nil, "modifier_attack_range", nil)
			elseif id == 3 then 
				hero:SetOriginalModel("models/npc/npc_dingus/dingus.vmdl")

				hero:ModifyStrength(hero:GetStrength() + 45)
				hero:ModifyAgility(hero:GetAgility() + 45)
				hero:ModifyIntellect(hero:GetIntellect() + 45)
				hero:SetBaseMoveSpeed(290)
				hero:SetPhysicalArmorBaseValue(10)

				hero:SetBaseDamageMin(100)
				hero:SetBaseDamageMax(100)

				hero:SetBaseHealthRegen(20)

				hero:SetBaseAttackTime(0.8)

				hero:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)
			end
			GameRules.Globals.Event[playerID]["hero"] = id
		end
		hero:AddNewModifier(hero, nil, "modifier_stunned", {duration = 0.4})
	end)
end

function Event:OnHeroSelected(data)
	local id = tonumber(data.hero_id)
	local playerID = data.PlayerID              
	local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()

	local steamID = PlayerResource:GetSteamAccountID(playerID)

	if GameRules.Globals.Event[playerID]["hero"] == nil then 
		Event:TryBuyHero(steamID, id, hero, playerID)
	end
end

function Event:AddBook()
	if IsServer() then 
		BOOKS = BOOKS + 1

		for k,v in pairs(GameRules.Globals.Event) do
			v["exp"] = (v["exp"] or 0) + 800		
		end

		CustomNetTables:SetTableValue("event", "players", GameRules.Globals.Event)

		if BOOKS == 8 then 
			CustomGameEventManager:Send_ServerToAllClients("on_books_combined", nil)

			for k,v in pairs(GameRules.Globals.Event) do
				print(k,v)
				v["exp"] = (v["exp"] or 0) + 10000		
			end

			CustomNetTables:SetTableValue("event", "players", GameRules.Globals.Event)
		end 
	end 
end

function Event:OnTryBuyItem( params )
	local data = {}
	data.type = 2
	data.data = {}
	data.data.steam_id = PlayerResource:GetSteamAccountID(params.PlayerID)
	data.data.item_id = params.item_id

	local connection = CreateHTTPRequestScriptVM('POST', "http://pggames.pw/games/chw/src/Event/Event.php")
	local encoded_data = json.encode(data)
	connection:SetHTTPRequestGetOrPostParameter('payload', encoded_data)
	connection:Send (function(result_keys) end)
end

function OnEnterBookTrigger( params )
	local player = params.activator:GetPlayerOwner()
	local hero = params.activator

	if IsServer() then 
		if hero:HasItemInInventory("item_book_of_knowledge") then hero:RemoveItem(hero:FindItemInInventory("item_book_of_knowledge")) Event:AddBook() end 
	end 
end

function Event:SavePlayer(playerID, isAlive)
	if GameRules:IsCheatMode() or IsInToolsMode() then return nil end 

	local totalGold = (PlayerResource:GetGoldSpentOnItems(playerID) or 1) / 2

	local data = {}
	data.type = 0
	data.data = {}
	data.data.steam_id = PlayerResource:GetSteamAccountID(playerID)
	data.data.exp = (GameRules.Globals.Event[playerID]["exp"] or 0) + math.floor( totalGold )
	data.data.alive = isAlive or 0
	data.data.hero = GameRules.Globals.Event[playerID]["hero"] or 0

	local connection = CreateHTTPRequestScriptVM('POST', "http://pggames.pw/games/chw/src/Event/Event.php")
	local encoded_data = json.encode(data)
	connection:SetHTTPRequestGetOrPostParameter('payload', encoded_data)
	connection:Send (function(result_keys) end)
end