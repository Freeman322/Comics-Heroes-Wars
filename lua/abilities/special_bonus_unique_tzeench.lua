if special_bonus_unique_tzeench == nil then special_bonus_unique_tzeench = class({}) end
LinkLuaModifier ("modifier_special_bonus_unique_tzeench", "heroes/hero_tzeentch/special_bonus_unique_tzeench.lua", LUA_MODIFIER_MOTION_NONE)

function special_bonus_unique_tzeench:GetIntrinsicModifierName()
	return "modifier_special_bonus_unique_tzeench"
end

if modifier_special_bonus_unique_tzeench == nil then modifier_special_bonus_unique_tzeench = class({}) end

function modifier_special_bonus_unique_tzeench:IsHidden()
	return true
end

function modifier_special_bonus_unique_tzeench:IsPurgable()
	return false
end

function modifier_special_bonus_unique_tzeench:RemoveOnDeath()
	return false
end

function special_bonus_unique_tzeench:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

