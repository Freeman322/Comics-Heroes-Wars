out_jinada = class({})
LinkLuaModifier( "modifier_out_jinada", "abilities/out_jinada.lua", LUA_MODIFIER_MOTION_NONE )

function out_jinada:GetIntrinsicModifierName()
     return "modifier_out_jinada"
end

if modifier_out_jinada == nil then modifier_out_jinada = class({}) end

function modifier_out_jinada:IsHidden()
    return true
end

function modifier_out_jinada:IsPurgable()
    return false
end

function modifier_out_jinada:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_out_jinada:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            local hTarget = params.target
            
            if hTarget:IsBuilding() then return end
            if hTarget:IsConsideredHero() then return end

            ApplyDamage({attacker = self:GetCaster(), victim = hTarget, damage = self:GetAbility():GetSpecialValueFor("dmg")*hTarget:GetMaxHealth(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PHYSICAL})
            EmitSoundOn("Hero_Antimage.ManaBreak", hTarget)
            local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/am_basher_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
        end
    end
    return 0
end

function out_jinada:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

