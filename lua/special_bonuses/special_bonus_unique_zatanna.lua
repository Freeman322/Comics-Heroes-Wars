LinkLuaModifier( "modifier_special_bonus_unique_zatanna", "special_bonuses/special_bonus_unique_zatanna.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_unique_zatanna == nil then special_bonus_unique_zatanna = class({}) end

function special_bonus_unique_zatanna:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_zatanna", nil)
end

if modifier_special_bonus_unique_zatanna == nil then modifier_special_bonus_unique_zatanna = class({}) end

function modifier_special_bonus_unique_zatanna:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_unique_zatanna:IsPurgable()
	return false
end

function modifier_special_bonus_unique_zatanna:RemoveOnDeath()
	return false
end
