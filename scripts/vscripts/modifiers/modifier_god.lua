
if modifier_god == nil then
	modifier_god = class({})
end

function modifier_god:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
}
	return funcs
end

function modifier_god:IsHidden()
	return false
end

function modifier_god:IsPurgable()
    return false
end

function modifier_god:RemoveOnDeath()
    return false
end

function modifier_god:GetModifierTotalDamageOutgoing_Percentage()
	return 99999
end

function modifier_god:GetModifierCooldownReduction_Constant()
    return 100
end

function modifier_god:GetModifierPercentageCooldown()
    return 100
end

function modifier_god:GetModifierPercentageCasttime()
    return 99
end

function modifier_god:CheckState()
    local state = {
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }

    return state
end