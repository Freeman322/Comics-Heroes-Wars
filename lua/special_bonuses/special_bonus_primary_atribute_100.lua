LinkLuaModifier( "modifier_special_bonus_primary_atribute_100", "special_bonuses/special_bonus_primary_atribute_100.lua", LUA_MODIFIER_MOTION_NONE )
if special_bonus_primary_atribute_100 == nil then special_bonus_primary_atribute_100 = class({}) end

function special_bonus_primary_atribute_100:OnUpgrade()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_primary_atribute_100", nil)
end

if modifier_special_bonus_primary_atribute_100 == nil then modifier_special_bonus_primary_atribute_100 = class({}) end

function modifier_special_bonus_primary_atribute_100:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_special_bonus_primary_atribute_100:IsPurgable()
	return false
end

function modifier_special_bonus_primary_atribute_100:RemoveOnDeath()
	return false
end

function modifier_special_bonus_primary_atribute_100:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
	return funcs
end

function modifier_special_bonus_primary_atribute_100:GetModifierBonusStats_Strength( params )
    return self.value_str
end

function modifier_special_bonus_primary_atribute_100:GetModifierBonusStats_Intellect( params )
    return self.value_int
end
function modifier_special_bonus_primary_atribute_100:GetModifierBonusStats_Agility( params )
    return self.value_agi
end

function modifier_special_bonus_primary_atribute_100:OnCreated(htable)
    if IsServer() then
    	local caster = self:GetParent()
    	local primary_atr = caster:GetPrimaryAttribute()
    	if primary_atr == 0 then
    		self.value_str = 100
    		self.value_int = 0
    		self.value_agi = 0
		elseif primary_atr == 1 then
			self.value_str = 0
    		self.value_int = 0
    		self.value_agi = 100
		else
			self.value_str = 0
    		self.value_int = 100
    		self.value_agi = 0
		end
    end
end