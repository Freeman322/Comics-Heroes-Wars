LinkLuaModifier ("modifier_tribunal_crit", "abilities/tribunal_crit.lua", LUA_MODIFIER_MOTION_NONE)

tribunal_crit = class ( {})

function tribunal_crit:GetIntrinsicModifierName() return "modifier_tribunal_crit"end

modifier_tribunal_crit = class({})

function modifier_tribunal_crit:IsHidden() return true end
function modifier_tribunal_crit:IsPurgable() return false end
function modifier_tribunal_crit:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end

function modifier_tribunal_crit:GetModifierPreAttack_CriticalStrike()
    if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
        return self:GetAbility():GetSpecialValueFor("crit_bonus")
    end

    return
end
