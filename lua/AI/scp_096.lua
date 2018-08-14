require( "ai/ai_core" )

LinkLuaModifier("modifier_statue","modifiers/modifier_statue.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shy","modifiers/modifier_shy.lua", LUA_MODIFIER_MOTION_NONE)

function Spawn( entityKeyValues )
    thisEntity:SetContextThink( "AIThink", AIThink, 1 )
    thisEntity.hasTarget = nil
    thisEntity.isAgred = nil
    
    Timers:CreateTimer(20, function()
        StartSoundEvent("SCP.096_Idle", thisEntity)
    end)

    print("Spawn")
end

function AIThink() 
    local units = AICore:GetAllUnitsInRange( thisEntity, 1000 )
    if not units or #units == 0 then return 1 end Aggr(units[1]) return nil
end

function Aggr(unit)
    StopSoundEvent("SCP.096_Idle", thisEntity)
    thisEntity:AddNewModifier(thisEntity, nil, "modifier_statue", nil)
    thisEntity:AddNewModifier(thisEntity, nil, "modifier_shy", nil)
    
    unit:AddNewModifier(unit, nil, "modifier_truesight", {duration = 30})

    StartSoundEvent("SCP.096_Alert", thisEntity)
    thisEntity:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    Timers:CreateTimer(5.22, function()
        thisEntity:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
        thisEntity:StartGesture(ACT_DOTA_CHANNEL_ABILITY_1)
    end)

    Timers:CreateTimer(35, function()
        thisEntity:RemoveGesture(ACT_DOTA_CHANNEL_ABILITY_1)
        StopSoundEvent("SCP.096_Alert", thisEntity)

        StartSoundEvent("SCP.096_Agr", thisEntity)

        thisEntity:RemoveModifierByName("modifier_statue")

        thisEntity.hasTarget = unit

        thisEntity:MoveToTargetToAttack(unit)

        thisEntity:SetForceAttackTarget(unit)

        thisEntity.isAgred = true
    end)

    Timers:CreateTimer(36, function( )
        if not thisEntity.hasTarget or not thisEntity.hasTarget:IsAlive() then
            thisEntity:SetForceAttackTarget(nil) return nil
        else 
            if thisEntity.hasTarget:HasModifier("modifier_smoke_of_deceit") then thisEntity.hasTarget:RemoveModifierByName("modifier_smoke_of_deceit") end 
            thisEntity:SetForceAttackTarget(thisEntity.hasTarget)
        end 

        return 1
    end)
end
