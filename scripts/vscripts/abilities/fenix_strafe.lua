if fenix_strafe == nil then fenix_strafe = class({}) end

LinkLuaModifier("modifier_fenix_strafe", "abilities/fenix_strafe.lua", LUA_MODIFIER_MOTION_NONE) --- PATH WERY IMPORTANT

function fenix_strafe:GetIntrinsicModifierName()
    return "modifier_fenix_strafe"
end

if modifier_fenix_strafe == nil then modifier_fenix_strafe = class({}) end

function modifier_fenix_strafe:IsHidden()
	return true
end

function modifier_fenix_strafe:IsPurgable()
	return false
end

function modifier_fenix_strafe:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
  }
	return funcs
end

function modifier_fenix_strafe:GetModifierAttackSpeedBonus_Constant( params )
    return self:GetAbility():GetSpecialValueFor( "attack_speed_bonus_pct" )
end

function fenix_strafe:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

