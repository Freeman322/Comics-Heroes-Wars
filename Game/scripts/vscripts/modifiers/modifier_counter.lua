if modifier_counter == nil then modifier_counter = class({}) end

function modifier_counter:IsHidden()
	return false
end

function modifier_counter:IsPurgable()
	return false
end

function modifier_counter:RemoveOnDeath()
	return false
end

function modifier_counter:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
