if modifier_jiren == nil then modifier_jiren = class({}) end

function modifier_jiren:IsAura()
	return false
end

function modifier_jiren:IsHidden()
	return true
end

function modifier_jiren:IsPurgable()
	return false
end

function modifier_jiren:RemoveOnDeath()
	return false
end

function modifier_jiren:OnCreated(params)
    if IsServer() then 
    end
end

function modifier_jiren:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
