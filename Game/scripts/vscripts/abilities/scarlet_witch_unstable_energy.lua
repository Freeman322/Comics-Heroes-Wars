LinkLuaModifier( "modifier_scarlet_witch_unstable_energy", "abilities/scarlet_witch_unstable_energy.lua", 0 )
scarlet_witch_unstable_energy = class({})

function scarlet_witch_unstable_energy:OnSpellStart ()
    if self:GetCursorTarget() ~= nil then
        if not self:GetCursorTarget():TriggerSpellAbsorb (self) then
            ProjectileManager:CreateTrackingProjectile ({
                EffectName = "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf",
                Ability = self,
                iMoveSpeed = 2500,
                Source = self:GetCaster(),
                Target = self:GetCursorTarget(),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            })
            EmitSoundOn ("Hero_ArcWarden.Flux.Cast", self:GetCaster () )
        end
    end
end

function scarlet_witch_unstable_energy:OnProjectileHit (hTarget, vLocation)
    if IsServer() then
	    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_scarlet_witch_unstable_energy", {duration = self:GetSpecialValueFor ("damage_delay")})
	    EmitSoundOn ("DOTA_Item.Bloodthorn.Activate", hTarget)
    	EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)
	end
    return true
end

modifier_scarlet_witch_unstable_energy = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    GetStatusEffectName = function() return "particles/status_fx/status_effect_armor_dazzle.vpcf" end,
    StatusEffectPriority = function() return 1000 end,
    GetEffectName = function() return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE

    } end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_scarlet_witch_unstable_energy:OnDestroy()
	if IsServer() then
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", self:GetParent())
        EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", self:GetParent())

        local pop_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(pop_pfx, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))
        ParticleManager:ReleaseParticleIndex(pop_pfx)

        ApplyDamage({
            victim = self:GetParent(), ability = self:GetAbility(),
            attacker = self:GetAbility():GetCaster(),
            ability = self:GetAbility(),
            damage = self:GetAbility():GetSpecialValueFor("damage"),
            damage_type = self:GetAbility():GetAbilityDamageType()
        })
        if self:GetParent():GetHealthPercent() <= self:GetAbility():GetSpecialValueFor("damage_on_destroy") then
            self:GetParent():Kill(self:GetAbility(), self:GetCaster())
        end
	end
end
