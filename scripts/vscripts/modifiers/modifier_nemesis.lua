if modifier_nemesis == nil then modifier_nemesis = class({}) end

function modifier_nemesis:IsAura()
	return false
end

function modifier_nemesis:IsHidden()
	return true
end

function modifier_nemesis:IsPurgable()
	return false
end

function modifier_nemesis:RemoveOnDeath()
	return false
end

function modifier_nemesis:OnCreated(params)
    if IsServer() then 

    end
end

function modifier_nemesis:GetEffectName()
    return "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf"
end

function modifier_nemesis:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_nemesis:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_MODEL_SCALE
    }

    return funcs
end

function modifier_nemesis:GetAttackSound( params )
    return "Khan.Nemesis.Attack"
end

function modifier_nemesis:GetModifierModelScale( params )
    return 72
end
