LinkLuaModifier("modifier_wolverine_berserk", "abilities/wolverine_berserk.lua", LUA_MODIFIER_MOTION_NONE)
if wolverine_berserk == nil then wolverine_berserk = class({}) end

function wolverine_berserk:GetIntrinsicModifierName()
   return "modifier_wolverine_berserk"
end

if modifier_wolverine_berserk == nil then modifier_wolverine_berserk = class({}) end
	
function modifier_wolverine_berserk:IsHidden()
   return true
end

function modifier_wolverine_berserk:IsPurgable()
   return false
end

function modifier_wolverine_berserk:GetEffectName()
    return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf"
end 


function modifier_wolverine_berserk:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_wolverine_berserk:GetModifierAttackSpeedBonus_Constant( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("attack_speed") 
end
function modifier_wolverine_berserk:GetModifierHPRegenAmplify_Percentage( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("heal_amplify") 
end
function modifier_wolverine_berserk:GetModifierPreAttack_BonusDamage( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("damage_amplify") 
 end
function modifier_wolverine_berserk:GetModifierPhysicalArmorBonus( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("armor_amplify") 
end
function modifier_wolverine_berserk:GetModifierMagicalResistanceBonus( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("magical_resistance_amplify") 
end