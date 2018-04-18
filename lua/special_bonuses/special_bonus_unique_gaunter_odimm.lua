LinkLuaModifier( "modifier_special_bonus_unique_gaunter_odimm", "special_bonuses/special_bonus_unique_gaunter_odimm.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_unique_gaunter_odimm == nil then special_bonus_unique_gaunter_odimm = class({}) end

function special_bonus_unique_gaunter_odimm:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_gaunter_odimm", nil)
end

if modifier_special_bonus_unique_gaunter_odimm == nil then modifier_special_bonus_unique_gaunter_odimm = class({}) end

function modifier_special_bonus_unique_gaunter_odimm:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_unique_gaunter_odimm:IsPurgable()
	return false
end

function modifier_special_bonus_unique_gaunter_odimm:RemoveOnDeath()
	return false
end

