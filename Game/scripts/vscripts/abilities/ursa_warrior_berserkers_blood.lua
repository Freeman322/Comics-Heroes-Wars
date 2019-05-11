LinkLuaModifier("modifier_ursa_warrior_berserkers_blood", "abilities/ursa_warrior_berserkers_blood.lua", 0)

ursa_warrior_berserkers_blood = class({})
function ursa_warrior_berserkers_blood:GetIntrinsicModifierName() return "modifier_ursa_warrior_berserkers_blood" end

modifier_ursa_warrior_berserkers_blood = class({})
function modifier_ursa_warrior_berserkers_blood:IsHidden() return true end
function modifier_ursa_warrior_berserkers_blood:IsPurgable() return false end
function modifier_ursa_warrior_berserkers_blood:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT} end
function modifier_ursa_warrior_berserkers_blood:GetModifierAttackSpeedBonus_Constant() return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("attack_speed") end
function modifier_ursa_warrior_berserkers_blood:GetModifierBaseAttackTimeConstant()	return self:GetAbility():GetSpecialValueFor("base_attack_time") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_ursa_warrior_3") or 0) end
