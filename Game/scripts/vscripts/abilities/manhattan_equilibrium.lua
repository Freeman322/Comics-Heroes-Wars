LinkLuaModifier("modifier_manhattan_equilibrium", "abilities/manhattan_equilibrium.lua", 0)

manhattan_equilibrium = class({ GetIntrinsicModifierName = function() return "modifier_manhattan_equilibrium" end })
function manhattan_equilibrium:GetManaCost(iLevel) return self:GetCaster():GetMaxMana() / 100 * self:GetSpecialValueFor("mana_burn_pct") end
function manhattan_equilibrium:OnSpellStart() EmitSoundOn("Hero_ObsidianDestroyer.Equilibrium.Cast", self:GetCaster()) end

modifier_manhattan_equilibrium = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE} end
})

function modifier_manhattan_equilibrium:GetModifierHealthRegenPercentage() return (100 - self:GetParent():GetMana() / self:GetParent():GetMaxMana() * 100) * self:GetAbility():GetSpecialValueFor("hp_per_mana") end
function modifier_manhattan_equilibrium:GetModifierTotalPercentageManaRegen() return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("mana_per_hp") end
