if modifier_saitama_arcana == nil then modifier_saitama_arcana = class({}) end

function modifier_saitama_arcana:IsAura()
	return false
end

function modifier_saitama_arcana:IsHidden()
	return true
end

function modifier_saitama_arcana:IsPurgable()
	return false
end

function modifier_saitama_arcana:RemoveOnDeath()
	return false
end

function modifier_saitama_arcana:GetStatusEffectName()
    return "particles/econ/items/enigma/enigma_world_chasm/status_effect_enigma_blackhole_tgt_ti5.vpcf"
end

function modifier_saitama_arcana:StatusEffectPriority()
    return 1000
end

function modifier_saitama_arcana:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_saitama_arcana:GetAttackSound( params )
    return "Hero_AbyssalUnderlord.Attack"
end
