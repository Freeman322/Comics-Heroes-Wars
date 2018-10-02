if modifier_wolverine_claws == nil then modifier_wolverine_claws = class({}) end

function modifier_wolverine_claws:IsHidden()
	return true
end

function modifier_wolverine_claws:IsPurgable()
	return false
end

function modifier_wolverine_claws:RemoveOnDeath()
	return false
end

function modifier_wolverine_claws:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_wolverine_claws:GetAttackSound( params )
    return "Item_Desolator.Target"
end
