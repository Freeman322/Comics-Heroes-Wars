LinkLuaModifier( "modifier_special_bonus_unique_zoom", "special_bonuses/special_bonus_unique_zoom.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_unique_zoom == nil then special_bonus_unique_zoom = class({}) end

function special_bonus_unique_zoom:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_zoom", nil)
end

if modifier_special_bonus_unique_zoom == nil then modifier_special_bonus_unique_zoom = class({}) end

function modifier_special_bonus_unique_zoom:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_unique_zoom:IsPurgable()
	return false
end

function modifier_special_bonus_unique_zoom:RemoveOnDeath()
	return false
end
