spawn_infernal_blast = class({})

function spawn_infernal_blast:OnSpellStart()
    local vision_radius = self:GetSpecialValueFor( "vision_radius" )
    local bolt_speed = self:GetSpecialValueFor( "bolt_speed" )

    local info = {
        EffectName = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf",
        Ability = self,
        iMoveSpeed = 1000,
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        bDodgeable = true,
        bProvidesVision = false,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
    }

    ProjectileManager:CreateTrackingProjectile( info )
    EmitSoundOn( "Hero_SkeletonKing.Hellfire_Blast", self:GetCaster() )

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "pepe") then
        EmitSoundOn( "Pepe.Cast", self:GetCaster() )
    end
end

--------------------------------------------------------------------------------

function spawn_infernal_blast:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
        EmitSoundOn( "Hero_SkeletonKing.Hellfire_BlastImpact", hTarget )
        local duration = self:GetSpecialValueFor( "stun_duration" )
        local damage = self:GetSpecialValueFor( "damage" ) + (self:GetCaster():GetIntellect() * self:GetSpecialValueFor("bonus_damage_int"))

        local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }

        ApplyDamage( damage )
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
    end

    return true
end

function spawn_infernal_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

