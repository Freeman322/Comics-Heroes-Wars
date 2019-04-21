deadpool_heart = class ( {})

LinkLuaModifier ("modifier_deadpool_heart", "abilities/deadpool_heart.lua", LUA_MODIFIER_MOTION_NONE)

function deadpool_heart:GetIntrinsicModifierName ()
    return "modifier_deadpool_heart"
end

function deadpool_heart:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function deadpool_heart:GetCooldown (nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end

modifier_deadpool_heart = class ( {})


function modifier_deadpool_heart:DeclareFunctions ()
    return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
end

function modifier_deadpool_heart:IsHidden ()
    return false
end

function modifier_deadpool_heart:IsPurgable()
    return false
end


function modifier_deadpool_heart:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetSpecialValueFor("health_regen_percent")
end

function deadpool_heart:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("health_regen_base")
end
  
