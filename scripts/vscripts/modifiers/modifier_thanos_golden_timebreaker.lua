if modifier_thanos_golden_timebreaker == nil then modifier_thanos_golden_timebreaker = class({}) end


function modifier_thanos_golden_timebreaker:IsHidden()
	return true
end

function modifier_thanos_golden_timebreaker:IsPurgable()
	return false
end

function modifier_thanos_golden_timebreaker:RemoveOnDeath()
	return false
end

function modifier_thanos_golden_timebreaker:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_thanos_golden_timebreaker:GetAttackSound( params )
    return "Hero_FacelessVoid.TimeLockImpact"
end
