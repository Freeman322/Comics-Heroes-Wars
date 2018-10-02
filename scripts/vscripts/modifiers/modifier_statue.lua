
if modifier_statue == nil then modifier_statue = class({}) end

function modifier_statue:IsHidden()
	return false
end

function modifier_statue:IsPurgable()
    return false
end

function modifier_statue:RemoveOnDeath()
    return false
end

function modifier_statue:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }

    return state
end

function modifier_statue:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MIN_HEALTH	
	}
	return funcs
end

function modifier_statue:GetMinHealth()
	return 1
end