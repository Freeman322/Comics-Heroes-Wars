if modifier_ursa_devils_helmet == nil then modifier_ursa_devils_helmet = class({}) end

function modifier_ursa_devils_helmet:IsHidden()
	return true
end

function modifier_ursa_devils_helmet:IsPurgable()
	return false
end

function modifier_ursa_devils_helmet:RemoveOnDeath()
	return false
end

function modifier_ursa_devils_helmet:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
