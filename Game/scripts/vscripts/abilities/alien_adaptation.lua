LinkLuaModifier("modifier_alien_adaptation", "abilities/alien_adaptation.lua", 0)
alien_adaptation = class({GetIntrinsicModifierName = function() return "modifier_alien_adaptation" end})
modifier_alien_adaptation = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
})

function modifier_alien_adaptation:GetModifierPhysicalArmorBonus() return self:GetCaster():GetLevel() end
function modifier_alien_adaptation:GetModifierMagicalResistanceBonus() return self:GetCaster():GetLevel() end
