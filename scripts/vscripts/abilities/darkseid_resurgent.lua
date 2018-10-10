if darkseid_resurgent == nil then darkseid_resurgent = class({}) end 
LinkLuaModifier("modifier_darkseid_resurgent", "abilities/darkseid_resurgent.lua", LUA_MODIFIER_MOTION_NONE)

function darkseid_resurgent:GetIntrinsicModifierName()
    return "modifier_darkseid_resurgent"
end

if modifier_darkseid_resurgent == nil then modifier_darkseid_resurgent = class({}) end 

function modifier_darkseid_resurgent:IsHidden()
    return true
end

function modifier_darkseid_resurgent:IsPurgable()
    return false
end

function modifier_darkseid_resurgent:DeclareFunctions ()
    return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_darkseid_resurgent:OnTakeDamage(args)
    if self:GetParent() == args.unit then 
        if IsServer() then 
            if self:GetCaster():IsRealHero() == false then 
                return
            end
            if self:GetParent():GetHealth() <= 0 and self:GetAbility():IsCooldownReady() then 
                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_windrunner/windrunner_loadout.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                EmitSoundOn( "Hero_PhantomLancer.Doppelganger.Appear", self:GetCaster() )
                self:GetParent():Heal(self:GetParent():GetMaxHealth() * ((self:GetAbility():GetSpecialValueFor("health_restore")/100)), self:GetAbility())
                self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
            end
        end
    end
end
function darkseid_resurgent:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

