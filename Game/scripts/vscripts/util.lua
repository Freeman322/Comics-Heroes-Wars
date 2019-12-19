--Class definition
if Util == nil then
  Util = {}
  Util.__index = Util
end

Util.abilities = nil
__wearables = nil
Util.econs = nil
Util.heroes_ids = nil

EF_GLOBAL = 99999

function Util:OnInit(args)
    CustomNetTables:SetTableValue( "heroes", "heroes", Util:GetHeroList())

    PlayerTables:CreateTable("heroes_abilities", {abilities = Util:GetHeroAbilityList()}, true)

    local f = "[{\n\"name\":\"npc_dota_hero_antimage\",\n\"id\":1\n},\n{\n\"name\":\"npc_dota_hero_axe\",\n\"id\":2\n},\n{\n\"name\":\"npc_dota_hero_bane\",\n\"id\":3\n},\n{\n\"name\":\"npc_dota_hero_bloodseeker\",\n\"id\":4\n},\n{\n\"name\":\"npc_dota_hero_crystal_maiden\",\n\"id\":5\n},\n{\n\"name\":\"npc_dota_hero_drow_ranger\",\n\"id\":6\n},\n{\n\"name\":\"npc_dota_hero_earthshaker\",\n\"id\":7\n},\n{\n\"name\":\"npc_dota_hero_juggernaut\",\n\"id\":8\n},\n{\n\"name\":\"npc_dota_hero_mirana\",\n\"id\":9\n},\n{\n\"name\":\"npc_dota_hero_nevermore\",\n\"id\":11\n},\n{\n\"name\":\"npc_dota_hero_carnange\",\n\"id\":10\n},\n{\n\"name\":\"npc_dota_hero_phantom_lancer\",\n\"id\":12\n},\n{\n\"name\":\"npc_dota_hero_puck\",\n\"id\":13\n},\n{\n\"name\":\"npc_dota_hero_pudge\",\n\"id\":14\n},\n{\n\"name\":\"npc_dota_hero_razor\",\n\"id\":15\n},\n{\n\"name\":\"npc_dota_hero_sand_king\",\n\"id\":16\n},\n{\n\"name\":\"npc_dota_hero_storm_spirit\",\n\"id\":17\n},\n{\n\"name\":\"npc_dota_hero_sven\",\n\"id\":18\n},\n{\n\"name\":\"npc_dota_hero_tiny\",\n\"id\":19\n},\n{\n\"name\":\"npc_dota_hero_vengefulspirit\",\n\"id\":20\n},\n{\n\"name\":\"npc_dota_hero_windrunner\",\n\"id\":21\n},\n{\n\"name\":\"npc_dota_hero_zuus\",\n\"id\":22\n},\n{\n\"name\":\"npc_dota_hero_kunkka\",\n\"id\":23\n},\n{\n\"name\":\"npc_dota_hero_lina\",\n\"id\":25\n},\n{\n\"name\":\"npc_dota_hero_lich\",\n\"id\":31\n},\n{\n\"name\":\"npc_dota_hero_lion\",\n\"id\":26\n},\n{\n\"name\":\"npc_dota_hero_shadow_shaman\",\n\"id\":27\n},\n{\n\"name\":\"npc_dota_hero_slardar\",\n\"id\":28\n},\n{\n\"name\":\"npc_dota_hero_tidehunter\",\n\"id\":29\n},\n{\n\"name\":\"npc_dota_hero_witch_doctor\",\n\"id\":30\n},\n{\n\"name\":\"npc_dota_hero_riki\",\n\"id\":32\n},\n{\n\"name\":\"npc_dota_hero_enigma\",\n\"id\":33\n},\n{\n\"name\":\"npc_dota_hero_tinker\",\n\"id\":34\n},\n{\n\"name\":\"npc_dota_hero_sniper\",\n\"id\":35\n},\n{\n\"name\":\"npc_dota_hero_necrolyte\",\n\"id\":36\n},\n{\n\"name\":\"npc_dota_hero_warlock\",\n\"id\":37\n},\n{\n\"name\":\"npc_dota_hero_beastmaster\",\n\"id\":38\n},\n{\n\"name\":\"npc_dota_hero_queenofpain\",\n\"id\":39\n},\n{\n\"name\":\"npc_dota_hero_venomancer\",\n\"id\":40\n},\n{\n\"name\":\"npc_dota_hero_faceless_void\",\n\"id\":41\n},\n{\n\"name\":\"npc_dota_hero_skeleton_king\",\n\"id\":42\n},\n{\n\"name\":\"npc_dota_hero_death_prophet\",\n\"id\":43\n},\n{\n\"name\":\"npc_dota_hero_phantom_assassin\",\n\"id\":44\n},\n{\n\"name\":\"npc_dota_hero_pugna\",\n\"id\":45\n},\n{\n\"name\":\"npc_dota_hero_templar_assassin\",\n\"id\":46\n},\n{\n\"name\":\"npc_dota_hero_viper\",\n\"id\":47\n},\n{\n\"name\":\"npc_dota_hero_luna\",\n\"id\":48\n},\n{\n\"name\":\"npc_dota_hero_dragon_knight\",\n\"id\":49\n},\n{\n\"name\":\"npc_dota_hero_dazzle\",\n\"id\":50\n},\n{\n\"name\":\"npc_dota_hero_rattletrap\",\n\"id\":51\n},\n{\n\"name\":\"npc_dota_hero_leshrac\",\n\"id\":52\n},\n{\n\"name\":\"npc_dota_hero_furion\",\n\"id\":53\n},\n{\n\"name\":\"npc_dota_hero_life_stealer\",\n\"id\":54\n},\n{\n\"name\":\"npc_dota_hero_dark_seer\",\n\"id\":55\n},\n{\n\"name\":\"npc_dota_hero_clinkz\",\n\"id\":56\n},\n{\n\"name\":\"npc_dota_hero_omniknight\",\n\"id\":57\n},\n{\n\"name\":\"npc_dota_hero_enchantress\",\n\"id\":58\n},\n{\n\"name\":\"npc_dota_hero_huskar\",\n\"id\":59\n},\n{\n\"name\":\"npc_dota_hero_night_stalker\",\n\"id\":60\n},\n{\n\"name\":\"npc_dota_hero_broodmother\",\n\"id\":61\n},\n{\n\"name\":\"npc_dota_hero_bounty_hunter\",\n\"id\":62\n},\n{\n\"name\":\"npc_dota_hero_weaver\",\n\"id\":63\n},\n{\n\"name\":\"npc_dota_hero_jakiro\",\n\"id\":64\n},\n{\n\"name\":\"npc_dota_hero_batrider\",\n\"id\":65\n},\n{\n\"name\":\"npc_dota_hero_chen\",\n\"id\":66\n},\n{\n\"name\":\"npc_dota_hero_spectre\",\n\"id\":67\n},\n{\n\"name\":\"npc_dota_hero_doom_bringer\",\n\"id\":69\n},\n{\n\"name\":\"npc_dota_hero_ancient_apparition\",\n\"id\":68\n},\n{\n\"name\":\"npc_dota_hero_ursa\",\n\"id\":70\n},\n{\n\"name\":\"npc_dota_hero_spirit_breaker\",\n\"id\":71\n},\n{\n\"name\":\"npc_dota_hero_gyrocopter\",\n\"id\":72\n},\n{\n\"name\":\"npc_dota_hero_alchemist\",\n\"id\":73\n},\n{\n\"name\":\"npc_dota_hero_invoker\",\n\"id\":74\n},\n{\n\"name\":\"npc_dota_hero_silencer\",\n\"id\":75\n},\n{\n\"name\":\"npc_dota_hero_obsidian_destroyer\",\n\"id\":76\n},\n{\n\"name\":\"npc_dota_hero_lycan\",\n\"id\":77\n},\n{\n\"name\":\"npc_dota_hero_brewmaster\",\n\"id\":78\n},\n{\n\"name\":\"npc_dota_hero_shadow_demon\",\n\"id\":79\n},\n{\n\"name\":\"npc_dota_hero_lone_druid\",\n\"id\":80\n},\n{\n\"name\":\"npc_dota_hero_chaos_knight\",\n\"id\":81\n},\n{\n\"name\":\"npc_dota_hero_meepo\",\n\"id\":82\n},\n{\n\"name\":\"npc_dota_hero_treant\",\n\"id\":83\n},\n{\n\"name\":\"npc_dota_hero_ogre_magi\",\n\"id\":84\n},\n{\n\"name\":\"npc_dota_hero_undying\",\n\"id\":85\n},\n{\n\"name\":\"npc_dota_hero_rubick\",\n\"id\":86\n},\n{\n\"name\":\"npc_dota_hero_disruptor\",\n\"id\":87\n},\n{\n\"name\":\"npc_dota_hero_nyx_assassin\",\n\"id\":88\n},\n{\n\"name\":\"npc_dota_hero_naga_siren\",\n\"id\":89\n},\n{\n\"name\":\"npc_dota_hero_keeper_of_the_light\",\n\"id\":90\n},\n{\n\"name\":\"npc_dota_hero_wisp\",\n\"id\":91\n},\n{\n\"name\":\"npc_dota_hero_visage\",\n\"id\":92\n},\n{\n\"name\":\"npc_dota_hero_slark\",\n\"id\":93\n},\n{\n\"name\":\"npc_dota_hero_medusa\",\n\"id\":94\n},\n{\n\"name\":\"npc_dota_hero_troll_warlord\",\n\"id\":95\n},\n{\n\"name\":\"npc_dota_hero_centaur\",\n\"id\":96\n},\n{\n\"name\":\"npc_dota_hero_magnataur\",\n\"id\":97\n},\n{\n\"name\":\"npc_dota_hero_shredder\",\n\"id\":98\n},\n{\n\"name\":\"npc_dota_hero_bristleback\",\n\"id\":99\n},\n{\n\"name\":\"npc_dota_hero_tusk\",\n\"id\":100\n},\n{\n\"name\":\"npc_dota_hero_skywrath_mage\",\n\"id\":101\n},\n{\n\"name\":\"npc_dota_hero_abaddon\",\n\"id\":102\n},\n{\n\"name\":\"npc_dota_hero_elder_titan\",\n\"id\":103\n},\n{\n\"name\":\"npc_dota_hero_legion_commander\",\n\"id\":104\n},\n{\n\"name\":\"npc_dota_hero_ember_spirit\",\n\"id\":106\n},\n{\n\"name\":\"npc_dota_hero_earth_spirit\",\n\"id\":107\n},\n{\n\"name\":\"npc_dota_hero_abyssal_underlord\",\n\"id\":108\n},\n{\n\"name\":\"npc_dota_hero_terrorblade\",\n\"id\":109\n},\n{\n\"name\":\"npc_dota_hero_phoenix\",\n\"id\":110\n},\n{\n\"name\":\"npc_dota_hero_techies\",\n\"id\":105\n},\n{\n\"name\":\"npc_dota_hero_oracle\",\n\"id\":111\n},\n{\n\"name\":\"npc_dota_hero_winter_wyvern\",\n\"id\":112\n},\n{\n\"name\":\"npc_dota_hero_arc_warden\",\n\"id\":113\n},\n{\n\"name\":\"npc_dota_hero_monkey_king\",\n\"id\":114\n},\n{\n\"name\":\"npc_dota_hero_pangolier\",\n\"id\":120\n},\n{\n\"name\":\"npc_dota_hero_dark_willow\",\n\"id\":119\n},\n{\n\"name\":\"npc_dota_hero_grimstroke\",\n\"id\":121\n},\n{\n\"name\":\"npc_dota_hero_miraak\",\n\"id\":200\n},\n{\n\"name\":\"npc_dota_hero_godspeed\",\n\"id\":202\n},\n{\n\"name\":\"npc_dota_hero_savitar\",\n\"id\":203\n},\n{\n\"name\":\"npc_dota_hero_ghost\",\n\"id\":201\n},\n{\n\"name\":\"npc_dota_hero_superman\",\n\"id\":204\n},\n{\n\"name\":\"npc_dota_hero_molag_bal\",\n\"id\":205\n},\n{\n\"name\":\"npc_dota_hero_doctor_fate\",\n\"id\":206\n},\n{\n\"name\":\"npc_dota_hero_mercer\",\n\"id\":207\n},\n{\n\"name\":\"npc_dota_hero_ezekyle\",\n\"id\":208\n},\n{\n\"name\":\"npc_dota_hero_kyloren\",\n\"id\":209\n},\n{\n\"name\":\"npc_dota_hero_mercy\",\n\"id\":210\n},\n{\n\"name\":\"npc_dota_hero_dark_rider\",\n\"id\":211\n},\n{\n\"name\":\"npc_dota_hero_grimskull\",\n\"id\":212\n},\n{\n\"name\":\"npc_dota_hero_kratos\",\n\"id\":213\n},\n{\n\"name\":\"npc_dota_hero_warboss\",\n\"id\":214\n},\n{\n\"name\":\"npc_dota_hero_cosmos\",\n\"id\":215\n},\n{\n\"name\":\"npc_dota_hero_jetstream_sam\",\n\"id\":216\n},\n{\n\"name\":\"npc_dota_hero_raiden\",\n\"id\":217\n},\n{\n\"name\":\"npc_dota_hero_misterio\",\n\"id\":218\n},\n{\n\"name\":\"npc_dota_hero_shazam\",\n\"id\":219\n},\n{\n\"name\":\"npc_dota_hero_ogre\",\n\"id\":220\n},\n{\n\"name\":\"npc_dota_hero_baane\",\n\"id\":221\n},\n{\n\"name\":\"npc_dota_hero_officer\",\n\"id\":222\n},\n{\n\"name\":\"npc_dota_hero_mod\",\n\"id\":223\n},\n{\n\"name\":\"npc_dota_hero_valkorion\",\n\"id\":224\n},\n{\n\"name\":\"npc_dota_hero_pennywise\",\n\"id\":227\n},\n{\n\"name\":\"npc_dota_hero_chaos_king\",\n\"id\":230\n}\n]\n"
    local tojson = json.decode(f)
    Util.heroes_ids = tojson

    CustomGameEventManager:RegisterListener("debug_console_input", Dynamic_Wrap(Util, 'OnDebugConsoleInput'))
    CustomGameEventManager:RegisterListener("on_item_deleted", Dynamic_Wrap(Util, 'DeleteEconItem'))
    CustomGameEventManager:RegisterListener("set_compendium_user", Dynamic_Wrap(Util, 'OnCompendiumLoaded'))
    CustomGameEventManager:RegisterListener("quest_selected", Dynamic_Wrap(Util, 'OnQuestSelected'))
    CustomGameEventManager:RegisterListener("quest_ended", Dynamic_Wrap(Util, 'OnQuestEnded'))
    CustomGameEventManager:RegisterListener("on_cosmetic_item_changed", Dynamic_Wrap(Util, 'OnCosmeticItemUpdated'))

	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( Util, "OnItemPickUp"), self )

    Convars:RegisterCommand( "try_get_data", Dynamic_Wrap(Util, 'GetNetworkStatsData'), "Test", FCVAR_CHEAT )
    Convars:RegisterCommand( "try_set_data", Dynamic_Wrap(Util, 'SetNetworkStatsData'), "Test", FCVAR_CHEAT )

    local qualities = LoadKeyValues('scripts/items/qualities.kv')
    local rarities = LoadKeyValues('scripts/items/rarities.kv')
    local econ = LoadKeyValues('scripts/items/items.kv')

    Util.econs = LoadKeyValues('scripts/items/items.kv')
    Util.abilities = LoadKeyValues('scripts/npc/npc_abilities_custom.txt')
    Util.items = LoadKeyValues('scripts/npc/npc_items_custom.txt')
    __wearables = LoadKeyValues('scripts/items/wearables.kv')

    CustomNetTables:SetTableValue( "globals", "rarities", rarities )
    CustomNetTables:SetTableValue( "globals", "qualities", qualities )
    PlayerTables:CreateTable("globals", {econs = econ}, true)
    PlayerTables:CreateTable("heroes_data", {heroes = {}}, true)

    LinkLuaModifier("modifier_arcana", "modifiers/modifier_arcana.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_pet_model", "modifiers/modifier_pet_model.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_fountain", "modifiers/modifier_fountain.lua", LUA_MODIFIER_MOTION_NONE)

    CustomGameEventManager:RegisterListener("on_chat_recived", Dynamic_Wrap(Util, 'OnChatUpdated'))
    CustomGameEventManager:RegisterListener("on_gauntlet_ability_selected", Dynamic_Wrap(Util, 'OnGauntletAbilitySelected'))

    Util:SetupConsole()
end

function Util:OnChatUpdated( data )
  CustomGameEventManager:Send_ServerToAllClients("on_chat_new_mess", data)
end

function Util:GetNetworkStatsData()
	stats.get_data()
end

function Util:SetNetworkStatsData()
	stats.set_data()
end

function Util:DeleteEconItem(data)
  stats.delete_item(data)
end

function Util:GetHeroID( hero_name )
    if Util.heroes_ids then
        for k, hero in pairs(Util.heroes_ids) do
            if hero["name"] == hero_name then return tonumber(hero["id"]) end
        end
    end
    return nil
end

function Util:OnItemPickUp( event )
    pcall(function()
        local item = EntIndexToHScript( event.ItemEntityIndex )
        local owner = EntIndexToHScript( event.HeroEntityIndex )
        r = RandomInt(200, 400)
        if event.itemname == "item_bag_of_gold" then
            PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
            SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
            UTIL_Remove( item )
        end
    end)
end

function Util:GetAbilityBehavior(name)
    local path = LoadKeyValues('scripts/npc/npc_abilities_custom.txt')
    if path[name] then
        if path[name]["AbilityBehavior"] then
            return path[name]["AbilityBehavior"]
        end
    end
end

function Util:GetAllHeroesCMMode()
    local heroes = {}
    local path = LoadKeyValues('scripts/npc/npc_heroes_custom.txt')

    for k,v in pairs(path) do
        local hero = v["override_hero"] or k
        if hero then
            if v["CMDisabled"] == nil and v["HeroDisabled"] == nil then
                table.insert( heroes, hero )
            end
        end
    end

    return heroes
end

function Util:GetAllHeroesCMModeDisabled()
    local heroes = {}
    local path = LoadKeyValues('scripts/npc/npc_heroes_custom.txt')

    for k,v in pairs(path) do
        local hero = v["override_hero"] or k
        if hero then
            if v["CMDisabled"] or v["HeroDisabled"] then
                table.insert( heroes, hero )
            end
        end
    end

    return heroes
end

function Util:GetHeroList()
    local path = LoadKeyValues('scripts/npc/npc_heroes_custom.txt')
    local heroes = CustomNetTables:GetTableValue("players", "heroes")

    local result = {}

    for k,v in pairs(path) do
        local hero = v["override_hero"] or k
        if hero and v["HeroDisabled"] == nil then
            result[hero] = v["AttributePrimary"]
        end
    end

    return result
end

function Util:GetHeroAbilityList()
    local Abilities = {}

    local path = LoadKeyValues('scripts/npc/npc_heroes_custom.txt')
    local herolist = LoadKeyValues('scripts/npc/herolist.txt')

    for k,v in pairs(path) do
        local hero = v["override_hero"] or k
        Abilities[hero] = {v["Ability1"], v["Ability2"], v["Ability3"], v["Ability4"], v["Ability5"], v["Ability6"]}
    end

    return Abilities
end

function Util:GetItemID(string)
    local id = -1
    local array = {}
    local econs = PlayerTables:GetTableValue("globals", "econs")
    for _, item in pairs(econs) do
        if item['item'] == string then
            table.insert(array, tostring(item['def_id']))
        end
    end
    return array
end

function Util:PlayerEquipedItem(pID, string)
    local steam_id = PlayerResource:GetSteamAccountID(pID)
    steam_id = tostring(steam_id)
    local items = Util:GetItemID(string)
    if GameRules.Globals.Inventories then
        if GameRules.Globals.Inventories[steam_id] then
            local array = GameRules.Globals.Inventories[steam_id]
            for _, item in pairs(array) do
                for _, def_id in pairs(items) do
                    if item['steam_id'] == tostring(steam_id) and item['def_id'] == def_id and item['state'] == "1" then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function Util:PlayerHasItem(pID, string)
    local steam_id = PlayerResource:GetSteamAccountID(pID)
    steam_id = tostring(steam_id)
    if GameRules.Globals.Inventories then
        if GameRules.Globals.Inventories[steam_id] then
            local array = GameRules.Globals.Inventories[steam_id]
            for _, item in pairs(array) do
                if item['steam_id'] == tostring(steam_id) and item['def_id'] == tostring(Util:GetItemID(string)) then
                    return true
                end
            end
        end
    end
    return false
end


function Util:GetItemForHero(def_id)
    for k, v in pairs(Util.econs) do
        if(tostring(v["def_id"])) == tostring(def_id) then
            return v["hero"]
        end
    end

    return nil
end

function Util:GetItemName(def_id)
    for k, v in pairs(Util.econs) do
        if(tostring(v["def_id"])) == tostring(def_id) then
            return v["item"]
        end
    end

    return nil
end

function Util:PlayerHasAdminRules(pID)
    local data = CustomNetTables:GetTableValue("players", "stats")
    if data and data[tostring(pID)] then
        return data[tostring(pID)].status == "2"
    end

    return false
end

function Util:UpdateWearables(hero, playerID)
    local items = {}
    local name = hero:GetUnitName()
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    if GameRules.Globals.Inventories then
        if GameRules.Globals.Inventories[tostring(steam_id)] then
            for id, _econ in pairs(GameRules.Globals.Inventories[tostring(steam_id)]) do
                if _econ["state"] == "1" and Util:GetItemForHero(_econ["def_id"]) == name then
                    local econ_name = Util:GetItemName(_econ["def_id"])
                    table.insert( items, econ_name )
                end
            end
        end
    end
    Util:_EquipItem(hero, items)
end


function Util:_EquipItem(hero, items)
    if __wearables == nil then __wearables = LoadKeyValues("scripts/items/wearables.kv") end

    local used_slots = {}
    hero.wearables = {}
    hero.modifiers = {}
    hero.particles = {}
    local hero_slots = __wearables[hero:GetUnitName()]
    if hero_slots then
        for _slot, slot in pairs(hero_slots) do
            used_slots[_slot] = false
            for __index, user_item in pairs(items) do
                if slot[user_item] ~= nil then
                    Util:EquipItemData(hero, slot[user_item], _slot)
                    used_slots[_slot] = true
                    break
                end
            end
        end
        for _i, _bool in pairs(used_slots) do
            if not _bool then
                if hero_slots[_i]["__default"] then
                    Util:EquipItemData(hero, hero_slots[_i]["__default"], _i)
                end
            end
        end
        if not items then
            for _slot, slot in pairs(hero_slots) do
                if slot["__default"] then
                    Util:EquipItemData(hero, slot["__default"], _slot)
                end
            end
        end
    end
end

function Util:ParseRenderColor( color, hero )
    if color == "black" then hero:SetRenderColor(0, 0, 0) end
    if color == "gold" then hero:SetRenderColor(255, 215, 0) end
end

function Util:EquipItemData(hero, item_data, slot)
    local econ_params = item_data
    if econ_params["model"] then
        hero:SetOriginalModel(econ_params["model"])
    end
    if econ_params["model_scale"] then
        hero:SetModelScale(tonumber(econ_params["model_scale"]))
    end
    if econ_params["models"] ~= nil then
        for _, model in pairs(econ_params["models"]) do
            local _econ = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model["model"]})
            _econ:FollowEntity(hero, true)
            hero.wearables[slot] = _econ
            if model["material"] then
                _econ:SetMaterialGroup(tostring(model["material"]))
            end
            if model["model_scale"] then
                _econ:SetModelScale(tonumber(model["model_scale"]))
            end
            if model["particles"] ~= nil then
                for __index, particle in pairs(model["particles"]) do
                    local _particle = ParticleManager:CreateParticle( particle["particle"], PATTACH_ABSORIGIN_FOLLOW, _econ )
                    table.insert( hero.particles , _particle )
                    if particle["ControlPoints"] ~= nil then
                        for _point, point_params in pairs(particle["ControlPoints"]) do
                            ParticleManager:SetParticleControlEnt( _particle, tonumber(_point), _econ, PATTACH_POINT_FOLLOW, point_params, _econ:GetOrigin(), true )
                        end
                    end
                end
            end
        end
    end

    if econ_params["render"] then Util:ParseRenderColor(econ_params["render"], hero) end

    if econ_params["projectile"] ~= nil then
        hero:SetRangedProjectileName(econ_params["projectile"]["particle"])
    end
    if econ_params["particles"] ~= nil then
        for __, particle in pairs(econ_params["particles"]) do
            local _particle = ParticleManager:CreateParticle( particle["particle"], PATTACH_ABSORIGIN_FOLLOW, hero )
            table.insert( hero.particles , _particle )
            if particle["ControlPoints"] ~= nil then
                for _point, point_params in pairs(particle["ControlPoints"]) do
                    ParticleManager:SetParticleControlEnt( _particle, tonumber(_point), hero, PATTACH_POINT_FOLLOW, point_params["attach_point"] , hero:GetOrigin(), true )
                end
            end
        end
    end
    if econ_params["modifiers"] ~= nil then
        for __id, modifier in pairs(econ_params["modifiers"]) do
            LinkLuaModifier(modifier["modifier"], modifier["modifier_path"], LUA_MODIFIER_MOTION_NONE)
            local mod = hero:AddNewModifier(hero, nil, modifier["modifier"], nil)
            hero.modifiers[slot] = mod
        end
    end
    if econ_params["material"] then
        hero:SetMaterialGroup(tostring(econ_params["material"]))
    end
    if econ_params["ambient"] then
        StartSoundEvent(econ_params["ambient"], hero)
    end
end

function Util:OnHeroInGame(hero)
    LinkLuaModifier("modifier_hero_selection", "modifiers/modifier_hero_selection.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_respawn_time", "modifiers/modifier_respawn_time.lua", LUA_MODIFIER_MOTION_NONE)

    if hero:GetUnitName() == "npc_dota_hero_wisp" then
      hero:SetModelScale(0.001)
      hero:AddNewModifier(hero, nil, "modifier_hero_selection", nil)
      hero:SetOriginalModel("models/development/invisiblebox.vmdl")

      hero:ModifyGold(-600, false, DOTA_ModifyGold_Unspecified)
      return nil
    end

    hero.attachments = {}

    if hero:GetPrimaryAttribute() == 2 and hero:GetUnitName() ~= "npc_dota_hero_silencer" then hero:AddNewModifier(hero, hero:GetAbilityByIndex(0), "modifier_silencer_int_steal", nil) end

    if not hero:HasModifier("modifier_kill") and not hero:IsIllusion() and not hero:IsTempestDouble() then
        hero:AddNewModifier(hero, hero:GetAbilityByIndex(0), "modifier_respawn_time", nil)
      
        --[[ParticleManager:CreateParticleForPlayer("particles/rain_fx/econ_moonlight.vpcf", PATTACH_EYES_FOLLOW, hero, hero:GetPlayerOwner())
        ParticleManager:CreateParticleForPlayer("particles/rain_fx/econ_rain.vpcf", PATTACH_EYES_FOLLOW, hero, hero:GetPlayerOwner())]]
      
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "drodo_duffin") == true then
            PrecacheUnitByNameAsync("npc_dota_companion", function()
                local unit = CreateUnitByName( "npc_dota_companion", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
                unit:SetOwner(hero)
                unit:SetControllableByPlayer(hero:GetPlayerID(), true)
                unit:AddNewModifier(hero, nil, "modifier_pet", {id = hero:GetPlayerID()})
                unit:AddNewModifier(hero, nil, "modifier_pet_model", {model = "models/pets/drodo/drodo.vmdl"})
            
                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/pets/pet_drodo_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
                ParticleManager:ReleaseParticleIndex(nFXIndex)
            end)
        end
      
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "star_emblem") == true then
            local nFXIndex = ParticleManager:CreateParticle( "particles/star_emblem/star_emblem_hero_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
            ParticleManager:ReleaseParticleIndex(nFXIndex)
        end

        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "star_emblem_green") == true then
            local nFXIndex = ParticleManager:CreateParticle( "particles/red_emblem/red_emblem.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
            ParticleManager:ReleaseParticleIndex(nFXIndex)
        end
      
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "icewrack_wolf") == true then
            PrecacheUnitByNameAsync("npc_dota_companion", function()
                local unit = CreateUnitByName( "npc_dota_companion", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
                unit:SetOwner(hero)
                unit:SetControllableByPlayer(hero:GetPlayerID(), true)
                unit:AddNewModifier(hero, nil, "modifier_pet", {id = hero:GetPlayerID()})
                unit:AddNewModifier(hero, nil, "modifier_pet_model", {model = "models/pets/icewrack_wolf/icewrack_wolf.vmdl"})
            
                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/puck/puck_snowflake/puck_snowflake_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
                ParticleManager:ReleaseParticleIndex(nFXIndex)
            end)
        end

        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "arsen") == true then
            PrecacheUnitByNameAsync("npc_dota_companion", function()
                local unit = CreateUnitByName( "npc_dota_companion", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
                unit:SetOwner(hero)
                unit:SetControllableByPlayer(hero:GetPlayerID(), true)
                unit:AddNewModifier(hero, nil, "modifier_pet", {id = hero:GetPlayerID()})
                unit:AddNewModifier(hero, nil, "modifier_pet_model", {model = "models/pets/per_jopka/arsene.vmdl"})
            
                SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/pets/per_jopka/attachments.vmdl"}):FollowEntity(unit, true)
            end)
        end

        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "kawaii") == true then
            PrecacheUnitByNameAsync("npc_dota_companion", function()
                local unit = CreateUnitByName( "npc_dota_companion", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
                unit:SetOwner(hero)
                unit:SetControllableByPlayer(hero:GetPlayerID(), true)
                unit:AddNewModifier(hero, nil, "modifier_pet", {id = hero:GetPlayerID()})
                unit:AddNewModifier(hero, nil, "modifier_pet_model", {model = "models/pets/kawaii_pet/kawaii.vmdl"})
            
                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_orbit/courier_trail_orbit.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
                ParticleManager:SetParticleControl( nFXIndex, 15, Vector(255, 105, 180) )
                ParticleManager:SetParticleControl( nFXIndex, 16, Vector(255, 105, 180) )
                ParticleManager:ReleaseParticleIndex(nFXIndex)

                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6_knockback_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
                ParticleManager:ReleaseParticleIndex(nFXIndex)
            end)
        end
      
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "otto_dragon") == true then
            PrecacheUnitByNameAsync("npc_dota_companion", function()
                local unit = CreateUnitByName( "npc_dota_companion", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
                unit:SetOwner(hero)
                unit:SetControllableByPlayer(hero:GetPlayerID(), true)
                unit:AddNewModifier(hero, nil, "modifier_pet", {id = hero:GetPlayerID()})
                unit:AddNewModifier(hero, nil, "modifier_pet_model", {model = "models/pets/osky/osky.vmdl"})
            
                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/pets/otto_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_eye_l", unit:GetOrigin(), true )
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
                ParticleManager:SetParticleControlEnt( nFXIndex, 2, unit, PATTACH_POINT_FOLLOW, "attach_eye_l", unit:GetOrigin(), true )
            
                ParticleManager:SetParticleControl( nFXIndex, 15, Vector(79, 216, 11) )
                ParticleManager:SetParticleControl( nFXIndex, 16, Vector(1, 0, 0) )
                ParticleManager:ReleaseParticleIndex(nFXIndex)
            end)
        end
      
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "argentum_swoedsmith") == true then
            PrecacheUnitByNameAsync("npc_dota_companion", function()
                local unit = CreateUnitByName( "npc_dota_companion", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
                unit:SetOwner(hero)
                unit:SetControllableByPlayer(hero:GetPlayerID(), true)
                unit:AddNewModifier(hero, nil, "modifier_pet", {id = hero:GetPlayerID()})
                unit:AddNewModifier(hero, nil, "modifier_pet_model", {model = "models/heroes/hero_elsa/elsa.vmdl"})
            end)
        end
      
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "celty") == true then
            PrecacheUnitByNameAsync("npc_dota_companion", function()
                local unit = CreateUnitByName( "npc_dota_companion", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
                unit:SetOwner(hero)
                unit:SetControllableByPlayer(hero:GetPlayerID(), true)
                unit:AddNewModifier(hero, nil, "modifier_pet", {id = hero:GetPlayerID()})
                unit:AddNewModifier(hero, nil, "modifier_pet_model", {model = "models/pets/celty_pet/celty.vmdl"})
            end)
        end
      
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "acolyte_of_lost_arts") == true then
            PrecacheUnitByNameAsync("npc_dota_companion", function()
                local unit = CreateUnitByName( "npc_dota_companion", hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
                unit:SetOwner(hero)
                unit:SetControllableByPlayer(hero:GetPlayerID(), true)
                unit:AddNewModifier(hero, nil, "modifier_pet", {id = hero:GetPlayerID()})
                unit:AddNewModifier(hero, nil, "modifier_pet_model", {model = "models/heroes/invoker_kid/invoker_kid.vmdl"})
            
                SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/invoker_kid/invoker_kid_cape.vmdl"}):FollowEntity(unit, true)
                SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/invoker_kid/invoker_kid_hair.vmdl"}):FollowEntity(unit, true)
            end)
        end
      end
      
    --[[local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
           
        end
        model = model:NextMovePeer()
    end--]]

    Util:UpdateWearables(hero, hero:GetPlayerOwnerID())

    ----if stats.has_plus(hero:GetPlayerOwnerID()) then stats.request_hero_data(hero:GetUnitName()) end

    if hero:GetUnitName() == "npc_dota_hero_pudge" then
      if hero:HasAbility("pudge_flesh_heap_lua") then
        hero:FindAbilityByName("pudge_flesh_heap_lua"):SetLevel(1)
      end
    end

    if hero:GetUnitName() == "npc_dota_hero_invoker" then
      if hero:HasAbility("collector_collect") then
        hero:FindAbilityByName("collector_collect"):SetLevel(1)
      end
    end

    if hero:GetUnitName() == "npc_dota_hero_ezekyle" then
      if hero:HasAbility("ezekyle_dark_gods_bless") then
        hero:FindAbilityByName("ezekyle_dark_gods_bless"):SetLevel(1)
      end
    end

    if hero:GetUnitName() == "npc_dota_hero_furion" then
      if hero:HasAbility("dimm_demons_power") then
        hero:FindAbilityByName("dimm_demons_power"):SetLevel(1)
      end
    end
    
    if hero:GetUnitName() == "npc_dota_hero_faceless_void" then
      if hero:HasAbility("beyonder_void_explosion") then
        hero:FindAbilityByName("beyonder_void_explosion"):SetLevel(1)
      end
    end

    if hero:GetUnitName() == "npc_dota_hero_pangolier" then
      Attachments:AttachProp(hero, "attach_attack2", "models/heroes/hero_celebrimbor/bow.vmdl", 1)
    end
    if hero:GetUnitName() == "npc_dota_hero_chaos_knight" then
      LinkLuaModifier("modifier_ghost_rider", "modifiers/modifier_ghost_rider.lua", LUA_MODIFIER_MOTION_NONE)

      hero:AddNewModifier(hero, nil, "modifier_ghost_rider", nil)
    end
    if hero:GetUnitName() == "npc_dota_hero_morphling" then
      ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
    end
    if hero:GetUnitName() == "npc_dota_hero_leshrac" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "tzeentch_chaos_crown") == true then
        local wraith_donat = ParticleManager:CreateParticle( "particles/hero_tzeench/tzeentch_chaos_crown.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( wraith_donat, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc" , hero:GetOrigin(), true )

        ParticleManager:DestroyParticle(pudge_donat, true)
        ParticleManager:DestroyParticle(pudge_donat2, true)

        local pudge_donat = ParticleManager:CreateParticle( "particles/econ/courier/courier_onibi/courier_onibi_black_ambient_eye_lvl21.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( pudge_donat, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )
        local pudge_donat2 = ParticleManager:CreateParticle( "particles/econ/courier/courier_onibi/courier_onibi_black_ambient_eye_lvl21.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( pudge_donat2, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )

        local wraith_donat2 = ParticleManager:CreateParticle( "particles/hero_tzeench/tzeentch_warp_connection_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( wraith_donat2, 0, hero, PATTACH_POINT_FOLLOW, "attach_effect" , hero:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( wraith_donat2, 1, hero, PATTACH_POINT_FOLLOW, "attach_effect" , hero:GetOrigin(), true )
        ParticleManager:SetParticleControl( wraith_donat2, 6, Vector(100, 100, 0) )
        Attachments:AttachProp(hero, "attach_crown", "models/heroes/hero_tzeentch/tzeench_chaos_god_arcana/chaos_god_crown.vmdl", 1)
      end
      hero:FindAbilityByName("tzeentch_warp_god"):SetLevel(1)
    end
    if hero:GetUnitName() == "npc_dota_hero_ogre" then
      hero:FindAbilityByName("ogre_mage_passive"):SetLevel(1)
    end
    if hero:GetUnitName() == "npc_dota_hero_cosmos" then
      hero:FindAbilityByName("cosmos_jumper"):SetLevel(1)
    end
    if hero:GetUnitName() == "npc_dota_hero_undying" then
        hero:FindAbilityByName("manhattan_equilibrium"):SetLevel(1)
    end
    if hero:GetUnitName() == "npc_dota_hero_jetstream_sam" then
      hero:FindAbilityByName("sam_zandatsu"):SetLevel(1)
    end
    if hero:GetUnitName() == "npc_dota_hero_enchantress" then
      hero:FindAbilityByName("tracer_pulse_bomb"):SetLevel(1)
    end
    if hero:GetUnitName() == "dota_fountain" then
      hero:FindAbilityByName("fountain_protection"):SetLevel(1)
    end
    if hero:GetUnitName() == "npc_dota_hero_drow_ranger" then
      Attachments:AttachProp(hero, "attach_attack1", "models/items/windrunner/rainmaker_bow/rainmaker_bow.vmdl", 1)
      if PlayerResource:GetSteamAccountID(hero:GetPlayerOwnerID()) == 77291876 then hero:SetMaterialGroup("blue") end
    end
    if hero:GetUnitName() == "npc_dota_hero_bristleback" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "whispers_of_the_dead") == true then
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/vengeful_ghost_captain_head/vengeful_ghost_captain_head.vmdl"})
        mask1:FollowEntity(hero, true)
      else
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_davy_jones/javy_jones_head.vmdl"})
        mask1:FollowEntity(hero, true)
        mask1:SetRenderColor(119, 136, 153)
      end

      local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/claddish_gloves/claddish_gloves.vmdl"})
      mask2:FollowEntity(hero, true)

      local mask3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/claddish_legs/claddish_legs.vmdl"})
      mask3:FollowEntity(hero, true)

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "neptunes_faith") == true then
        local mask4 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/kunkka_immortal/kunkka_shoulder_immortal.vmdl"})
        mask4:FollowEntity(hero, true)

        ParticleManager:CreateParticle( "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ambient_alt.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask4 )
      else
        local mask4 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/claddish_shoulder/claddish_shoulder.vmdl"})
        mask4:FollowEntity(hero, true)
      end


      local mask5 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/inquisitor_tide_belt/inquisitor_tide_belt.vmdl"})
      mask5:FollowEntity(hero, true)

      local mask6 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/inquisitor_tide_back/inquisitor_tide_back.vmdl"})
      mask6:FollowEntity(hero, true)

      local mask7 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/inquisitor_tide_shoulder/inquisitor_tide_shoulder.vmdl"})
      mask7:FollowEntity(hero, true)

      local mask8 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/inquisitor_tide_misc/inquisitor_tide_misc.vmdl"})
      mask8:FollowEntity(hero, true)

      local mask9 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/kunkka/arm_lev_neptunian_sabre/arm_lev_neptunian_sabre.vmdl"})
      mask9:FollowEntity(hero, true)
    end
    if hero:GetUnitName() == "npc_dota_hero_furion" then

    end
    if hero:GetUnitName() == "npc_dota_hero_antimage" then
      LinkLuaModifier("modifier_daredevil", "modifiers/modifier_daredevil.lua", LUA_MODIFIER_MOTION_NONE)

      hero:AddNewModifier(hero, nil, "modifier_daredevil", nil)
    end
    if hero:GetUnitName() == "npc_dota_hero_ogre_magi" then
      LinkLuaModifier("modifier_spell_amp", "modifiers/modifier_spell_amp.lua", LUA_MODIFIER_MOTION_NONE)

      hero:AddNewModifier(hero, nil, "modifier_spell_amp", nil)
    end
    if hero:GetUnitName() == "npc_dota_hero_night_stalker" then
      local hasItem = false

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "bolt_arcana") == true and not hasItem then
        hasItem = true

        LinkLuaModifier("modifier_bolt_arcana" , "modifiers/modifier_bolt_arcana.lua", LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_bolt_arcana", nil)

        hero:SetOriginalModel("models/black_bolt/black_bolt_arcana/black_bolt_arcana.vmdl")

        local HeroPFX = ParticleManager:CreateParticle( "particles/hero_black_bolt/arcana/black_bolt_arcana_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControl( HeroPFX, 15, Vector(0, 199, 255) )
        ParticleManager:SetParticleControl( HeroPFX, 16, Vector(1, 0, 0) )

        local weapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/black_bolt/black_bolt_arcana/abysm_outworld_staff.vmdl"})
        weapon:FollowEntity(hero, true)
        local weaponPFX = ParticleManager:CreateParticle( "particles/hero_black_bolt/arcana/black_bolt_arcana_weapon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon )
        ParticleManager:SetParticleControlEnt( weaponPFX, 0, weapon, PATTACH_POINT_FOLLOW, "attach_weapon" , weapon:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( weaponPFX, 1, weapon, PATTACH_POINT_FOLLOW, "attach_weapon2" , weapon:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( weaponPFX, 4, weapon, PATTACH_POINT_FOLLOW, "attach_weapon2" , weapon:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( weaponPFX, 8, weapon, PATTACH_POINT_FOLLOW, "attach_cornerL" , weapon:GetOrigin(), true )

        local weaponPFX2 = ParticleManager:CreateParticle( "particles/hero_black_bolt/arcana/black_bolt_arcana_weapon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon )
        ParticleManager:SetParticleControlEnt( weaponPFX2, 0, weapon, PATTACH_POINT_FOLLOW, "attach_weapon" , weapon:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( weaponPFX2, 1, weapon, PATTACH_POINT_FOLLOW, "attach_weapon2" , weapon:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( weaponPFX2, 4, weapon, PATTACH_POINT_FOLLOW, "attach_weapon2" , weapon:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( weaponPFX2, 8, weapon, PATTACH_POINT_FOLLOW, "attach_cornerR" , weapon:GetOrigin(), true )

        local head = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/black_bolt/black_bolt_arcana/abysm_outworld_helmet.vmdl"})
        head:FollowEntity(hero, true)

        local mask24 = ParticleManager:CreateParticle( "particles/hero_black_bolt/arcana/black_bolt_arcana_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, head )
        ParticleManager:SetParticleControlEnt( mask24, 0, head, PATTACH_POINT_FOLLOW, "attach_eye_l" , head:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask24, 1, head, PATTACH_POINT_FOLLOW, "attach_eye_r" , head:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask24, 2, head, PATTACH_POINT_FOLLOW, "attach_eye_l" , head:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask24, 3, head, PATTACH_POINT_FOLLOW, "attach_eye_r" , head:GetOrigin(), true )
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_troll_warlord" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "ronan_weapon_shadowmorne") == true then
        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ronan/econs/ronan_shadowmourne.vmdl"})
        mask2:FollowEntity(hero, true)
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "ronan_eternity_hammer") == true then
        LinkLuaModifier("modifier_ronan_hammer" , "modifiers/modifier_ronan_hammer.lua", LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_ronan_hammer", nil)

        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ronan/econs/ronan_ethernal_hammer.vmdl"})
        mask2:FollowEntity(hero, true)

        local mask222 = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_hammer_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask2 )
        ParticleManager:SetParticleControlEnt( mask222, 0, mask2, PATTACH_POINT_FOLLOW, "attach_corner" , mask2:GetOrigin(), true )
      else SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ronan/econs/ronan_weapon.vmdl"}):FollowEntity(hero, true) end

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "ronan_armor_mail") == true then
        local ronan_armor_mail = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ronan/econs/ronan_moltenclaw.vmdl"})
        ronan_armor_mail:FollowEntity(hero, true)
        local ronan_armor_mailPFX = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_armor_molten_claw/axe_molten_claw_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ronan_armor_mail )
      end
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "ronan_vanguard") == true then
        local ronan_vanguard = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ronan/econs/ronan_vanguard.vmdl"})
        ronan_vanguard:FollowEntity(hero, true)
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_warlock" then
      local pudge_donat = ParticleManager:CreateParticle( "particles/units/heroes/hero_zeus/zeus_ambient_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( pudge_donat, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( pudge_donat, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )

      local pudge_donat2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_zeus/zeus_ambient_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( pudge_donat2, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( pudge_donat2, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )

      local pudge_donat3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_zeus/zeus_ambient_hands.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( pudge_donat3, 0, hero, PATTACH_POINT_FOLLOW, "attach_attack1" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( pudge_donat3, 1, hero, PATTACH_POINT_FOLLOW, "attach_attack2" , hero:GetOrigin(), true )

      local cloud2 = ParticleManager:CreateParticle( "particles/world_shrine/radiant_shrine_regen.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( cloud2, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetOrigin(), true )
    end
    if hero:GetUnitName() == "npc_dota_hero_batrider" then
      LinkLuaModifier ("modifier_godspeed_tempest_double_scepter", "abilities/godspeed_tempest_double.lua", LUA_MODIFIER_MOTION_NONE)
      hero:AddNewModifier(hero, nil, "modifier_godspeed_tempest_double_scepter", nil)

      hero:FindAbilityByName("godspeed_tempest_double"):SetLevel(1)

      local pudge_donat = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/bounty_hunter_ursine/bounty_hunter_usrine_eyes_base_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( pudge_donat, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( pudge_donat, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )

      local pudge_donat2 = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/bounty_hunter_ursine/bounty_hunter_usrine_eyes_base_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( pudge_donat2, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( pudge_donat2, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )

      local pudge_donat3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_zeus/zeus_ambient_hands.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( pudge_donat3, 0, hero, PATTACH_POINT_FOLLOW, "attach_attack1" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( pudge_donat3, 1, hero, PATTACH_POINT_FOLLOW, "attach_attack2" , hero:GetOrigin(), true )

      local cloud2 = ParticleManager:CreateParticle( "particles/hero_godspeed/godspeed_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( cloud2, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetOrigin(), true )
    end
    if hero:GetUnitName() == "npc_dota_hero_centaur" then
      hero:SetRenderColor(0, 0 ,0)
      local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/black_flash/black_flash_head_final.vmdl"})
      mask:FollowEntity(hero, true)
      mask:SetRenderColor(255, 69, 0)

      local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/silencer/bts_final_utterance_shoulder/bts_final_utterance_shoulder.vmdl"})
      mask1:FollowEntity(hero, true)
      mask1:SetRenderColor(255, 69, 0)
    end
    if hero:GetUnitName() == "npc_dota_hero_shadow_shaman" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "iron_fist_golden_ways_of_faith") == true then
        local cape = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ironfist/econs/waiths_of_faith.vmdl"})
        cape:FollowEntity(hero, true)
        cape:SetMaterialGroup("gold")

        ParticleManager:CreateParticle( "particles/econ/ironfist_golden_item.vpcf", PATTACH_ABSORIGIN_FOLLOW, cape )
        ParticleManager:CreateParticle( "particles/hero_iron_fist/iron_fist_iron_strike_immortal_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "iron_fist_ways_of_faith") == true then
        local cape = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ironfist/econs/waiths_of_faith.vmdl"})
        cape:FollowEntity(hero, true)

        ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, cape )
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_nyx_assassin" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "the_first_hunter") == true then
        hero:SetOriginalModel("models/heroes/hero_ares_arcana/ares.vmdl")

        LinkLuaModifier("modifier_the_firs_hunter" , "modifiers/modifier_the_firs_hunter.lua", LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_the_firs_hunter", nil)

        Timers:CreateTimer(0.1, function()
          SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ares_arcana/weapon/weapon.vmdl"}):FollowEntity(hero, true)

          ParticleManager:CreateParticle( "particles/econ/courier/courier_onibi/courier_onibi_black_ambient_c_lvl21.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
          ParticleManager:CreateParticle( "particles/econ/courier/courier_oculopus/courier_oculopus_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
          ParticleManager:CreateParticle( "particles/econ/courier/courier_onibi/courier_onibi_black_ambient_c_lvl21.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
          ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )

          local pudge_donat2 = ParticleManager:CreateParticle( "particles/econ/courier/courier_greevil_black/courier_greevil_black_ambient_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
          ParticleManager:SetParticleControlEnt( pudge_donat2, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )
          ParticleManager:SetParticleControlEnt( pudge_donat2, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )
          ParticleManager:SetParticleControl( pudge_donat2, 2, Vector(0, 0, 0))
        end)
        return
      end
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "ashbringer") == true then
        local weapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ares_ww/econs/ashbringer.vmdl"})
        weapon:FollowEntity(hero, true)

        local weapon_pfx = ParticleManager:CreateParticle( "particles/econ/ashbringer.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon )
        ParticleManager:SetParticleControlEnt( weapon_pfx, 0, weapon, PATTACH_POINT_FOLLOW, "attach_flame" , weapon:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( weapon_pfx, 1, weapon, PATTACH_POINT_FOLLOW, "attach_flame" , weapon:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( weapon_pfx, 2, weapon, PATTACH_POINT_FOLLOW, "attach_flame" , weapon:GetOrigin(), true )
        ParticleManager:SetParticleControl( weapon_pfx, 15, Vector(255, 255, 255))
        ParticleManager:SetParticleControl( weapon_pfx, 16, Vector(0, 0, 0))
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "ares_olympus_sword") == true then
        local weapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ares_ww/econs/ares_legendary_weapon.vmdl"})
        weapon:FollowEntity(hero, true)
      elseif  Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "ares_son_of_zeus") == true then
        local weapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ares_ww/econs/ares_zuus_weapon.vmdl"})
        weapon:FollowEntity(hero, true)

        local pfx = ParticleManager:CreateParticle( "particles/hero_ares/ares_immortal_lightning_weapon.vpcf", PATTACH_ABSORIGIN_FOLLOW, weapon )
        ParticleManager:SetParticleControlEnt( pfx, 0, weapon, PATTACH_POINT_FOLLOW, "attach_grip" , weapon:GetOrigin(), true )
      else
        SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ares_ww/econs/weap_right.vmdl"}):FollowEntity(hero, true)
      end

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "ares_olympus_shield") == true then
        local shield = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ares_ww/econs/ares_aegis.vmdl"})
        shield:FollowEntity(hero, true)
      else
        SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ares_ww/econs/weap_left.vmdl"}):FollowEntity(hero, true)
      end
      local eyes = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_baphomet_set/doom_skulleye.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( eyes, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( eyes, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )

    end
    if hero:GetUnitName() == "npc_dota_hero_bane" then
      local pudge_donat = ParticleManager:CreateParticle( "particles/econ/items/pugna/pugna_ward_ti5/pugna_ambient_eyes_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( pudge_donat, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( pudge_donat, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )

      local pudge_donat2 = ParticleManager:CreateParticle( "particles/econ/items/pugna/pugna_ward_ti5/pugna_ambient_eyes_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( pudge_donat2, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( pudge_donat2, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )
    end
    if hero:GetUnitName() == "npc_dota_hero_death_prophet" then
      local oracle_false_promise_planet = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_ambient_ball.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( oracle_false_promise_planet, 0, hero, PATTACH_POINT_FOLLOW, "attach_orb" , hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( oracle_false_promise_planet, 2, hero, PATTACH_POINT_FOLLOW, "attach_orb" , hero:GetOrigin(), true )
    end
    if hero:GetUnitName() == "npc_dota_hero_omniknight" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "thor_helmet") then
        local mask4 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thor/helmet_of_the_thundergod.vmdl"})
        mask4:FollowEntity(hero, true)
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "deus_vult") then
        SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thor/econs/source/thor_helmet.vmdl"}):FollowEntity(hero, true)
      end

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "thor_sulfuras") then
        LinkLuaModifier("modifier_thor_sulfuras", "modifiers/modifier_thor_sulfuras.lua", LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_thor_sulfuras", nil)
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thor/sulfuras/thor_sulfuras.vmdl"})
        mask1:FollowEntity(hero, true)

        local sulfuras = ParticleManager:CreateParticle( "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
        ParticleManager:SetParticleControlEnt( sulfuras, 0, mask1, PATTACH_POINT_FOLLOW, "attach_weapon" , mask1:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( sulfuras, 1, mask1, PATTACH_POINT_FOLLOW, "attach_weapon" , mask1:GetOrigin(), true )
        ParticleManager:SetParticleControl( sulfuras, 8, Vector(1, 0, 0))
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "mjollnir") then
        SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thor/econs/source/thor_mjollnir.vmdl"}):FollowEntity(hero, true)
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "dawnbreaker") then
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thor/econs/source/thor_dawnbreaker.vmdl"})
        mask1:FollowEntity(hero, true)
        local pfx = ParticleManager:CreateParticle( "particles/econ/dawnbreaker.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
        ParticleManager:SetParticleControlEnt( pfx, 0, mask1, PATTACH_POINT_FOLLOW, "attach_sword" , mask1:GetOrigin(), true )
      else
        SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thor/thor_weapon.vmdl"}):FollowEntity(hero, true)
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_viper" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "the_mask_of_void") then
        local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ebony_maw/econs/mask_of_the_void/the_mask_of_void.vmdl"})
        mask:FollowEntity(hero, true)

        ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )

        local khan_donat = ParticleManager:CreateParticle( "particles/econ/items/lion/fish_stick/lion_fish_stick_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( khan_donat, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( khan_donat, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_oracle" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "anubis_jugment") then
        hero:AddNewModifier(hero, nil, "modifier_arcana", nil)
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_oblivion/anubis_jujment/anubis_jugment.vmdl"})
        mask1:SetParent(hero, nil)
        mask1:FollowEntity(hero, true)
        mask1:SetOwner(hero)

        local mask1_particle3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_bane/bane_nightmare_inkblots.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        local mask1_particle4 = ParticleManager:CreateParticle( "particles/units/heroes/hero_bane/bane_nightmare_inkblots_thick.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        local mask1_particle5 = ParticleManager:CreateParticle( "particles/units/heroes/hero_bane/bane_nightmare_worms.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )


        local mask_particle2 = ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_desert_sands/courier_roshan_desert_sands_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
        ParticleManager:SetParticleControlEnt( mask_particle2, 0, mask1, PATTACH_POINT_FOLLOW, "attach_eye_r" , mask1:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask_particle2, 1, mask1, PATTACH_POINT_FOLLOW, "attach_eye_l" , mask1:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask_particle2, 2, mask1, PATTACH_POINT_FOLLOW, "attach_eye_l" , mask1:GetOrigin(), true )
      else
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/oracle/head_item.vmdl"})
        mask1:SetParent(hero, nil)
        mask1:FollowEntity(hero, true)
        mask1:SetOwner(hero)
      end

        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/oracle/armor.vmdl"})
        mask1:SetParent(hero, nil)
        mask1:FollowEntity(hero, true)
        mask1:SetOwner(hero)


        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/oracle/back_item.vmdl"})
        mask2:SetParent(hero, nil)
        mask2:FollowEntity(hero, true)
        mask2:SetOwner(hero)


        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "oblivion_shard_of_creation") == true then
          local weapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/oracle/ti7_immortal_weapon/oracle_ti7_immortal_weapon.vmdl"})
          weapon:SetParent(hero, nil)
          weapon:FollowEntity(hero, true)

          ParticleManager:CreateParticle( "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        else
          local mask3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/oracle/weapon.vmdl"})
          mask3:SetParent(hero, nil)
          mask3:FollowEntity(hero, true)
          mask3:SetOwner(hero)
        end
    end
    if hero:GetUnitName() == "npc_dota_hero_windrunner" then
      LinkLuaModifier("modifier_death", "modifiers/modifier_death.lua", LUA_MODIFIER_MOTION_NONE)
      hero:AddNewModifier(hero, nil, "modifier_death", nil)
    end
    if hero:GetUnitName() == "npc_dota_hero_doom_bringer" then
      LinkLuaModifier("modifier_doom", "modifiers/modifier_doom.lua", LUA_MODIFIER_MOTION_NONE)
      hero:AddNewModifier(hero, nil, "modifier_doom", nil)
    end
    if hero:GetUnitName() == "npc_dota_hero_visage" then
      local nFXIndex = ParticleManager:CreateParticle( "particles/ragnaros/ragnaros_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( nFXIndex, 0, hero, PATTACH_POINT_FOLLOW, "attach_inner", hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero, PATTACH_POINT_FOLLOW, "attach_root", hero:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt( nFXIndex, 3, hero, PATTACH_POINT_FOLLOW, "attach_root", hero:GetOrigin(), true )

      local eyes = ParticleManager:CreateParticle( "particles/econ/items/ancient_apparition/aa_blast_ti_5/aa_ti5_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      ParticleManager:SetParticleControlEnt( eyes, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetAbsOrigin(), true )
      ParticleManager:SetParticleControlEnt( eyes, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetAbsOrigin(), true )

      local scirt = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_ragnaros/ragnaros_skirt.vmdl"})
      scirt:FollowEntity(hero, true)
    end
    if hero:GetUnitName() == "npc_dota_hero_slardar" then
      hero:SetOriginalModel("models/heroes/hero_sauron_/sauron_.vmdl")
      SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_sauron_/econs/mace.vmdl"}):FollowEntity(hero, true)
    end
	  if hero:GetUnitName() == "npc_dota_hero_beastmaster" then
	    local ability = hero:FindAbilityByName("draks_flesh_heap")
	    ability:SetLevel(1)
	  end
    if hero:GetUnitName() == "npc_dota_hero_slark" then
      hero:SetRenderColor(191, 239, 255)
      local abil = hero:FindAbilityByName("murlock_agility_steal")
      abil:SetLevel(1)

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "murlock_golden_helmet") == true then
        hero:SetOriginalModel("models/heroes/hero_murloc/murloc/murloc.vmdl")
        local slark_eyes = ParticleManager:CreateParticle( "particles/econ/items/phoenix/phoenix_solar_forge/phoenix_solar_forge_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( slark_eyes, 0, hero, PATTACH_POINT_FOLLOW, "attach_jaw" , hero:GetOrigin() + Vector(0, 0, 32), true )
        ParticleManager:SetParticleControlEnt( slark_eyes, 1, hero, PATTACH_POINT_FOLLOW, "attach_jaw" , hero:GetOrigin() + Vector(0, 0, 32), true )
        ParticleManager:SetParticleControlEnt( slark_eyes, 2, hero, PATTACH_POINT_FOLLOW, "attach_jaw" , hero:GetOrigin() + Vector(0, 0, 32), true )
        ParticleManager:SetParticleControl(slark_eyes, 6, Vector(1000, 1, 1))

        local slark_eyes2 = ParticleManager:CreateParticle( "particles/murlock/murlock_golden_helmet_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( slark_eyes2, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( slark_eyes2, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( slark_eyes2, 2, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl(slark_eyes2, 15, Vector(255, 255, 255))
        ParticleManager:SetParticleControl(slark_eyes2, 16, Vector(1, 0, 0))

        local slark_eyes3 = ParticleManager:CreateParticle( "particles/murlock/murlock_golden_helmet_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( slark_eyes3, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( slark_eyes3, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( slark_eyes3, 2, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl(slark_eyes3, 15, Vector(255, 255, 255))
        ParticleManager:SetParticleControl(slark_eyes3, 16, Vector(1, 0, 0))
        hero:SetRenderColor(191, 239, 255)

        local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/slark_head_immortal/slark_head_immortal.vmdl"})
        mask:FollowEntity(hero, true)

        local mask_amb = ParticleManager:CreateParticle( "particles/econ/items/slark/slark_head_immortal/slark_head_immortal_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask )

        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_murloc/murlock_azinoth_arcana.vmdl"})
        mask1:FollowEntity(hero, true)
        local mask1_particle = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/underlord_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
        ParticleManager:SetParticleControlEnt( mask1_particle, 0, mask1, PATTACH_POINT_FOLLOW, "attach_effect" , hero:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask1_particle, 1, mask1, PATTACH_POINT_FOLLOW, "attach_effect" , hero:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask1_particle, 5, mask1, PATTACH_POINT_FOLLOW, "attach_effect" , hero:GetOrigin(), true )

        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deepscoundrel_back/deepscoundrel_back.vmdl"})
        mask2:FollowEntity(hero, true)

        local mask3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deepscoundrel_arms/deepscoundrel_arms.vmdl"})
        mask3:FollowEntity(hero, true)
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "skadi") == true then
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/hookblade_skadi/hookblade_skadi.vmdl"})
        mask1:FollowEntity(hero, true)
        ParticleManager:CreateParticle( "particles/econ/items/slark/hookblade_of_skadi/slark_hookblade_skadi_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )

        local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deep_sea_dragoon_head/deep_sea_dragoon_head.vmdl"})
        mask:FollowEntity(hero, true)
        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deepscoundrel_back/deepscoundrel_back.vmdl"})
        mask2:FollowEntity(hero, true)
        local mask3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deepscoundrel_arms/deepscoundrel_arms.vmdl"})
        mask3:FollowEntity(hero, true)
        ParticleManager:CreateParticle( "particles/econ/items/slark/hookblade_of_skadi/slark_hookblade_skadi_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "golden_skadi") == true then
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/golden_barb_of_skadi/golden_barb_of_skadi.vmdl"})
        mask1:FollowEntity(hero, true)

        local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deep_sea_dragoon_head/deep_sea_dragoon_head.vmdl"})
        mask:FollowEntity(hero, true)
        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deepscoundrel_back/deepscoundrel_back.vmdl"})
        mask2:FollowEntity(hero, true)
        local mask3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deepscoundrel_arms/deepscoundrel_arms.vmdl"})
        mask3:FollowEntity(hero, true)
        ParticleManager:CreateParticle( "particles/econ/items/slark/slark_golden_barb_of_skadi/slark_golden_barb_of_skadi_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
      else
        local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deep_sea_dragoon_head/deep_sea_dragoon_head.vmdl"})
        mask:FollowEntity(hero, true)

        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/pale_justice/pale_justice.vmdl"})
        mask1:FollowEntity(hero, true)

        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deepscoundrel_back/deepscoundrel_back.vmdl"})
        mask2:FollowEntity(hero, true)

        local mask3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/slark/deepscoundrel_arms/deepscoundrel_arms.vmdl"})
        mask3:FollowEntity(hero, true)
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_terrorblade" then
      local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/galactus/galactus_head.vmdl"})
      mask:FollowEntity(hero, true)
    end
    if hero:GetUnitName() == "npc_dota_hero_bounty_hunter" then
    end
    if hero:GetUnitName() == "npc_dota_hero_ember_spirit" then
      LinkLuaModifier("modifier_goldengod", "modifiers/modifier_goldengod.lua", LUA_MODIFIER_MOTION_NONE)
      hero:AddNewModifier(hero, nil, "modifier_goldengod", nil)
    end
    if hero:GetUnitName() == "npc_dota_hero_spirit_breaker" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "deadshot") == false then
        Attachments:AttachProp(hero, "attach_attack2", "models/deathstroke/weapon.vmdl", 1)
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_lone_druid" then
      local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/earth_spirit/earth_spirit_arms.vmdl"})
      mask:FollowEntity(hero, true)

      local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/darkseid/darksied_head_final.vmdl"})
      mask1:FollowEntity(hero, true)

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "darkseid_golden_ancient_cursed_helmet") == true then
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_darkseid/darkseid_golden_ancient_cursed_helmet.vmdl"})
        mask1:FollowEntity(hero, true)

        local ntfx = ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( ntfx, 0, mask1, PATTACH_POINT_FOLLOW, "attach_head" , mask1:GetOrigin(), true )
        ParticleManager:SetParticleControl( ntfx, 3, Vector(1, 0, 0))
        ParticleManager:SetParticleControl( ntfx, 9, Vector(1, 0, 0))
        ParticleManager:SetParticleControl( ntfx, 15, Vector(255, 221, 0))
        ParticleManager:SetParticleControl( ntfx, 16, Vector(1, 0, 0))
        local mask22 = ParticleManager:CreateParticle( "particles/hero_arthas/arthas_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
        ParticleManager:SetParticleControlEnt( mask22, 0, mask1, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )
        local mask23 = ParticleManager:CreateParticle( "particles/hero_arthas/arthas_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
        ParticleManager:SetParticleControlEnt( mask23, 0, mask1, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "darkseid_ancient_cursed_helmet") == true then
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_darkseid/darkseid_ancient_cursed_helmet.vmdl"})
        mask1:FollowEntity(hero, true)
        local ntfx = ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( ntfx, 0, mask1, PATTACH_POINT_FOLLOW, "attach_head" , mask1:GetOrigin(), true )
        ParticleManager:SetParticleControl( ntfx, 3, Vector(1, 0, 0))
        ParticleManager:SetParticleControl( ntfx, 9, Vector(1, 0, 0))
        ParticleManager:SetParticleControl( ntfx, 15, Vector(0, 110, 255))
        ParticleManager:SetParticleControl( ntfx, 16, Vector(1, 0, 0))
        local mask22 = ParticleManager:CreateParticle( "particles/hero_arthas/arthas_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
        ParticleManager:SetParticleControlEnt( mask22, 0, mask1, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetOrigin(), true )
        local mask23 = ParticleManager:CreateParticle( "particles/hero_arthas/arthas_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
        ParticleManager:SetParticleControlEnt( mask23, 0, mask1, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetOrigin(), true )
      else
        local eyes1 = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/bounty_hunter_ursine/bounty_hunter_usrine_eyes_r.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( eyes1, 0, mask1, PATTACH_POINT_FOLLOW, "attach_eye_r" , mask1:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( eyes1, 1, mask1, PATTACH_POINT_FOLLOW, "attach_eye_r" , mask1:GetAbsOrigin(), true )

        local eyes2 = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/bounty_hunter_ursine/bounty_hunter_usrine_eyes_r.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( eyes2, 0, mask1, PATTACH_POINT_FOLLOW, "attach_eye_l" , mask1:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( eyes2, 1, mask1, PATTACH_POINT_FOLLOW, "attach_eye_l" , mask1:GetAbsOrigin(), true )
      end

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "darkseid_eternal_glory") == true then
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_darkseid/darkseid_frostnourne.vmdl"})
        mask1:FollowEntity(hero, true)
      end

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "darkseid_hand_of_god") == true then
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_darkseid/darkseid_hand_of_god.vmdl"})
        mask1:FollowEntity(hero, true)

        local ambient = ParticleManager:CreateParticle( "particles/darkseid/darkseid_glove_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask1 )
        ParticleManager:SetParticleControlEnt( ambient, 0, mask1, PATTACH_POINT_FOLLOW, "attach_glove" , mask1:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( ambient, 1, mask1, PATTACH_POINT_FOLLOW, "attach_glove" , mask1:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( ambient, 15, Vector(71, 255, 9) )
        ParticleManager:SetParticleControl( ambient, 16, Vector(1, 0, 0))

        hero:AddNewModifier(hero, nil, "modifier_arcana", nil)
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_kunkka" then
      local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_drstrange/cape.vmdl"})
      mask:FollowEntity(hero, true)
    end
    if hero:GetUnitName() == "npc_dota_hero_sven" then
      hero:SetRenderColor(105, 105, 105)

      local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sven/arbiter_belt/arbiter_belt.vmdl"})
      mask1:FollowEntity(hero, true)

      local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sven/arbiter_arms/arbiter_arms.vmdl"})
      mask2:FollowEntity(hero, true)

      local mask3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sven/arbiter_back/arbiter_back.vmdl"})
      mask3:FollowEntity(hero, true)

      local mask4 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sven/arbiter_head/arbiter_head.vmdl"})
      mask4:FollowEntity(hero, true)

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "apocalypse_greatsword") then
        local weap = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sven/shattered_greatsword/sven_shattered_greatsword.vmdl"})
        weap:FollowEntity(hero, true)

        local weap_particle = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_shattered_great_sword/sven_shattered_greatsword_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, weap )
      else
        local weap = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sven/arbiter_weapon/arbiter_weapon.vmdl"})
        weap:FollowEntity(hero, true)
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_axe" then
      hero:SetRenderColor(255, 0, 0)
    end
    if hero:GetUnitName() == "npc_dota_hero_templar_assassin" then ---models/b2/b2.vmdl
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "neo_noir") then
        LinkLuaModifier("modifier_neo_noir", "modifiers/modifier_neo_noir.lua", LUA_MODIFIER_MOTION_NONE)
        hero:SetSkillBuild("npc_dota_hero_juggernaut")
        hero:SetOriginalModel("models/b2/b2.vmdl")
        local mask5 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/b2/weapon/weapon.vmdl"})
        mask5:FollowEntity(hero, true)
        hero:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
        hero:AddNewModifier(hero, nil, "modifier_neo_noir", nil)
        return
      end
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "wanda_arcana") then
        hero:SetOriginalModel("models/heroes/hero_witch/wanda_arcana/wanda_arcana.vmdl")
        hero:AddNewModifier(hero, nil, "modifier_arcana", nil)
        local mask5_particle = ParticleManager:CreateParticle( "particles/witch/witch_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( mask5_particle, 0, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 2, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 3, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 4, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 5, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 6, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask5_particle, 8, Vector(1, 0, 0) )
        ParticleManager:SetParticleControlEnt( mask5_particle, 9, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask5_particle, 15, Vector(255, 89, 0) )
        ParticleManager:SetParticleControl( mask5_particle, 16, Vector(1, 0, 0) )
        return
      end
       if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "scarlet_golden_armor") then
        local mask5 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_witch/wanda_immortal/wanda_belt_immortal.vmdl"})
        mask5:FollowEntity(hero, true)
        mask5:SetMaterialGroup("golden")
        local mask5_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask5 )
        ParticleManager:SetParticleControlEnt( mask5_particle, 0, mask5, PATTACH_POINT_FOLLOW, "attach_armor" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 1, mask5, PATTACH_POINT_FOLLOW, "attach_armor" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 3, mask5, PATTACH_POINT_FOLLOW, "attach_armor" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 4, mask5, PATTACH_POINT_FOLLOW, "attach_armor" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask5_particle, 5, Vector(1, 1, 1) )
        ParticleManager:SetParticleControl( mask5_particle, 6, Vector(0, 0, 0) )


        local mask6_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( mask6_particle, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask6_particle, 1, hero, PATTACH_POINT_FOLLOW, "attach_eyeR" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask6_particle, 2, hero, PATTACH_POINT_FOLLOW, "attach_eyeL" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask6_particle, 15, Vector(255, 46, 1) )
        ParticleManager:SetParticleControl( mask6_particle, 16, Vector(1, 1, 1) )

        local mask9_particle = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_cinder/axe_cinder_ambient_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask5 )
        ParticleManager:SetParticleControlEnt( mask9_particle, 0, mask5, PATTACH_POINT_FOLLOW, "attach_cape" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask9_particle, 6, Vector(1, 1, 1) )

        local mask11_particle = ParticleManager:CreateParticle( "particles/econ/items/lina/lina_ti7/lina_ti7_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask5 )
        ParticleManager:SetParticleControlEnt( mask11_particle, 0, mask5, PATTACH_POINT_FOLLOW, "attach_belt" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask11_particle, 6, Vector(1, 1, 1) )

        local mask10_particle = ParticleManager:CreateParticle( "particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "scarlet_armor") then
        local mask5 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_witch/wanda_immortal/wanda_belt_immortal.vmdl"})
        mask5:FollowEntity(hero, true)

        local mask5_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask5 )
        ParticleManager:SetParticleControlEnt( mask5_particle, 0, mask5, PATTACH_POINT_FOLLOW, "attach_armor" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 1, mask5, PATTACH_POINT_FOLLOW, "attach_armor" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 3, mask5, PATTACH_POINT_FOLLOW, "attach_armor" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask5_particle, 4, mask5, PATTACH_POINT_FOLLOW, "attach_armor" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask5_particle, 5, Vector(1, 1, 1) )
        ParticleManager:SetParticleControl( mask5_particle, 6, Vector(0, 0, 0) )


        local mask6_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( mask6_particle, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask6_particle, 1, hero, PATTACH_POINT_FOLLOW, "attach_eyeR" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask6_particle, 2, hero, PATTACH_POINT_FOLLOW, "attach_eyeL" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask6_particle, 15, Vector(255, 46, 1) )
        ParticleManager:SetParticleControl( mask6_particle, 16, Vector(1, 1, 1) )

        local mask9_particle = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_cinder/axe_cinder_ambient_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask5 )
        ParticleManager:SetParticleControlEnt( mask9_particle, 0, mask5, PATTACH_POINT_FOLLOW, "attach_cape" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask9_particle, 6, Vector(1, 1, 1) )

        local mask11_particle = ParticleManager:CreateParticle( "particles/econ/items/lina/lina_ti7/lina_ti7_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask5 )
        ParticleManager:SetParticleControlEnt( mask11_particle, 0, mask5, PATTACH_POINT_FOLLOW, "attach_belt" , mask5:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask11_particle, 6, Vector(1, 1, 1) )

        local mask10_particle = ParticleManager:CreateParticle( "particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      end

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "scarlet_weapon") then
        local mask8_particle = ParticleManager:CreateParticle( "particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        local mask7_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( mask7_particle, 0, hero, PATTACH_POINT_FOLLOW, "attach_handL" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask7_particle, 1, hero, PATTACH_POINT_FOLLOW, "attach_handR" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask7_particle, 2, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )

        local mask11_particle = ParticleManager:CreateParticle( "particles/econ/items/templar_assassin/templar_assassin_focal/ta_focal_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( mask11_particle, 0, hero, PATTACH_POINT_FOLLOW, "attach_handL" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask11_particle, 1, hero, PATTACH_POINT_FOLLOW, "attach_head" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask11_particle, 2, hero, PATTACH_POINT_FOLLOW, "attach_handR" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask11_particle, 3, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask11_particle, 4, hero, PATTACH_POINT_FOLLOW, "attach_hitloc" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( mask11_particle, 5, Vector(1, 1, 1) )
        ParticleManager:SetParticleControl( mask11_particle, 6, Vector(0, 0, 0) )
        ParticleManager:SetParticleControl( mask11_particle, 7, Vector(0, 0, 0) )
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_elder_titan" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "titans_armor") then
        hero:SetOriginalModel("models/heroes/hero_thanos/thanos.vmdl")

        SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thanos_arcana/thanos_helmet.vmdl"}):FollowEntity(hero, true)

        Timers:CreateTimer(0.1, function()
          ParticleManager:CreateParticle( "particles/econ/events/ti7/radiance_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
          ParticleManager:CreateParticle( "particles/econ/courier/courier_oculopus/courier_oculopus_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )

          local eye = ParticleManager:CreateParticle( "particles/econ/items/ursa/ursa_razorwyrm/ursa_razorwyrm_ambient_v2_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
          ParticleManager:SetParticleControlEnt( eye, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetAbsOrigin(), true )
          ParticleManager:SetParticleControlEnt( eye, 2, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetAbsOrigin(), true )
        end)
        return
      end

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "thanos_crystals_of_foundation") and not hasCosmetic then
        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thanos/econs/thanos_crystals_of_foundation.vmdl"})
        mask2:FollowEntity(hero, true)
        mask2:SetRenderColor(255, 215, 0)

        local eye = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_arcana_body_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask2 )
        ParticleManager:SetParticleControlEnt( eye, 0, mask2, PATTACH_POINT_FOLLOW, "attach_crystal" , mask2:GetAbsOrigin(), true )


        local mace = ParticleManager:CreateParticle( "particles/thanos/thanos_crystal_weapon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask2 )
        ParticleManager:SetParticleControlEnt( mace, 0, mask2, PATTACH_POINT_FOLLOW, "attach_crystal" , mask2:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl(mace, 15, Vector(255, 255, 255))
        ParticleManager:SetParticleControl(mace, 16, Vector(1, 0, 1))
        return
      end

      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "thanos_golden_timebreaker") and not hasCosmetic then
        LinkLuaModifier("modifier_thanos_golden_timebreaker", "modifiers/modifier_thanos_golden_timebreaker.lua", LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_thanos_golden_timebreaker", nil)
        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thanos/econs/thanos_timebreaker.vmdl"})
        mask2:FollowEntity(hero, true)
        mask2:SetRenderColor(255, 215, 0)
        local eye = ParticleManager:CreateParticle( "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( eye, 0, mask2, PATTACH_POINT_FOLLOW, "attach_sword" , mask2:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( eye, 1, hero, PATTACH_POINT_FOLLOW, "attach_eye_r" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( eye, 2, hero, PATTACH_POINT_FOLLOW, "attach_eye_l" , hero:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl(eye, 15, Vector(255, 255, 1))
        ParticleManager:SetParticleControl(eye, 16, Vector(1, 1, 1))

        local mace = ParticleManager:CreateParticle( "particles/econ/items/pugna/pugna_ward_golden_nether_lord/pugna_gold_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
        ParticleManager:SetParticleControlEnt( mace, 0, mask2, PATTACH_POINT_FOLLOW, "attach_sword" , mask2:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mace, 1, mask2, PATTACH_POINT_FOLLOW, "attach_sword" , mask2:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( mace, 4, mask2, PATTACH_POINT_FOLLOW, "attach_sword" , mask2:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl(mace, 2, Vector(255, 255, 1))
        ParticleManager:SetParticleControl(mace, 17, Vector(100, 100, 0))
        ParticleManager:SetParticleControl(mace, 15, Vector(255, 255, 1))
        ParticleManager:SetParticleControl(mace, 16, Vector(1, 0, 1))

        local effect = ParticleManager:CreateParticle( "particles/econ/items/faceless_void/faceless_void_weapon_timebreaker/faceless_void_weapon_glow_timebreaker.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask2 )
        ParticleManager:SetParticleControlEnt( effect, 0, mask2, PATTACH_POINT_FOLLOW, "attach_sword" , mask2:GetOrigin(), true )
        ParticleManager:SetParticleControl( effect, 1, Vector(300, 300, 1))
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "thanos_timebreaker") and not hasCosmetic then
        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thanos/econs/thanos_timebreaker.vmdl"})
        mask2:FollowEntity(hero, true)

        local effect = ParticleManager:CreateParticle( "particles/econ/items/faceless_void/faceless_void_weapon_timebreaker/faceless_void_weapon_glow_timebreaker.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask2 )
        ParticleManager:SetParticleControlEnt( effect, 0, mask2, PATTACH_POINT_FOLLOW, "attach_sword" , mask2:GetOrigin(), true )
        ParticleManager:SetParticleControl( effect, 1, Vector(300, 300, 1))
      elseif Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "king_thanos") and not hasCosmetic then
        LinkLuaModifier("modifier_king_thanos", "modifiers/modifier_king_thanos.lua", LUA_MODIFIER_MOTION_NONE)
        hero:AddNewModifier(hero, nil, "modifier_king_thanos", nil)

        local mask2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thanos/econs/king_thanos.vmdl"})
        mask2:FollowEntity(hero, true)

        ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
      else
        SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_thanos_eg/thanos_sword.vmdl"}):FollowEntity(hero, true)
      end

    end
    if hero:GetUnitName() == "npc_dota_hero_huskar" then
      LinkLuaModifier("modifier_vader", "modifiers/modifier_vader.lua", LUA_MODIFIER_MOTION_NONE)
      hero:AddNewModifier(hero, nil, "modifier_vader", nil)
      SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_vaider/weapon/weapon.vmdl"}):FollowEntity(hero, true)
    end
    if hero:GetUnitName() == "npc_dota_hero_lich" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "medivh_soul_catcher") == true then
        local mask = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/medivh_v2/the_god_of_magic/immortal_mask.vmdl"})
        mask:FollowEntity(hero, true)

        local medivh_eyes = ParticleManager:CreateParticle( "particles/econ/items/mirana/mirana_sapphire_sabrelynx/mirana_sabrelynx_eye_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask )
        ParticleManager:SetParticleControlEnt( medivh_eyes, 0, mask, PATTACH_POINT_FOLLOW, "attach_eye_l" , mask:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( medivh_eyes, 4, mask, PATTACH_POINT_FOLLOW, "attach_eye_l" , mask:GetOrigin(), true )

        local medivh_eyes2 = ParticleManager:CreateParticle( "particles/econ/items/mirana/mirana_sapphire_sabrelynx/mirana_sabrelynx_eye_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask )
        ParticleManager:SetParticleControlEnt( medivh_eyes2, 0, mask, PATTACH_POINT_FOLLOW, "attach_eye_r" , mask:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( medivh_eyes2, 4, mask, PATTACH_POINT_FOLLOW, "attach_eye_r" , mask:GetOrigin(), true )

        local mask_amb = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, mask )
        ParticleManager:SetParticleControlEnt( mask_amb, 0, mask, PATTACH_POINT_FOLLOW, "attach_tail" , mask:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask_amb, 1, mask, PATTACH_POINT_FOLLOW, "attach_tail" , mask:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask_amb, 3, mask, PATTACH_POINT_FOLLOW, "attach_tail" , mask:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask_amb, 4, mask, PATTACH_POINT_FOLLOW, "attach_tail" , mask:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( mask_amb, 5, mask, PATTACH_POINT_FOLLOW, "attach_tail" , mask:GetOrigin(), true )
        ParticleManager:SetParticleControl( mask_amb, 6, Vector(0, 0, 0) )

        hero:SetMaterialGroup("immortal_mask")
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_phantom_lancer" then
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "odin_spear_of_fate") == true then
          local spear = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_odin/odin_spear_of_fate.vmdl"})
          spear:FollowEntity(hero, true)

          local eyes2 = ParticleManager:CreateParticle( "particles/econ/items/enchantress/enchantress_virgas/ench_virgas_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, spear )
          ParticleManager:SetParticleControlEnt( eyes2, 0, spear, PATTACH_POINT_FOLLOW, "attach_root" , spear:GetOrigin(), true )
        else
          local spear = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_odin/odin_spear.vmdl"})
          spear:FollowEntity(hero, true)
        end
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "odin_elder_scroll") == true then
          local back = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_odin/odin_elder_scroll.vmdl"})
          back:FollowEntity(hero, true)
        end
        if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "odin_odinforce") == true then
          local cape = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_odin/odin_odinforce.vmdl"})
          cape:FollowEntity(hero, true)
        end
        ---particles/econ/items/enchantress/enchantress_virgas/ench_virgas_ambient.vpcf
    end
    if hero:GetUnitName() == "npc_dota_hero_dazzle" then
      SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_joker/econs/pistol.vmdl"}):FollowEntity(hero, true)
    end
    if hero:GetUnitName() == "npc_dota_hero_dark_seer" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "out_mask") == true then
        local mask1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/silencer/the_hazhadal_magebreaker_head/the_hazhadal_magebreaker_head.vmdl"})
        mask1:FollowEntity(hero, true)
      end
    end
    if hero:GetUnitName() == "npc_dota_hero_obsidian_destroyer" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "tribunal_the_seven_evils") == true then hero:SetModelScale(0.76)  end
    end
    if hero:GetUnitName() == "npc_dota_hero_nevermore" then
      LinkLuaModifier("modifier_deadpool", "modifiers/modifier_deadpool.lua", LUA_MODIFIER_MOTION_NONE)
      hero:AddNewModifier(hero, nil, "modifier_deadpool", nil)
    end
   
    if hero:GetUnitName() == "npc_dota_hero_earth_spirit" then
      if Util:PlayerEquipedItem(hero:GetPlayerOwnerID(), "beast_arcana") then
        LinkLuaModifier("modifier_beast_arcana", "modifiers/modifier_beast_arcana.lua", LUA_MODIFIER_MOTION_NONE)
        hero:SetOriginalModel("models/heroes/hero_beast/beast_arcana_alt1.vmdl")
        hero:AddNewModifier(hero, nil, "modifier_beast_arcana", nil)
      end
    end
end

function CDOTA_BaseNPC:HasTalent(talentName)
    if self:HasAbility(talentName) then
        if self:FindAbilityByName(talentName):GetLevel() > 0 then return true end
    end
    return false
end

function CDOTA_BaseNPC:WillReflectAnySpell()
    local modifiersList = {
        "modifier_item_lotus_orb_active",
        "modifier_item_sphere_target",
        "modifier_ebonymaw_nether_shield",
        "modifier_item_orb_of_osuvox",
        "modifier_item_void_orb_active",
        "modifier_roshan_spell_block"
    }
    for _, modifier in pairs(modifiersList) do
        if self:HasModifier(modifier) then return true end
    end
    return false
end

function CDOTA_BaseNPC:IsAbilityOnCooldown(ability)
    if self:HasAbility(ability) then return not self:FindAbilityByName(ability):IsCooldownReady() end
    return nil
end

function CDOTA_Ability_Lua:IsIgnoreCooldownReduction()
    if Util.abilities[self:GetAbilityName()]["IgnoreCooldownReduction"] ~= nil then
        if Util.abilities[self:GetAbilityName()]["IgnoreCooldownReduction"] == "1" or Util.abilities[self:GetAbilityName()]["IgnoreCooldownReduction"] == 1 then
            return true
        end
    end

    return false
end

function CDOTA_BaseNPC:FindTalentValue(talentName)
    if self:HasAbility(talentName) then
        return self:FindAbilityByName(talentName):GetSpecialValueFor("value")
    end
    return nil
end

function Util:FindTalentScriptFile(talentName)
    if Util.abilities and Util.abilities[talentName] and Util.abilities[talentName]["BaseClass"] == "special_bonus_undefined" then
        return Util.abilities[talentName]["ScriptFile"]
    end

    return nil
end

function CDOTABaseAbility:GetTalentSpecialValueFor(value)
    local base = self:GetSpecialValueFor(value)
    local talentName
    local valname = "value"
    local multiply = false
    local kv = self:GetAbilityKeyValues()
    for k,v in pairs(kv) do -- trawl through keyvalues
        if k == "AbilitySpecial" then
            for l,m in pairs(v) do
                if m[value] then
                    talentName = m["LinkedSpecialBonus"]
                    if m["LinkedSpecialBonusField"] then valname = m["LinkedSpecialBonusField"] end
                    if m["LinkedSpecialBonusOperation"] and m["LinkedSpecialBonusOperation"] == "SPECIAL_BONUS_MULTIPLY" then multiply = true end
                end
            end
        end
    end
    if talentName and self:GetCaster():HasTalent(talentName) then
        if multiply then
            base = base * talent:GetSpecialValueFor(valname)
        else
            base = base + talent:GetSpecialValueFor(valname)
        end
    end
    return base
end

function CDOTA_BaseNPC:SetGodeMode(tBool)
    LinkLuaModifier( "modifier_god", "modifiers/modifier_god.lua" ,LUA_MODIFIER_MOTION_NONE )
    if tBool == "true" then
        if self:HasModifier("modifier_god") then
            self:RemoveModifierByName("modifier_god")
        end
        self:AddNewModifier(self, nil, "modifier_god", nil)
    elseif tBool == "false" then
        if self:HasModifier("modifier_god") then
            self:RemoveModifierByName("modifier_god")
        end
    end
    return
end

function CDOTA_BaseNPC:SetDemiGodeMode(tBool)
    LinkLuaModifier( "modifier_demigod", "modifiers/modifier_demigod.lua" ,LUA_MODIFIER_MOTION_NONE )
    if tBool == "true" then
        if self:HasModifier("modifier_demigod") then
            self:RemoveModifierByName("modifier_demigod")
        end
        self:AddNewModifier(self, nil, "modifier_demigod", nil)
    elseif tBool == "false" then
        if self:HasModifier("modifier_demigod") then
            self:RemoveModifierByName("modifier_demigod")
        end
    end
    return
end

function CDOTA_BaseNPC:SwapDebuffs(hTarget)
    if not hTarget then
        return
    end
    local modifiers = self:FindAllModifiers()
    for _, mod in pairs(modifiers) do
        if mod and mod:GetDuration() > 0 and (mod:IsPurgable() or mod:IsPurgeException()) then
            local dur = mod:GetRemainingTime()
            local name = mod:GetName()
            local abil = mod:GetAbility()

            hTarget:AddNewModifier(self, abil, name, {duration = dur})

            mod:Destroy()
        end
    end
    return
end

function CDOTA_BaseNPC:CanReincarnate()
    local items = {
        "item_aegis",
        "item_frostmourne"
    }
    for _, item in pairs(items) do
        if self:FindItemInInventory(item) then
            if self:FindItemInInventory(item):IsCooldownReady() then
                return true
            end
        end
    end
    return false
end

function CDOTA_BaseNPC:RefreshUnit()
    for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
        local current_ability = self:GetAbilityByIndex(i)
        if current_ability ~= nil then
            current_ability:EndCooldown()
        end
    end

    --Refresh all items the caster has.
    for i=0, 5, 1 do
        local current_item = self:GetItemInSlot(i)
        if current_item ~= nil then
            current_item:EndCooldown()
        end
    end
    self:SetHealth(self:GetMaxHealth())
    self:SetMana(self:GetMaxMana())
end


function Util:SetupConsole()
    LinkLuaModifier("modifier_storm_spirit", "modifiers/modifier_storm_spirit.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_io", "modifiers/modifier_customs.lua", LUA_MODIFIER_MOTION_NONE )

    Convars:RegisterCommand("ban", function(command, userid )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()
            if Util:PlayerHasAdminRules(pID) then
                local playerName = tostring(PlayerResource:GetPlayerName(tonumber(userid)))
                local msg =  playerName .. " left the game. (Account is untrusted)"
                GameRules:SendCustomMessage(msg, 0, 0)
                Timers:CreateTimer(15, function()
                    local res = "<font color=\"#ff0000\"> ".. playerName .." forever denied access to the official servers. (VAC ban) </font>"
                    GameRules:SendCustomMessage(res, 0, 0)

                    ---Network:BanPlayer(tonumber(userid))
                    local p = PlayerResource:GetPlayer(tonumber(userid))
                    local h = p:GetAssignedHero()

                    UTIL_Remove(h)
                    UTIL_Remove(p)
                end)
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Permanently ban a user with specific id", 0)

    Convars:RegisterCommand("clients_status", function()
        pcall(function() for i = 0, DOTA_MAX_PLAYERS do
            if PlayerResource:IsValidPlayerID(i) then
                local playerName = tostring(PlayerResource:GetPlayerName(i))
                GameRules:printd(playerName .. " as player ID: " .. i, Convars:GetCommandClient():GetPlayerID())
            end
        end end)
    end, "Print all players", 0)

    Convars:RegisterCommand("godmode", function(command, statement )
        local hero = Convars:GetCommandClient()
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            PlayerResource:GetPlayer(tonumber(Convars:GetCommandClient():GetPlayerID())):GetAssignedHero():SetGodeMode(statement)
        else
            Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
        end
    end, "Set on or off godmode", 0)

    Convars:RegisterCommand("demigod", function(command, statement )
        local hero = Convars:GetCommandClient()
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            PlayerResource:GetPlayer(tonumber(Convars:GetCommandClient():GetPlayerID())):GetAssignedHero():SetDemiGodeMode(statement)
        else
            Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
        end
    end, "Set on or off dimigod", 0)

    Convars:RegisterCommand("givegold", function(command, player, ammount )
        local pID = Convars:GetCommandClient():GetPlayerID()
        if Util:PlayerHasAdminRules(pID) then
            PlayerResource:ModifyGold(tonumber(player), tonumber(ammount), true, DOTA_ModifyGold_Unspecified)
        else
            Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
        end
    end, "Set gold", 0)

    Convars:RegisterCommand("levelup", function(command, player, ammount )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            local hero = PlayerResource:GetPlayer(tonumber(player)):GetAssignedHero()
            for i = 1, tonumber(ammount) do
                hero:HeroLevelUp(true)
            end
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Set hero level under specific id", 0)

    Convars:RegisterCommand("killallinradius", function(command, radius )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            local data = {
                radius = tonumber(radius),
                hero = Convars:GetCommandClient():entindex()
            }
            Util:KillUnitsInRadius(data)
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Kill all in radius", 0)

    Convars:RegisterCommand("killplayer", function(command, player )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            if PlayerResource:IsValidPlayerID(tonumber(player)) then
                local hero = PlayerResource:GetPlayer(tonumber(player)):GetAssignedHero()
                if hero then
                    hero:ForceKill(false)
                end
            end
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Kill player under specific pid", 0)

    Convars:RegisterCommand("giveitem", function(command, pid, item )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            if PlayerResource:IsValidPlayerID(tonumber(pid)) then
                local hero = PlayerResource:GetPlayer(tonumber(pid)):GetAssignedHero()
                local item_ = CreateItem(tostring(item), hero, hero)
                hero:AddItem(item_)
            end
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Give item for player", 0)

    Convars:RegisterCommand("giveitemtoall", function(command, item )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            local heroes = HeroList:GetAllHeroes()
            for k, unit in pairs(heroes) do
                local _item = CreateItem(tostring(item), unit, unit)
                unit:AddItem(_item)
            end
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Give item for all", 0)

    Convars:RegisterCommand("killall", function(command, item )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            local heroes = HeroList:GetAllHeroes()
            for k, unit in pairs(heroes) do
                if unit ~= hero then
                    unit:ForceKill(false)
                end
            end
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Kill all", 0)

    Convars:RegisterCommand("killallally", function(command )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            local heroes = HeroList:GetAllHeroes()
            for k, unit in pairs(heroes) do
                if unit ~= hero and unit:GetTeamNumber() == Convars:GetCommandClient():GetTeamNumber() then
                    unit:ForceKill(false)
                end
            end
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Kill all allies", 0)

    Convars:RegisterCommand("killallenemy", function(command )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            local heroes = HeroList:GetAllHeroes()
            for k, unit in pairs(heroes) do
                if unit ~= hero and unit:GetTeamNumber() ~= Convars:GetCommandClient():GetTeamNumber() then
                    unit:ForceKill(false)
                end
            end
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Kill all enemy", 0)

    Convars:RegisterCommand("refresh", function(command)
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            PlayerResource:GetPlayer(tonumber(Convars:GetCommandClient():GetPlayerID())):GetAssignedHero():RefreshUnit()
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Refresh", 0)

    Convars:RegisterCommand("createunit", function(command, name )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            PrecacheUnitByNameAsync(name, function()
                CreateUnitByName( tostring(name), Convars:GetCommandClient():GetAssignedHero():GetAbsOrigin(), true, Convars:GetCommandClient(), Convars:GetCommandClient():GetOwner(), Convars:GetCommandClient():GetTeamNumber()):SetControllableByPlayer(Convars:GetCommandClient():GetPlayerID(), false)
            end)
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Create unit", 0)

    Convars:RegisterCommand("wingame", function(command, team )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            if tonumber(team) == DOTA_TEAM_GOODGUYS then
                GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
            else
                GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
            end
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Win game", 0)


    Convars:RegisterCommand("setteam", function(command, palyer, team )
        if Util:PlayerHasAdminRules(Convars:GetCommandClient():GetPlayerID()) then
            PlayerResource:GetPlayer(tonumber(palyer)):GetAssignedHero():SetTeam(tonumber(team))
        else
            Warning("User with id as: " .. Convars:GetCommandClient():GetPlayerID() .. " is not allowed to issue this command!")
        end
    end, "Win game", 0)

    Convars:RegisterCommand("sethealth", function(command, health )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()
            if Util:PlayerHasAdminRules(pID) then
                local unit = PlayerResource:GetSelectedHeroEntity(pID)
                if unit and IsValidEntity(unit) then
                    unit:SetBaseMaxHealth(tonumber(health))
                end
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set Health of selected entitiy", 0)

    Convars:RegisterCommand("setdamage", function(command, damage )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()
            if Util:PlayerHasAdminRules(pID) then
                local unit = PlayerResource:GetSelectedHeroEntity(pID)
                if unit and IsValidEntity(unit) then
                    unit:SetBaseDamageMin(tonumber(damage))
                    unit:SetBaseDamageMax(tonumber(damage + 1))
                end
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set Health of selected entitiy", 0)

    Convars:RegisterCommand("setmagicarmor", function(command, damage )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()
            if Util:PlayerHasAdminRules(pID) then
                local unit = PlayerResource:GetSelectedHeroEntity(pID)
                if unit and IsValidEntity(unit) then
                    unit:SetBaseMagicalResistanceValue(tonumber(damage))
                end
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set Health of selected entitiy", 0)

    Convars:RegisterCommand("setagi", function(command, agility )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()
            if Util:PlayerHasAdminRules(pID) then
                local unit = PlayerResource:GetSelectedHeroEntity(pID)
                if unit and IsValidEntity(unit) then
                    unit:SetBaseAgility(tonumber(agility))
                end
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set Health of selected entitiy", 0)

    Convars:RegisterCommand("setint", function(command, int )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()
            if Util:PlayerHasAdminRules(pID) then
                local unit = PlayerResource:GetSelectedHeroEntity(pID)
                if unit and IsValidEntity(unit) then
                    unit:SetBaseIntellect(tonumber(int))
                end
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set Health of selected entitiy", 0)

    Convars:RegisterCommand("setstr", function(command, str )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()
            if Util:PlayerHasAdminRules(pID) then
                local unit = PlayerResource:GetSelectedHeroEntity(pID)
                if unit and IsValidEntity(unit) then
                    unit:SetBaseStrength(tonumber(str))
                end
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set Health of selected entitiy", 0)

    Convars:RegisterCommand("addability", function(command, ability )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()
            if Util:PlayerHasAdminRules(pID) then
                local unit = PlayerResource:GetSelectedHeroEntity(pID)
                if unit and IsValidEntity(unit) then
                    unit:AddAbility(ability)
                end
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set Health of selected entitiy", 0)

    Convars:RegisterCommand("settime", function(command, time )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()
            if Util:PlayerHasAdminRules(pID) then
                GameRules:SetTimeOfDay(tonumber(time))
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set time", 0)

    Convars:RegisterCommand("replace_hero", function(command )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()

            if PlayerResource:GetSteamAccountID(pID) == 246584391 or PlayerResource:GetSteamAccountID(pID) == 87670156 then
                PrecacheUnitByNameAsync( "npc_dota_hero_spirit_breaker", function()
                    local nHero = PlayerResource:ReplaceHeroWith(pID, "npc_dota_hero_spirit_breaker", 0, 0)
                    nHero:RespawnHero(false, false)
                end)
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set time", 0)
    Convars:RegisterCommand("replace_hero_de", function(command )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()

            if PlayerResource:GetSteamAccountID(pID) == 259404989 or PlayerResource:GetSteamAccountID(pID) == 909647964 then
                PrecacheUnitByNameAsync( "npc_dota_hero_death_eater", function()
                    local nHero = PlayerResource:ReplaceHeroWith(pID, "npc_dota_hero_death_eater", 0, 0)
                    nHero:RespawnHero(false, false)
                end)
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set time", 0)
    Convars:RegisterCommand("replace_hero_d", function(command )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()

            if PlayerResource:GetSteamAccountID(pID) == 246584391 or PlayerResource:GetSteamAccountID(pID) == 87670156 then
                PrecacheUnitByNameAsync( "npc_dota_hero_phoenix", function()
                    local nHero = PlayerResource:ReplaceHeroWith(pID, "npc_dota_hero_phoenix", 0, 0)
                    nHero:RespawnHero(false, false)
                end)
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set time", 0)
    Convars:RegisterCommand("replace_hero_s", function(command )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()

            if PlayerResource:GetSteamAccountID(pID) == 259404989 or PlayerResource:GetSteamAccountID(pID) == 909647964 or PlayerResource:GetSteamAccountID(pID) == 87670156 then
                PrecacheUnitByNameAsync( "npc_dota_hero_stormspirit", function()
                    local nHero = PlayerResource:ReplaceHeroWith(pID, "npc_dota_hero_stormspirit", 0, 0)
                    nHero:RespawnHero(false, false)
                    nHero:AddNewModifier(nHero, nil, "modifier_storm_spirit", nil)
                end)
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set time", 0)
    Convars:RegisterCommand("replace_hero_i", function(command )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()

            if PlayerResource:GetSteamAccountID(pID) == 259404989 or PlayerResource:GetSteamAccountID(pID) == 124112243 or PlayerResource:GetSteamAccountID(pID) == 87670156 then
                PrecacheUnitByNameAsync( "npc_dota_hero_io", function()
                    local nHero = PlayerResource:ReplaceHeroWith(pID, "npc_dota_hero_io", 0, 0)
                    nHero:RespawnHero(false, false)
                    nHero:AddNewModifier(nHero, nil, "modifier_io", nil)
                    nHero:FindAbilityByName("io_decay_dummy"):SetLevel(1)
                end)
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set time", 0)
    Convars:RegisterCommand("replace_hero_m", function(command )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()

            if PlayerResource:GetSteamAccountID(pID) == 909647964 or PlayerResource:GetSteamAccountID(pID) == 259404989 then
                PrecacheUnitByNameAsync( "npc_dota_hero_medusa", function()
                    local nHero = PlayerResource:ReplaceHeroWith(pID, "npc_dota_hero_medusa", 0, 0)
                    nHero:RespawnHero(false, false)
                end)
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set time", 0)
    Convars:RegisterCommand("test_get_data", function(command )
        pcall(function()
            local pID = Convars:GetCommandClient():GetPlayerID()

            if PlayerResource:GetSteamAccountID(pID) == 87670156 then
            ---stats.test()
            else
                Warning("User with id as: " .. pID .. " is not allowed to issue this command!")
            end
        end)
    end, "Set time", 0)
end


function Util:KillUnitsInRadius(data)
    local radius = data['radius']
    local hero = data['hero']
    if hero and radius then
        hero = EntIndexToHScript(hero)

        local units = FindUnitsInRadius( hero:GetTeamNumber(), hero:GetOrigin(), hero, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                unit:Kill(nil, hero)
            end
        end
    end
end

function Util:CheckGameState()
    if GameRules.Players[DOTA_TEAM_GOODGUYS] then
        local state = true
        for _, pID in pairs(GameRules.Players[DOTA_TEAM_GOODGUYS]) do
            if not PlayerResource:GetConnectionState(pID) >= DOTA_CONNECTION_STATE_DISCONNECTED then
                state = false break
            end
        end

        if state then GameRules:EndGame(DOTA_TEAM_GOODGUYS) end
    end

    if GameRules.Players[DOTA_TEAM_BADGUYS] then
        local state = true
        for _, pID in pairs(GameRules.Players[DOTA_TEAM_BADGUYS]) do
            if not PlayerResource:GetConnectionState(pID) >= DOTA_CONNECTION_STATE_DISCONNECTED then
                state = false break
            end
        end

        if state then GameRules:EndGame(DOTA_TEAM_BADGUYS) end
    end
end

function Util:GetPlayersForTeam(team)
    local result = {}
    for i = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(i) and PlayerResource:GetTeam(i) == team then
            table.insert(result, i)
        end
    end

    return result
end

function Util:GetArrayLength(array)
    local result = 0
    for k,v in pairs(array) do
        result = result + 1
    end
    return result
end

function Util:DisplayError(pID, error)
    local player = PlayerResource:GetPlayer(pid)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "dota_hud_error_message", {message=error})
    end
end

function Util:IsTableContains( table, element )
    for _, v in pairs( table ) do
        if v == element then
            return true
        end
    end

    return false
end

function Util:SendCustomMessage(data)
    CustomGameEventManager:Send_ServerToAllClients("create_custom_message", data)
end

function CDOTA_BaseNPC:SetSkillBuild(hero)
    local abilities = Util:GetHeroAbilityList()
    for i,v in ipairs(abilities[self:GetUnitName()]) do
        self:RemoveAbility(v)
    end
    for i,v in ipairs(abilities[hero]) do
        self:AddAbility(v)
    end
end

function CDOTA_BaseNPC:SetCreatureHealth(health, update_current_health)

    self:SetBaseMaxHealth(health)
    self:SetMaxHealth(health)

    if update_current_health then
        self:SetHealth(health)
    end
end

function CDOTA_BaseNPC:CreateUnit(hCaster, duration)
    local double = CreateUnitByName( self:GetUnitName(), self:GetAbsOrigin(), true, self, self:GetOwner(), hCaster:GetTeamNumber())
    double:SetControllableByPlayer(hCaster:GetPlayerID(), false)

    if self:IsHero() then
        local caster_level = self:GetLevel()
        for i = 2, caster_level do
            double:HeroLevelUp(false)
        end


        for ability_id = 0, 15 do
            local ability = double:GetAbilityByIndex(ability_id)
            if ability then
                ability:SetLevel(self:GetAbilityByIndex(ability_id):GetLevel())
                if ability:GetName() == "dormammu_tempest_double" then
                    ability:SetActivated(false)
                end
            end
        end


        for item_id = 0, 5 do
            local item_in_caster = self:GetItemInSlot(item_id)
            if item_in_caster ~= nil then
                local item_name = item_in_caster:GetName()
                local item_created = CreateItem( item_in_caster:GetName(), double, double)
                double:AddItem(item_created)
            end
        end

        double:SetMaximumGoldBounty(0)
        double:SetMinimumGoldBounty(0)
        double:SetDeathXP(0)
        double:SetAbilityPoints(0)

        double:SetHasInventory(false)
        double:SetCanSellItems(false)
    end

    double:AddNewModifier(hCaster, self, "modifier_arc_warden_tempest_double", nil)
    double:AddNewModifier(hCaster, self, "modifier_kill", {["duration"] = duration})

    FindClearSpaceForUnit(double, double:GetAbsOrigin(), false)

    return double
end


function CDOTA_BaseNPC:HasTimeStone()
    return self:HasItemInInventory("item_time")
end

function CDOTA_BaseNPC:CreateIllusion(caster, ability, duration)
    local illusion = CreateUnitByName(self:GetUnitName(), self:GetAbsOrigin(), true, caster, nil, caster:GetTeamNumber())  --handle_UnitOwner needs to be nil, or else it will crash the game.
    illusion:SetPlayerID(caster:GetPlayerOwnerID())
    illusion:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)

    --Level up the illusion to the caster's level.
    local caster_level = self:GetLevel()
    for i = 1, caster_level - 1 do
        illusion:HeroLevelUp(false)
    end

    --Set the illusion's available skill points to 0 and teach it the abilities the caster has.
    illusion:SetAbilityPoints(0)

    for ability_slot = 0, 15 do
        local individual_ability = self:GetAbilityByIndex(ability_slot)
        if individual_ability ~= nil then
            local illusion_ability = illusion:FindAbilityByName(individual_ability:GetAbilityName())
            if illusion_ability ~= nil then
                illusion_ability:SetLevel(individual_ability:GetLevel())
            end
        end
    end

    --Recreate the caster's items for the illusion.
    for item_slot = 0, 5 do
        local individual_item = self:GetItemInSlot(item_slot)
        if individual_item ~= nil then
            local illusion_duplicate_item = CreateItem(individual_item:GetName(), illusion, illusion)
            illusion:AddItem(illusion_duplicate_item)
        end
    end

    illusion:AddNewModifier(caster, ability, "modifier_illusion", {duration = duration or 8, outgoing_damage = 100, incoming_damage = 100})
    illusion:MakeIllusion()

    return illusion
end

function Util:CreateCreep(unit_name, model, caster, kv, modifiers )
    PrecacheUnitByNameAsync(model, function()
        local unit = CreateUnitByName( unit_name, caster:GetAbsOrigin(), true, caster, caster:GetOwner(), caster:GetTeamNumber())
        unit:SetControllableByPlayer(caster:GetPlayerID(), false)

        if model then
            unit:SetOriginalModel(model)
        end

        for _, mod in pairs(modifiers) do
            unit:AddNewModifier(caster, self, mod, {duration = kv["duration"]})
        end

        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)

        return unit
    end)
end

function Util:OnCosmeticItemUpdated( data )
    pcall(function()
        local hero = PlayerResource:GetPlayer(data["PlayerID"]):GetAssignedHero()

        for k,v in pairs(hero.wearables) do
            UTIL_Remove(v)
        end

        for _, particle in pairs(hero.particles) do
            ParticleManager:DestroyParticle(particle, true)
        end

        for _, modifier in pairs(hero.modifiers) do
            modifier:Destroy()
        end

        local steam_id = PlayerResource:GetSteamAccountID(data["PlayerID"])
        steam_id = tostring(steam_id)
        local items = Util:GetItemID(string)
        if GameRules.Globals.Inventories then
            if GameRules.Globals.Inventories[steam_id] then
                for _, item in pairs(GameRules.Globals.Inventories[steam_id]) do
                    if item["id"] == tostring(data["item"]) then
                        local state = 1
                        if data["isRemove"] == 1 then
                            state = 0
                        end
                        item["state"] = tostring(state)
                        break
                    end
                end

                Util:UpdateWearables(hero, hero:GetPlayerOwnerID())
            end
        end
    end)
end


function Util:vector_unit( vector )
    local mag = Util:vector_magnitude(vector)
    return Vector(vector.x/math.sqrt(mag), vector.y/math.sqrt(mag))
end

function Util:vector_magnitude( vector )
    return vector.x * vector.x + vector.y * vector.y
end

function Util:vector_is_clockwise(v1, v2)
    return -v1.x * v2.y + v1.y * v2.x > 0
end

function CDOTA_Item:IsDroppableAfterDeath()
    if Util.items and Util.items[self:GetName()] and Util.items[self:GetName()]["DropOnDeath"] then
        return true
    end
    return false
end

function CDOTA_Modifier_Lua:GetClass()
    return "CDOTA_Modifier_Lua"
end

function CDOTA_Buff:IsDebuff()
    return string.find(self:GetClass(), "debuff") ~= nil or string.find(self:GetClass(), "stun") ~= nil
end

function CDOTA_Buff:IsPermanent()
    return self:GetDuration() <= 0
end

function Util:OnAbilityWasUpgraded( ability, unit ) end

function Util:OnModifierWasApplied( ability, unit, caster, modifier )
    if unit:HasModifier("modifier_fate_fatebind") and ability and caster ~= unit then
        local mod = unit:FindModifierByName("modifier_fate_fatebind")
        mod:OnModifierApplied({ability = ability, unit = unit, attacker = caster, modifier_name = modifier})
    end
end

function Util:LearnedAbility( params )
    if params.abilityname and params.PlayerID and string.find(params.abilityname, "special_bonus") ~= nil then
        Talents:OnTalentLearned(params.PlayerID, params.abilityname)
    end
end

function CDOTA_BaseNPC:Heal_Engine(flHeal)
    self:ModifyHealth(self:GetHealth() + flHeal, nil, false, 0)
end

function CDOTABaseAbility:IsUltimate() return self:GetMaxLevel() <= 3 end

function PopupNumbers(target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target) -- target:GetOwner()

    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end

function Util:OnGauntletAbilitySelected( params )
    local hero = EntIndexToHScript(params.hero)

    local item = hero:FindItemInInventory("item_glove_of_the_creator")
    if item then item:SelectAbility(params.ability) end
end

function CDOTAGamerules:EndGame(team)
    local ancients = Entities:FindAllByClassname("npc_dota_fort")
    for _, ancient in pairs(ancients) do
        if (ancient:GetTeamNumber() == team) then ancient:ForceKill(false) return end
    end
end

function CDOTA_BaseNPC:GetPhysicalArmorReduction()
    local armornpc = self:GetPhysicalArmorValue( false )
    local armor_reduction = 1 - (0.06 * armornpc) / (1 + (0.06 * math.abs(armornpc)))
    armor_reduction = 100 - (armor_reduction * 100)
    return armor_reduction
end

function CDOTA_BaseNPC:GetTarget()
    local unit

    if IsServer() then
        local units = FindUnitsInRadius( self:GetTeamNumber(), self:GetOrigin(), self, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
        if #units > 0 then
            unit = units[1]
        end
    end

    return unit;
end


function CDOTA_BaseNPC:IsHasSuperStatus()
    local data = CustomNetTables:GetTableValue("players", "stats")
    local pID = self:GetPlayerOwnerID()

    if data and data[tostring(pID)] then
        return data[tostring(pID)].shards == "1"
    end

    return false
end

function Util:Setup()

end

function CDOTA_BaseNPC:GetBasePos()
    local ancients = Entities:FindAllByClassname("ent_dota_fountain")

    for k, ancient in pairs(ancients) do
        if ancient:GetTeamNumber() == self:GetTeamNumber() then return ancient:GetAbsOrigin() end
    end

    return self:GetAbsOrigin()
end

function CDOTA_BaseNPC:IsFriendly(target)
    return target:GetTeamNumber() == self:GetTeamNumber()
end

function CDOTA_BaseNPC:GetCooldownTimeAfterReduction(cooldown)
    local cooldown_reduction = 1

    for _, mod in pairs(self:FindAllModifiers()) do
        pcall(function()
            if mod:HasFunction(MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE) then
                cooldown_reduction = cooldown_reduction * (1 - mod:GetModifierPercentageCooldown() / 100)
            end
            if mod:HasFunction(MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING) then
                cooldown_reduction = cooldown_reduction * (1 - mod:GetModifierPercentageCooldownStacking() / 100)
            end
        end)
    end

    return cooldown_reduction * cooldown
end

function AddNewModifier_pcall(target, caster, ability, modifierName, properties)
    if target:IsNull() or not target then Warning("[AddNewModifier_pcall] utils.lua - target nullptr exeption") return end

    return target:AddNewModifier(caster, ability, modifierName, properties)
end

function WaitForNextFrame(fnc)
    Timers:CreateTimer(0, fnc)
end

function SetObjectHidden( ubj, hidden )
    if hidden == true then
        ubj:AddEffects(EF_NODRAW)
    else
        ubj:RemoveEffects(EF_NODRAW)
    end
end


function Util:OnDamageWasApplied(data)
    if data.entindex_inflictor_const ~= nil then
        local inflictor = EntIndexToHScript(data.entindex_inflictor_const)

        if inflictor and not inflictor:IsNull() and inflictor:GetName() == "wisp_spirits" then
            local target = EntIndexToHScript(data.entindex_victim_const)
            local caster = EntIndexToHScript(data.entindex_attacker_const)

            if target and caster and not caster:IsNull() and not target:IsNull() and caster:HasTalent("special_bonus_unique_wist_str") then
                local ability = caster:FindAbilityByName("io_decay_dummy")

                if ability and not ability:IsNull() then
                    caster:SetCursorPosition(target:GetAbsOrigin())
                    ability:OnSpellStart()
                end
            end
        end
    end
end
