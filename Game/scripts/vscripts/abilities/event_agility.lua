event_agility = class({})
LinkLuaModifier( "modifier_event_agility", "abilities/event_agility.lua" ,LUA_MODIFIER_MOTION_NONE )

function event_agility:GetIntrinsicModifierName()
	return "modifier_event_agility"
end

modifier_event_agility = class({})

function modifier_event_agility:IsPurgable()
    return false
end

function modifier_event_agility:IsHidden()
    return true
end

function modifier_event_agility:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}

	return funcs
end

function modifier_event_agility:GetModifierBonusStats_Agility( params )
	return self:GetAbility():GetSpecialValueFor("agility")
end
