--
-- Created by IntelliJ IDEA.
-- User: adams
-- Date: 18.02.2020
-- Time: 20:52
-- To change this template use File | Settings | File Templates.
--

local I_MOVESPEED_VC = 8500

genos_inceneration_blast = class({})

function genos_inceneration_blast:OnSpellStart()
    if IsServer() then
        -- get references
        local target = self:GetCursorTarget()

        -- create tracking projectile
        local info = {
            EffectName = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast.vpcf",
            Ability = self,
            iMoveSpeed = I_MOVESPEED_VC,
            Source = self:GetCaster(),
            Target = target,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        }

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "Hero_SkeletonKing.Hellfire_Blast", self:GetCaster() )
    end
end

function genos_inceneration_blast:OnProjectileHit( hTarget, vLocation )
    -- check target
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:IsMagicImmune() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
        local stun_duration = self:GetSpecialValueFor( "blast_stun_duration" )
        local dot_duration = self:GetSpecialValueFor( "blast_dot_duration" )

        ApplyDamage({
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self:GetAbilityDamage(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        })

        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_huskar_burning_spear_debuff", { duration = dot_duration } )

        EmitSoundOn( "Hero_SkeletonKing.Hellfire_BlastImpact", target )
    end

    return true
end
