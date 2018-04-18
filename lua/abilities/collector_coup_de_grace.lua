LinkLuaModifier ("modifier_collector_coup_de_grace", "abilities/collector_coup_de_grace.lua" , LUA_MODIFIER_MOTION_NONE)

if collector_coup_de_grace == nil then
    collector_coup_de_grace = class({})
end

function collector_coup_de_grace:GetIntrinsicModifierName ()
    return "modifier_collector_coup_de_grace"
end


if modifier_collector_coup_de_grace == nil then
    modifier_collector_coup_de_grace = class ( {})
end

function modifier_collector_coup_de_grace:IsHidden ()
    return true
end

function modifier_collector_coup_de_grace:IsPurgable()
    return false
end

function modifier_collector_coup_de_grace:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_HERO_KILLED
    }

    return funcs
end

function modifier_collector_coup_de_grace:GetModifierPreAttack_CriticalStrike(params)
    if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
        return self:GetAbility():GetSpecialValueFor("crit_bonus")
    end
    return
end

function modifier_collector_coup_de_grace:OnHeroKilled(params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            self:GetParent():ModifyIntellect(2)
            self:GetParent():CalculateStatBonus()
        end
    end
    return 0
end

function collector_coup_de_grace:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

