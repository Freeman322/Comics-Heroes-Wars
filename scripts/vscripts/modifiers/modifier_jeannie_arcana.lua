if modifier_jeannie_arcana == nil then modifier_jeannie_arcana = class({}) end

function modifier_jeannie_arcana:IsAura()
	return false
end

function modifier_jeannie_arcana:IsHidden()
	return true
end

function modifier_jeannie_arcana:IsPurgable()
	return false
end

function modifier_jeannie_arcana:RemoveOnDeath()
	return false
end

function modifier_jeannie_arcana:OnCreated(params)
    if IsServer() then 
        self:GetCaster():SetRangedProjectileName("particles/effects/jeannie_attack.vpcf")
    end
end

function modifier_jeannie_arcana:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_jeannie_arcana:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_jeannie_arcana:GetAttackSound( params )
    return "Hero_ArcWarden.Flux.Cast"
end
