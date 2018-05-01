if Event == nil then Event = class({}) end 

function Event:_init()
    if IsServer() then 
        GameRules:GetGameModeEntity():SetContextThink("Think", Event, 0.1)
    end 
end

function Event:Think()
    
end