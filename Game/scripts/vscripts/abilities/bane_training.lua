LinkLuaModifier("modifier_bane_training", "abilities/bane_training.lua", 0)

bane_training = class({GetIntrinsicModifierName = function() return "modifier_bane_training" end})

modifier_bane_training = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_EVENT_ON_HERO_KILLED} end
})
function modifier_bane_training:GetModifierBonusStats_Strength() return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_bane_training:OnHeroKilled(params)
    if IsServer() then
        local distance = (self:GetCaster():GetAbsOrigin() - params.target:GetAbsOrigin()):Length2D()
        if distance <= self:GetAbility():GetSpecialValueFor("death_radius") and params.target:GetTeam() ~= self:GetCaster():GetTeam() then
            self:IncrementStackCount()
        end
    end
end
