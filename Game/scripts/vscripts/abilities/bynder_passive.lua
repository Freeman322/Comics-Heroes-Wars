bynder_passive = class ( {})

LinkLuaModifier ("modifier_bynder_passive", "abilities/bynder_passive.lua", LUA_MODIFIER_MOTION_NONE)

function bynder_passive:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function bynder_passive:GetIntrinsicModifierName ()
    return "modifier_bynder_passive"
end

modifier_bynder_passive = class({})

--------------------------------------------------------------------------------

function modifier_bynder_passive:OnCreated( kv )
	if IsServer() then
		self:GetParent():CalculateStatBonus()
	end
end

function modifier_bynder_passive:RemoveOnDeath()
	return false
end

function modifier_bynder_passive:IsPurgable()
	return false
end


function modifier_bynder_passive:OnRefresh( kv )
	if IsServer() then
		self:GetParent():CalculateStatBonus()
	end
end

function modifier_bynder_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function modifier_bynder_passive:GetModifierBonusStats_Strength( params )
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("str")
end

function modifier_bynder_passive:GetModifierBonusStats_Agility( params )
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("agi")
end

function modifier_bynder_passive:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("int")
end

function modifier_bynder_passive:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function bynder_passive:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

