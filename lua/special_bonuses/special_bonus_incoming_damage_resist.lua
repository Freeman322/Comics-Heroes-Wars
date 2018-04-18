LinkLuaModifier( "modifier_special_bonus_incoming_damage_resist", "special_bonuses/special_bonus_incoming_damage_resist.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_incoming_damage_resist == nil then special_bonus_incoming_damage_resist = class({}) end

function special_bonus_incoming_damage_resist:OnUpgrade()
	print("Upgraded")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_incoming_damage_resist", nil)
	for k,v in pairs(self:GetCaster():FindAllModifiers()) do
		print(k,v:GetName())
	end
end

if modifier_special_bonus_incoming_damage_resist == nil then modifier_special_bonus_incoming_damage_resist = class({}) end

function modifier_special_bonus_incoming_damage_resist:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_incoming_damage_resist:IsPurgable()
	return false
end

function modifier_special_bonus_incoming_damage_resist:RemoveOnDeath()
	return false
end

function modifier_special_bonus_incoming_damage_resist:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end

function modifier_special_bonus_incoming_damage_resist:GetModifierIncomingDamage_Percentage( params )
    return -20
end