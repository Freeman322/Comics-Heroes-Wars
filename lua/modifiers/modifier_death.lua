if modifier_death == nil then modifier_death = class({}) end

function modifier_death:IsHidden()
	return false
end

function modifier_death:IsPurgable()
	return false
end

function modifier_death:RemoveOnDeath()
	return false
end

function modifier_death:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_death:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function modifier_death:GetModifierPreAttack_BonusDamage(params)
	return self:GetStackCount()*20
end

function modifier_death:GetModifierBonusStats_Intellect(params)
	return self:GetStackCount()*10
end