if scarlet_witch_unstable_energy == nil then scarlet_witch_unstable_energy = class({}) end
LinkLuaModifier( "modifier_scarlet_witch_unstable_energy", "abilities/scarlet_witch_unstable_energy.lua", LUA_MODIFIER_MOTION_NONE )

function scarlet_witch_unstable_energy:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local info = {
                EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf",
                Ability = self,
                iMoveSpeed = 2500,
                Source = self:GetCaster (),
                Target = self:GetCursorTarget (),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

            ProjectileManager:CreateTrackingProjectile (info)
            EmitSoundOn ("Hero_ArcWarden.Flux.Cast", self:GetCaster () )
        end
    end
end

function scarlet_witch_unstable_energy:OnProjectileHit (hTarget, vLocation)
    if IsServer() then
	    local duration = self:GetSpecialValueFor ("damage_delay")
	    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_scarlet_witch_unstable_energy", { duration = duration } )
	    EmitSoundOn ("DOTA_Item.Bloodthorn.Activate", hTarget)
    	EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)
	end
    return true
end

if modifier_scarlet_witch_unstable_energy == nil then modifier_scarlet_witch_unstable_energy = class({}) end

function modifier_scarlet_witch_unstable_energy:IsPurgable()
    return false
end

function modifier_scarlet_witch_unstable_energy:GetStatusEffectName()
    return "particles/status_fx/status_effect_armor_dazzle.vpcf"
end


function modifier_scarlet_witch_unstable_energy:StatusEffectPriority()
    return 1000
end


function modifier_scarlet_witch_unstable_energy:GetEffectName()
    return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
end

function modifier_scarlet_witch_unstable_energy:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_scarlet_witch_unstable_energy:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE

    }

    return funcs
end

function modifier_scarlet_witch_unstable_energy:OnDestroy()
	if IsServer() then
        local hTarget = self:GetParent()
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", hTarget)
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)

        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", self:GetAbility():GetCaster())
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", self:GetAbility():GetCaster())

        if self:GetParent():GetHealthPercent() <= self:GetAbility():GetSpecialValueFor("damage_on_destroy") then
            self:GetParent():Kill(self:GetAbility(), self:GetCaster())
        end
        
        local pop_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
        ParticleManager:SetParticleControl(pop_pfx, 0, hTarget:GetAbsOrigin())
        ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))
        ParticleManager:ReleaseParticleIndex(pop_pfx)

        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = hTarget, ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function scarlet_witch_unstable_energy:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

