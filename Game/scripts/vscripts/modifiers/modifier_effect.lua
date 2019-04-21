modifier_effect = class({})
function modifier_effect:RemoveOnDeath(  )
	return false
end
function modifier_effect:IsPurgable()
	return false
end
function modifier_effect:IsHidden(  )
	return true
end
function modifier_effect:GetEffectName(  )
    return "particles/units/heroes/hero_clinkz/clinkz_strafe.vpcf"
end
function modifier_effect:GetEffectAttachType(  )
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_effect:OnCreated( kv )
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/ragnaros/ragnaros_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 11, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 12, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 13, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 14, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_root", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end
