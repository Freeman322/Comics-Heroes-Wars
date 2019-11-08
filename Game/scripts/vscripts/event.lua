--Class definition
if Event == nil then
    Event = {}
    Event.__index = Event
end

Event.m_hWaypoints = {}
Event._vLootItemDropsList = {}

Event.m_hWaypoints["spawn_right"] = "path1"
Event.m_hWaypoints["spawn_left"] = "left1"

Event.m_hSpawnPoints = {}

Event.m_hUnits = {}
Event.m_bSpawning = false;

function Event:OnInit()
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( Event, "OnGameRulesStateChange" ), self )

    self.m_hUnits = LoadKeyValues("scripts/events/invasion.kv")
    self._vLootItemDropsList =  LoadKeyValues("scripts/events/event_current.kv")

    self.m_hSpawnPoints["spawn_right"] = Entities:FindByName(nil, "spawn_right")
    self.m_hSpawnPoints["spawn_left"] = Entities:FindByName(nil, "spawn_left")

    self.m_hWaypoints["spawn_right"] = Entities:FindByName(nil, "path1")
    self.m_hWaypoints["spawn_left"] = Entities:FindByName(nil, "left1")

    GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 )

    GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetHeroRespawnEnabled( false )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetHeroSelectionTime( 30.0 )
	GameRules:SetPreGameTime( 60.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetHeroMinimapIconScale( 0.7 )
	GameRules:SetCreepMinimapIconScale( 0.7 )
	GameRules:SetRuneMinimapIconScale( 0.7 )
	GameRules:SetGoldTickTime( 60.0 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
    GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )

    --[[Convars:RegisterCommand("test_drop", function()
        pcall(function() 
            stats.set_event_drop(363)
        end)
      end, "", 0)

    Convars:RegisterCommand("test_run_boss", function()
        pcall(function() 
            local res = "The Great Supreme Butcher is coming! Its too late for escape!"
            GameRules:SendCustomMessage(res, 0, 0)
    
            stats.set_event_drop(363)
    
            self.m_bSpawning = false
    
            self:ClearUnits()
            self:RunBoss()
        end)
    end, "", 0)]]--

    self._entAncient = Entities:FindByName( nil, "dota_goodguys_fort" )

    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 8 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
    
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( Event, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( Event, 'OnEntityKilled' ), self )
end

function Event:OnGameRulesStateChange(keys)
    local newState = GameRules:State_Get()

    if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:Start()
    elseif newState == DOTA_GAMERULES_STATE_POST_GAME then
       
    end
end

function Event:Start()
    EmitGlobalSound("pudge_pud_arc_ability_devour_14")

    self.m_bSpawning = true

    for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID(nPlayerID) and PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			PlayerResource:SetGold(nPlayerID, 15000, true)
		end
    end

    Timers:CreateTimer(5, function() self:CreateUnits() return 30 end)
end

function Event:ClearUnits()
    local creeps = FindUnitsInRadius( 3, Vector(0, 0, 0), nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    if #creeps > 0 then
        for _,creep in pairs(creeps) do
            creep:ForceKill(false)
        end
    end
end


function Event:CreateUnits()
    if self.m_bSpawning == true then
        for k,v in pairs(self.m_hUnits) do
            if RollPercentage(tonumber((v["chance"]))) and GameRules:GetGameTime() >= tonumber(v["min_time"]) then
                self:Spawn(k, tonumber(v["count"]))
            end
        end
    end 
end

function Event:GetSpawn()
    if RollPercentage(50) then
        return self.m_hSpawnPoints["spawn_right"]
    end 

    return self.m_hSpawnPoints["spawn_left"]
end


function Event:Spawn(unit, count)
    local entWp = self:GetSpawn()

    if entWp ~= nil then
        PrecacheUnitByNameAsync(unit, function()
            for i = 1,count do
                local creature = CreateUnitByName(unit, entWp:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
                creature:SetChampion( true )
        
                creature:SetInitialGoalEntity( self.m_hWaypoints[entWp:GetName()] )

                FindClearSpaceForUnit(creature, creature:GetAbsOrigin(), true)
            end
        end)
    end
end

function Event:RunBoss()
    local entWp = self:GetSpawn()

    PrecacheUnitByNameAsync("npc_dota_boss_supreme_butcher", function()
        local creature = CreateUnitByName("npc_dota_boss_supreme_butcher", entWp:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
        creature:SetChampion( true )

        creature:SetInitialGoalEntity( self.m_hWaypoints[entWp:GetName()] )

        FindClearSpaceForUnit(creature, creature:GetAbsOrigin(), true)
    end)
end


function Event:OnThink()
    self:_CheckForDefeat()
    
    if GameRules:GetGameTime() >= 900 and self.m_bSpawning == true then
        local res = "The Great Supreme Butcher is coming! Its too late for escape!"
        GameRules:SendCustomMessage(res, 0, 0)

        if not GameRules:IsCheatMode() then
            stats.set_event_drop(363)
        end

        self.m_bSpawning = false

        local heroes = HeroList:GetAllHeroes()

        for k,v in pairs(heroes) do
            v:RespawnHero(false, false)
        end

        self:ClearUnits()
        self:RunBoss()
    end 
	return 1
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

	if bAllPlayersDead or not self._entAncient or self._entAncient:GetHealth() <= 0 then
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
		return
	end
end


function Event:OnNPCSpawned( event )
    local spawnedUnit = EntIndexToHScript( event.entindex )
    
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
    end
    
    if spawnedUnit:IsRealHero() and not spawnedUnit:IsTempestDouble() and not spawnedUnit:HasModifier("modifier_kill") then
        for i=1, 35 do
            spawnedUnit:HeroLevelUp(true)
        end
    end 

	if spawnedUnit:IsCreature() then
		spawnedUnit:SetHPGain( spawnedUnit:GetMaxHealth() * 0.3 ) -- LEVEL SCALING VALUE FOR HP
		spawnedUnit:SetManaGain( 0 )
		spawnedUnit:SetHPRegenGain( 0 )
        spawnedUnit:SetManaRegenGain( 0 )
        
		if spawnedUnit:IsRangedAttacker() then
			spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.1 ) -- LEVEL SCALING VALUE FOR DPS
		else
			spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.2 ) -- LEVEL SCALING VALUE FOR DPS
        end
        
		spawnedUnit:SetArmorGain( 0 )
		spawnedUnit:SetMagicResistanceGain( 0 )
		spawnedUnit:SetDisableResistanceGain( 0 )
		spawnedUnit:SetAttackTimeGain( 0 )
		spawnedUnit:SetMoveSpeedGain( 0 )
		spawnedUnit:SetBountyGain( 0 )
		spawnedUnit:SetXPGain( 0 )
		spawnedUnit:CreatureLevelUp( math.floor( GameRules:GetGameTime() / 60 ) )
	end
end


function Event:OnEntityKilled( event )
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
        if killedUnit:IsCreature() then
            self:CheckForLootItemDrop(killedUnit)
        end 
        if killedUnit:GetUnitName() == "npc_dota_boss_supreme_butcher" then
            if not GameRules:IsCheatMode() then
                stats.set_event_drop(380)
            end
            GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
        end 
	end
end

function Event:CheckForLootItemDrop( killedUnit )
	if RollPercentage( 5 ) then
        local newItem = CreateItem( "item_bag_of_gold", nil, nil )
        newItem:SetPurchaseTime( 0 )
        if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
            item:SetStacksWithOtherOwners( true )
        end
        local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
        drop.IsLootDrop = true
    end
end