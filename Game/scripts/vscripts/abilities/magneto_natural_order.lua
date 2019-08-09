LinkLuaModifier("modifier_magneto_natural_order", "abilities/magneto_natural_order.lua", 0)
LinkLuaModifier("modifier_magneto_natural_order_debuff", "abilities/magneto_natural_order.lua", 0)

magneto_natural_order = class({GetIntrinsicModifierName = function() return "modifier_magneto_natural_order" end})
modifier_magneto_natural_order = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    IsAura = function() return true end,
    GetModifierAura = function() return "modifier_magneto_natural_order_debuff" end
})

function modifier_magneto_natural_order:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function modifier_magneto_natural_order:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function modifier_magneto_natural_order:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function modifier_magneto_natural_order:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end

modifier_magneto_natural_order_debuff = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end,
    GetEffectName = function() return "particles/units/heroes/hero_elder_titan/elder_titan_natural_order_physical.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end
})

function modifier_magneto_natural_order_debuff:OnCreated() if IsServer() then if self:GetParent():GetPhysicalArmorValue(false) > 0 then self.armor_red = self:GetParent():GetPhysicalArmorValue(false) * (self:GetAbility():GetSpecialValueFor("armor_reduction_pct") * 0.01) * -1 end end end
function modifier_magneto_natural_order_debuff:GetModifierPhysicalArmorBonus() return self.armor_red end
function modifier_magneto_natural_order_debuff:GetModifierMagicalResistanceBonus() return self:GetAbility():GetSpecialValueFor("magic_resistance_pct") * -1 end
