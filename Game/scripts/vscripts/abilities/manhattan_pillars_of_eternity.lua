--
-- Created by IntelliJ IDEA.
-- User: adams
-- Date: 18.02.2020
-- Time: 21:51
-- To change this template use File | Settings | File Templates.
--

local SPEED = 2000

manhattan_pillars_of_eternity = class({})

--------------------------------------------------------------------------------

function manhattan_pillars_of_eternity:GetAOERadius()
    return self:GetSpecialValueFor( "vision_aoe" )
end

--------------------------------------------------------------------------------

function manhattan_pillars_of_eternity:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end
--------------------------------------------------------------------------------

function manhattan_pillars_of_eternity:OnSpellStart()
    local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
    vDirection = vDirection:Normalized()

    local info = {
        EffectName = "particles/units/heroes/hero_demonartist/demonartist_darkartistry_proj.vpcf",
        Ability = self,
        vSpawnOrigin = self:GetCaster():GetOrigin(),
        fStartRadius = 225,
        fEndRadius = 225,
        vVelocity = vDirection * SPEED,
        fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
        Source = self:GetCaster(),
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        bProvidesVision = true,
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
        iVisionRadius = self:GetAOERadius(),
    }

    self.nProjID = ProjectileManager:CreateLinearProjectile( info )

    EmitSoundOn( "Hero_DarkWillow.Brambles.Cast" , self:GetCaster() )
end

--------------------------------------------------------------------------------

function manhattan_pillars_of_eternity:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil then
        local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self:GetSpecialValueFor("damage"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = this,
        }

        EmitSoundOn( "Hero_DarkWillow.Brambles.CastTarget" , hTarget )

        ApplyDamage( damage )

        ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_ley_cast.vpcf", PATTACH_ABSORIGIN, hTarget)

        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_lich_sinister_gaze", { duration = self:GetSpecialValueFor("debuff_duration") } )
    end

    return false
end
