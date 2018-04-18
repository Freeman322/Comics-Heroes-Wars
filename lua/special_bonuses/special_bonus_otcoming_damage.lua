LinkLuaModifier( "modifier_special_bonus_otcoming_damage", "special_bonuses/special_bonus_otcoming_damage.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_otcoming_damage == nil then special_bonus_otcoming_damage = class({}) end

function special_bonus_otcoming_damage:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_otcoming_damage", nil)
	print("Upgraded")
end

if modifier_special_bonus_otcoming_damage == nil then modifier_special_bonus_otcoming_damage = class({}) end

function modifier_special_bonus_otcoming_damage:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_otcoming_damage:IsPurgable()
	return false
end

function modifier_special_bonus_otcoming_damage:RemoveOnDeath()
	return false
end

function modifier_special_bonus_otcoming_damage:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifier_special_bonus_otcoming_damage:GetModifierTotalDamageOutgoing_Percentage( params )
    return 20
end