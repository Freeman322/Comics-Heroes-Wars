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
    return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end

function modifier_deadpool_heart:IsHidden ()
    return false
end

function modifier_deadpool_heart:IsPurgable()
    return false
end

function modifier_deadpool_heart:OnCreated(table)
    if IsServer() then
        self.stacks = 0
        if self:GetCaster():HasModifier("modifier_deadpool") then
            local mod = self:GetCaster():FindModifierByName("modifier_deadpool")
            self.stacks = mod:GetStackCount()
        end
    end
end

function modifier_deadpool_heart:GetModifierHealthRegenPercentage()
    local regen = self:GetAbility():GetSpecialValueFor("health_regen_base") + (self.stacks or 1) + ((self:GetAbility ():GetSpecialValueFor ("health_regen_percent_per_second")) * (GameRules:GetGameTime() / 420))
    if regen > 400 then regen = 400 end 
    
    return regen
end

function deadpool_heart:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_neo_noir") then return "custom/the_old_facion_heal" end
    return self.BaseClass.GetAbilityTextureName(self) 
end
  
