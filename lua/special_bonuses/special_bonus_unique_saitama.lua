LinkLuaModifier( "modifier_special_bonus_unique_saitama", "special_bonuses/special_bonus_unique_saitama.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_unique_saitama == nil then special_bonus_unique_saitama = class({}) end

function special_bonus_unique_saitama:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_saitama", nil)
end

if modifier_special_bonus_unique_saitama == nil then modifier_special_bonus_unique_saitama = class({}) end

function modifier_special_bonus_unique_saitama:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_unique_saitama:IsPurgable()
	return false
end

function modifier_special_bonus_unique_saitama:RemoveOnDeath()
	return false
end

