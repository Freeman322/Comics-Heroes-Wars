LinkLuaModifier( "black_flash_speedforce_aura_thinker", "abilities/black_flash_speedforce_aura.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_black_flash_speedforce_aura", "abilities/black_flash_speedforce_aura.lua",LUA_MODIFIER_MOTION_NONE )
black_flash_speedforce_aura = class({})

function black_flash_speedforce_aura:GetIntrinsicModifierName()
	return "black_flash_speedforce_aura_thinker"
end

black_flash_speedforce_aura_thinker = class({})

function black_flash_speedforce_aura_thinker:IsAura()
	return true
end

function black_flash_speedforce_aura_thinker:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function black_flash_speedforce_aura_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function black_flash_speedforce_aura_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function black_flash_speedforce_aura_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function black_flash_speedforce_aura_thinker:GetModifierAura()
	return "modifier_black_flash_speedforce_aura"
end

modifier_black_flash_speedforce_aura = class({})

function modifier_black_flash_speedforce_aura:IsBuff()
	return true
end

function modifier_black_flash_speedforce_aura:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_black_flash_speedforce_aura:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("aura_speed")*(-1)
end

function modifier_black_flash_speedforce_aura:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("aura_speed")*(-1)
end

function black_flash_speedforce_aura:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

