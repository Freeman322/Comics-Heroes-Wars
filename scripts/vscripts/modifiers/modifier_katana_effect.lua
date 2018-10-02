modifier_katana_effect = class({})

function modifier_katana_effect:IsPurgable()
    return false
end

function modifier_katana_effect:RemoveOnDeath()
    return false
end

function modifier_katana_effect:IsHidden()
    return true
end

function modifier_katana_effect:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_katana/katana_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, "attach_attack1" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, "attach_attack2" , self:GetParent():GetOrigin(), true )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end