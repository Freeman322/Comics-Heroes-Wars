require( "ai/ai_core" )
LinkLuaModifier("modifier_dummy","modifiers/modifier_dummy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_statue","modifiers/modifier_statue.lua", LUA_MODIFIER_MOTION_NONE)

local iCone = 0.08715 
local vCenter = Vector( 706.149, 3112.51, 235.403 )

function Spawn( entityKeyValues )
    thisEntity:SetContextThink( "AIThink", AIThink, 0.1 )
    thisEntity._iTimer = 0
    if IsServer() then
        thisEntity:AddNewModifier(thisEntity, nil, "modifier_statue", nil)

		TeleportToPostion(vCenter)
    end   
end

function AIThink()     
    thisEntity._iTimer = (thisEntity._iTimer or 0) + 0.1 
    if thisEntity._iTimer >= 10 and NotSeen() then 
        TeleportToPostion(vCenter + RandomVector(1) * RandomFloat(0, 10000))
        thisEntity._iTimer = 0
    end 
    NotSeen()

    return 0.1
end

function TeleportToPostion(loc)
    thisEntity:SetAbsOrigin(loc) 
    FindClearSpaceForUnit(thisEntity, loc, true)

    if RollPercentage(5) then 
        AddFOWViewer(2, loc, 40, 10, false)
    end
end

function NotSeen()
    local units = AICore:GetAllUnitsInRange( thisEntity, 700 )
    if not units or #units == 0 then return true end

    if IsNobodySeeSculpture(units) then local unit = AICore:ClosestEnemyHeroInRange( thisEntity, 700 ) EmitSoundOn("SCP.173_Kill", unit) thisEntity:SetAbsOrigin(unit:GetAbsOrigin()) unit:Kill(nil, thisEntity) return false end
    local unit = AICore:ClosestEnemyHeroInRange( thisEntity, 700 )
    if unit and not unit:HasModifier("modifier_dummy") then EmitSoundOn("SCP.173_Encounter", unit) unit:AddNewModifier(unit, nil, "modifier_dummy", {duration = 5}) end 
end

function IsUnitLooksOnSculpture( unit )

end

function IsNobodySeeSculpture(units)
    for _, unit in pairs(units) do
        local distToSCP = (thisEntity:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized()
        local unit_dir = unit:GetForwardVector() 
        if distToSCP:Dot(unit_dir) > math.cos(2.44346) then
            return false  
        end 
    end
    return true
end 