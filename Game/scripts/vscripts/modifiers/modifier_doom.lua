if modifier_doom == nil then modifier_doom = class({}) end

function modifier_doom:IsHidden()
	return false
end

function modifier_doom:IsPurgable()
	return false
end

function modifier_doom:RemoveOnDeath()
	return false
end

function modifier_doom:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_doom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function modifier_doom:GetModifierBonusStats_Strength(params)
	return self:GetStackCount()*2
end

function modifier_doom:GetModifierBonusStats_Intellect(params)
	return self:GetStackCount()*2
end