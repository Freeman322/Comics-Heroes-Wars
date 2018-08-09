event_str = class({})
LinkLuaModifier( "modifier_event_str", "abilities/event_str.lua" ,LUA_MODIFIER_MOTION_NONE )

function event_str:GetIntrinsicModifierName()
	return "modifier_event_str"
end

modifier_event_str = class({})

function modifier_event_str:IsPurgable()
    return false
end

function modifier_event_str:IsHidden()
    return true
end

function modifier_event_str:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}

	return funcs
end

function modifier_event_str:GetModifierBonusStats_Strength( params )
	return self:GetAbility():GetSpecialValueFor("str")
end
