LinkLuaModifier( "modifier_special_bonus_unique_ursa_warrior", "special_bonuses/special_bonus_unique_ursa_warrior.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_unique_ursa_warrior == nil then special_bonus_unique_ursa_warrior = class({}) end

function special_bonus_unique_ursa_warrior:OnUpgrade()
	print("Upgraded")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_ursa_warrior", nil)
	for k,v in pairs(self:GetCaster():FindAllModifiers()) do
		print(k,v:GetName())
	end
end

if modifier_special_bonus_unique_ursa_warrior == nil then modifier_special_bonus_unique_ursa_warrior = class({}) end

function modifier_special_bonus_unique_ursa_warrior:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_unique_ursa_warrior:IsPurgable()
	return false
end

function modifier_special_bonus_unique_ursa_warrior:RemoveOnDeath()
	return false
end
