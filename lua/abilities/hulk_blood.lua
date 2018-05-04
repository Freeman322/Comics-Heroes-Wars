LinkLuaModifier("modifier_hulk_blood", "abilities/hulk_blood.lua", LUA_MODIFIER_MOTION_NONE)
if hulk_blood == nil then hulk_blood = class({}) end

function hulk_blood:GetIntrinsicModifierName()
   return "modifier_hulk_blood"
end

if modifier_hulk_blood == nil then modifier_hulk_blood = class({}) end

function modifier_hulk_blood:IsHidden()
   return true
end

function modifier_hulk_blood:IsPurgable()
   return false
end

function modifier_hulk_blood:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function modifier_hulk_blood:GetModifierAttackSpeedBonus_Constant( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("attack_speed") 
end
function modifier_hulk_blood:GetModifierHPRegenAmplify_Percentage( params )
	local amplify = (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("heal_amplify")
	return amplify 
end
function modifier_hulk_blood:GetModifierMPRegenAmplify_Percentage( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("mana_amplify")
end