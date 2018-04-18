LinkLuaModifier( "modifier_special_bonus_unique_byonder", "special_bonuses/special_bonus_unique_byonder.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_unique_byonder == nil then special_bonus_unique_byonder = class({}) end

function special_bonus_unique_byonder:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_byonder", nil)
end

if modifier_special_bonus_unique_byonder == nil then modifier_special_bonus_unique_byonder = class({}) end

function modifier_special_bonus_unique_byonder:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_unique_byonder:IsPurgable()
	return false
end

function modifier_special_bonus_unique_byonder:RemoveOnDeath()
	return false
end

