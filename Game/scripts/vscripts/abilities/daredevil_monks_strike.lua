if daredevil_monks_strike == nil then daredevil_monks_strike = class({}) end
LinkLuaModifier("modifier_daredevil_monks_strike", 			"abilities/daredevil_monks_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_daredevil_monks_strike_slow", "abilities/daredevil_monks_strike.lua", LUA_MODIFIER_MOTION_NONE)

function daredevil_monks_strike:GetIntrinsicModifierName()
	return "modifier_daredevil_monks_strike"
end

if modifier_daredevil_monks_strike == nil then modifier_daredevil_monks_strike = class({}) end

function modifier_daredevil_monks_strike:IsHidden()
	return true
end

function modifier_daredevil_monks_strike:IsPurgable()
	return false
end

function modifier_daredevil_monks_strike:RemoveOnDeath()
	return true
end

function modifier_daredevil_monks_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_daredevil_monks_strike:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_daredevil_monks_strike_slow", {duration = self:GetAbility():GetSpecialValueFor("duration")})
		end
	end
end

if modifier_daredevil_monks_strike_slow == nil then modifier_daredevil_monks_strike_slow = class({}) end

function modifier_daredevil_monks_strike_slow:IsHidden()
	return false
end

function modifier_daredevil_monks_strike_slow:GetStatusEffectName()
	return "particles/hero_daredevil/daredevil_wing_chun.vpcf"
end

function modifier_daredevil_monks_strike_slow:StatusEffectPriority()
	return 1000
end

function modifier_daredevil_monks_strike_slow:IsPurgable()
	return false
end

function modifier_daredevil_monks_strike_slow:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT

    }

    return funcs
end

function modifier_daredevil_monks_strike_slow:GetModifierMoveSpeedBonus_Percentage (params)
    return self:GetAbility():GetSpecialValueFor("movespeed_slow")
end

function modifier_daredevil_monks_strike_slow:GetModifierAttackSpeedBonus_Constant (params)
    return self:GetAbility():GetSpecialValueFor("attack_speed")
end

function daredevil_monks_strike:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

