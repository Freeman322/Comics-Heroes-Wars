--------HERO LUA FILE FOR RESPONCES AND BEHAVOR--------------
function Spawn( entityKeyValues )
    if IsServer() then 
        --[[if not Responses.started then Responses:Start() end
        Responses:RegisterUnit("npc_dota_hero_savitar", "scripts/responses/savitar.kv")]]--
    end
end
