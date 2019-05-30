LinkLuaModifier("modifier_bane_inject", "abilities/bane_inject.lua", 0)

bane_inject = class({GetIntrinsicModifierName = function() return "modifier_bane_inject" end})
modifier_bane_inject = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
})

function modifier_bane_inject:OnAbilityFullyCast(params)
    if params.unit == self:GetParent() and params.ability:GetAbilityName() == "bane_venom" then
        self:GetCaster():Heal(self:GetCaster():GetMaxHealth() / 100 * self:GetAbility():GetSpecialValueFor("heal"), self:GetCaster())
    end
end
