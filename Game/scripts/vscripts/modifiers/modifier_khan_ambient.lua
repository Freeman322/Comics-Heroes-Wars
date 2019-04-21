modifier_khan_ambient = class({})

function modifier_khan_ambient:IsPurgable()
    return false
end

function modifier_khan_ambient:RemoveOnDeath()
    return false
end

function modifier_khan_ambient:IsHidden()
    return true
end

function modifier_khan_ambient:GetStatusEffectName()
    return "particles/status_fx/status_effect_fiendsgrip.vpcf"
end

function modifier_khan_ambient:OnCreated( kv )
    if IsServer() then
        local target_location = self:GetParent():GetAbsOrigin() - (self:GetParent():GetForwardVector()*100)
        local direction = target_location:Normalized()

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_h2" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_h1" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 15, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 16, self:GetParent():GetOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_h2" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex1, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_h2" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex1, 6, Vector(0,1,0))
        ParticleManager:SetParticleControl( nFXIndex1, 3, Vector(0,1,0))
        ParticleManager:SetParticleControlOrientation(nFXIndex1, 0, direction, Vector(0,1,0), Vector(1,0,0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_h1" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex2, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_h1" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex2, 6, Vector(0,1,0))
        ParticleManager:SetParticleControl( nFXIndex2, 3, Vector(0,1,0))
        ParticleManager:SetParticleControlOrientation(nFXIndex2, 0, direction, Vector(0,1,0), Vector(1,0,0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end