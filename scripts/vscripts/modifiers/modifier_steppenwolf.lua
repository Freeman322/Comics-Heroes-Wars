if modifier_steppenwolf == nil then modifier_steppenwolf = class({}) end


function modifier_steppenwolf:IsHidden()
	return true
end

function modifier_steppenwolf:IsPurgable()
	return false
end

function modifier_steppenwolf:RemoveOnDeath()
	return false
end

function modifier_steppenwolf:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_steppenwolf:GetAttackSound( params )
    return "Hero_AbyssalUnderlord.Attack"
end
