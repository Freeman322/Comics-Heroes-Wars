if modifier_king_thanos == nil then modifier_king_thanos = class({}) end

function modifier_king_thanos:IsHidden()
	return true
end

function modifier_king_thanos:IsPurgable()
	return false
end

function modifier_king_thanos:RemoveOnDeath()
	return false
end

function modifier_king_thanos:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_king_thanos:GetAttackSound( params )
    return "Hero_Sven.GodsStrength.Attack"
end
