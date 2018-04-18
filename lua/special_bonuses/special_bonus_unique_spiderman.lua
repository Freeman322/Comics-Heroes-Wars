LinkLuaModifier( "modifier_special_bonus_unique_spiderman", "special_bonuses/special_bonus_unique_spiderman.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_unique_spiderman == nil then special_bonus_unique_spiderman = class({}) end

function special_bonus_unique_spiderman:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_spiderman", nil)
end

if modifier_special_bonus_unique_spiderman == nil then modifier_special_bonus_unique_spiderman = class({}) end

function modifier_special_bonus_unique_spiderman:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_unique_spiderman:IsPurgable()
	return false
end

function modifier_special_bonus_unique_spiderman:RemoveOnDeath()
	return false
end
