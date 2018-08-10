require( "ai/ai_core" )

LinkLuaModifier("modifier_statue","modifiers/modifier_statue.lua", LUA_MODIFIER_MOTION_NONE)

function Spawn( entityKeyValues )
    thisEntity:SetContextThink( "AIThink", AIThink, 1 )
    thisEntity.hasTarget = nil
    thisEntity.isAgred = nil
    
    StartSoundEvent("SCP.096_Idle", thisEntity)

    print("Spawn")

    Timers:CreateTimer(1, function()
        if thisEntity.hasTarget and thisEntity.hasTarget:IsAlive() then 
            thisEntity:SetForceAttackTarget(thisEntity.hasTarget)
        elseif thisEntity.isAgred and not thisEntity.hasTarget then 
            thisEntity:SetForceAttackTarget(nil)

            return nil
        end 

        return 1
    end)
end

function AIThink() 
    if thisEntity:GetHealth() < thisEntity:GetMaxHealth() then 
        StopSoundEvent("SCP.096_Idle", thisEntity)
        thisEntity:AddNewModifier(thisEntity, nil, "modifier_statue", nil)
        Aggr()
        return nil
    end 

    return 1
end

function Aggr()
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

        thisEntity.hasTarget = AICore:ClosestEnemyHeroInRange( thisEntity, 250000 )

        thisEntity:MoveToTargetToAttack(thisEntity.hasTarget)

        thisEntity.isAgred = true
    end)
end
