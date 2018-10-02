--------HERO LUA FILE FOR RESPONCES AND BEHAVOR--------------

function Spawn( entityKeyValues )
    thisEntity:SetContextThink( "AIThink", AIThink, 1 )
end

function AIThink()
    ---print(thisEntity:GetUnitName())

    return 1
end
