modifier_sargeras_effect = class({})

function modifier_sargeras_effect:RemoveOnDeath(  )
	return false
end
function modifier_sargeras_effect:IsPurgable()
	return false
end
function modifier_sargeras_effect:IsHidden(  )
	return true
end
function modifier_sargeras_effect:GetEffectName(  )
    return "particles/units/heroes/hero_clinkz/clinkz_strafe.vpcf"
end
function modifier_sargeras_effect:GetEffectAttachType(  )
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_sargeras_effect:OnCreated( kv )
	if IsServer() then
        local nFXIndex2 = ParticleManager:CreateParticle( "particles/hero_sargeras/modifier_sargeras_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex2, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex2, 7, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex2, false, false, -1, false, true )

        local nFXIndex3 = ParticleManager:CreateParticle( "particles/hero_sargeras/modifier_sargeras_effect_jaw.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex3, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_jaw", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex3, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_jaw", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex3, 2, Vector(1, 0, 0))
		ParticleManager:SetParticleControlEnt( nFXIndex3, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_jaw", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex3, 7, Vector(1, 0, 1))
		self:AddParticle( nFXIndex3, false, false, -1, false, true )

		local nFXIndex = ParticleManager:CreateParticle( "particles/ragnaros/ragnaros_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 11, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 12, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 13, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 14, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetOrigin(), true )
	end
end
