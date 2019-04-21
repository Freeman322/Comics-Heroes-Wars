item_flash_boots = class ({})

LinkLuaModifier ("modifier_item_flash_boots", "items/item_flash_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_flash_boots_active", "items/item_flash_boots", LUA_MODIFIER_MOTION_NONE)

function item_flash_boots:GetIntrinsicModifierName ()
	return "modifier_item_flash_boots"
end

function item_flash_boots:OnSpellStart()
	local duration = self:GetSpecialValueFor("active_duration")
	self:GetCaster():AddNewModifier (self:GetCaster (), self, "modifier_item_flash_boots_active", {duration = duration})

	EmitSoundOn("Hero_Rubick.NullField.Offense", self:GetCaster())
	EmitSoundOn("Hero_Rubick.NullField.Defense", self:GetCaster())
end

modifier_item_flash_boots = class ({})

function modifier_item_flash_boots:IsHidden()
	return true
end

function modifier_item_flash_boots:DeclareFunctions()
	local stats =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_MAX
		}
	return stats
end

function modifier_item_flash_boots:GetModifierMoveSpeedBonus_Constant()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_speed")
end

function modifier_item_flash_boots:GetModifierPreAttack_BonusDamage()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_flash_boots:GetModifierBonusStats_Strength()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_flash_boots:GetModifierBonusStats_Agility()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_flash_boots:GetModifierBonusStats_Intellect()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_flash_boots:GetModifierConstantHealthRegen()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("health_regen")
end

function modifier_item_flash_boots:GetModifierMoveSpeed_Max()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("max_move_speed")
end

modifier_item_flash_boots_active = class ({})

function modifier_item_flash_boots_active:IsBuff()
	return true
end


function modifier_item_flash_boots_active:GetEffectName()
    return "particles/units/heroes/hero_rubick/rubick_fade_bolt_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_flash_boots_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_item_flash_boots_active:IsHidden()
	return false
end

function modifier_item_flash_boots_active:IsPurgable()
	return true
end

function modifier_item_flash_boots_active:DeclareFunctions()
	stats1 =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return stats1
end

function modifier_item_flash_boots_active:GetModifierMoveSpeedBonus_Constant()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("active_speed")
end

function modifier_item_flash_boots_active:CheckState()
	local state = 
	{
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
	return state
end