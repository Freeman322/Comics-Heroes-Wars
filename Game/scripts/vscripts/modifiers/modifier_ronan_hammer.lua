if modifier_ronan_hammer == nil then modifier_ronan_hammer = class({}) end

function modifier_ronan_hammer:IsHidden()
	return true
end

function modifier_ronan_hammer:IsPurgable()
	return false
end

function modifier_ronan_hammer:RemoveOnDeath()
	return false
end

function modifier_ronan_hammer:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_ronan_hammer:GetAttackSound( params )
    return "Hero_Omniknight.Purification.Wingfall"
end
