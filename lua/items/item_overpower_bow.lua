LinkLuaModifier ("modifier_item_overpower_bow","items/item_overpower_bow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_overpower_bow_active","items/item_overpower_bow.lua",LUA_MODIFIER_MOTION_NONE)

if item_overpower_bow == nil then item_overpower_bow = class({}) end

function item_overpower_bow:GetIntrinsicModifierName() 	return "modifier_item_overpower_bow" end

function item_overpower_bow:OnSpellStart()
    local duration = self:GetSpecialValueFor ("active_attack_speed_duration")
    self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_overpower_bow_active", { duration = duration } )
end

if modifier_item_overpower_bow == nil then modifier_item_overpower_bow = class ({}) end

function modifier_item_overpower_bow:IsHidden() return true end

function modifier_item_overpower_bow:DeclareFunctions ()
	local stats = 
		{
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_EVASION_CONSTANT,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
		}
	return stats
end

function modifier_item_overpower_bow:GetModifierPreAttack_BonusDamage()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_overpower_bow:GetModifierBonusStats_Strength()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_overpower_bow:GetModifierBonusStats_Agility()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_overpower_bow:GetModifierBonusStats_Intellect()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_overpower_bow:GetModifierAttackSpeedBonus_Constant()
	local hAbility = self:GetAbility()
	return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_overpower_bow:GetModifierConstantHealthRegen()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_health_regen")
end
function modifier_item_overpower_bow:GetModifierConstantManaRegen()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end
function modifier_item_overpower_bow:GetModifierEvasion_Constant()
	local hAbility = self:GetAbility()
 	return hAbility:GetSpecialValueFor ("bonus_evasion")
end
function modifier_item_overpower_bow:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor ("bonus_attack_range")
	else
		return 0
	end
end

if modifier_item_overpower_bow_active == nil then modifier_item_overpower_bow_active = class ({}) end

function modifier_item_overpower_bow_active:IsBuff()
	return true
end
function modifier_item_overpower_bow_active:IsPurgable()
	return true
end

function modifier_item_overpower_bow_active:DeclareFunctions()
	local stats1 = 
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
	return stats1
end

function modifier_item_overpower_bow_active:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor ("active_attack_speed")
end

--The End