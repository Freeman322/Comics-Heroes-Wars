if modifier_vader == nil then modifier_vader = class({}) end

function modifier_vader:IsHidden()
	return false
end

function modifier_vader:IsPurgable()
	return false
end

function modifier_vader:RemoveOnDeath()
	return false
end

function modifier_vader:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
