if earthshaker_echo_slam_lua == nil then
  earthshaker_echo_slam_lua = class({})
end


function earthshaker_echo_slam_lua:GetBehavior()
  local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
  return behav
end

function earthshaker_echo_slam_lua:GetCooldown( nLevel )
  return self.BaseClass.GetCooldown( self, nLevel )
end
-----
function earthshaker_echo_slam_lua:OnSpellStart()
  if IsServer() then
    local iAoE = self:GetSpecialValueFor( "echo_slam_damage_range" )
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
    local caster = self:GetCaster()
    caster:EmitSound("PudgeWarsClassic.echo_slam")
    caster:EmitSound("PudgeWarsClassic.echo_slam")
    caster:EmitSound("PudgeWarsClassic.echo_slam")
    ScreenShake( caster:GetOrigin(), 600, 600, 2, 9999, 0, true)
    local explosion5 = ParticleManager:CreateParticle("particles/effects/echo_slam.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(explosion5, 0, caster:GetAbsOrigin() + Vector(0, 0, 1))
    ParticleManager:SetParticleControl(explosion5, 1, caster:GetAbsOrigin() + Vector(0, 0, 1))
    ParticleManager:SetParticleControl (explosion5, 2, Vector (1500, 1500, 0))
    ParticleManager:SetParticleControl(explosion5, 3, caster:GetAbsOrigin() + Vector(0, 0, 1))
    ParticleManager:SetParticleControl(explosion5, 4, caster:GetAbsOrigin() + Vector(0, 0, 1))
    ParticleManager:SetParticleControl (explosion5, 5, Vector (1500, 1500, 0))
    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), iAoE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    if #enemies > 0 then
      EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.EchoSlam", self:GetCaster() )
      ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 2*#enemies, 1, 1 ) )
      for _,hTarget in pairs(enemies) do
        if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then

          local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self:GetAbilityDamage(),
            damage_type = self:GetAbilityDamageType(),
            ability = self
          }
          self:Echoes(hTarget)
          ApplyDamage( damage )
        end
      end
    else
      EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.EchoSlamSmall", self:GetCaster() )
      ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 1, 1 ) )
    end
    ParticleManager:ReleaseParticleIndex( nFXIndex )
  end
end

function earthshaker_echo_slam_lua:Echoes(hTarget)
  local hCaster = self:GetCaster()
  local iAoE = self:GetSpecialValueFor( "echo_slam_echo_range" )
  local info =
  {
    Source = hTarget,
    Ability = self,
    EffectName = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam.vpcf",
    iMoveSpeed = iAoE,
    vSourceLoc= hTarget:GetAbsOrigin(),
    bDrawsOnMinimap = false,
    bDodgeable = true,
    bIsAttack = false,
    bVisibleToEnemies = true,
    bReplaceExisting = false,
    flExpireTime = nil,
    bProvidesVision = false,
    iVisionRadius = 0,
    iVisionTeamNumber = hCaster:GetTeamNumber()
  }

  local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), hTarget, iAoE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
  if #enemies > 0 then
    for _,hEcho in pairs(enemies) do
      if hEcho ~= nil and ( not hEcho:IsMagicImmune() ) and ( not hEcho:IsInvulnerable() ) and hEcho ~= hTarget then
        info.Target = hEcho
        projectile = ProjectileManager:CreateTrackingProjectile(info)
        if hTarget:IsHero() and hCaster:HasScepter() then
          projectile = ProjectileManager:CreateTrackingProjectile(info)
        end
      end
    end
  end
end

function earthshaker_echo_slam_lua:OnProjectileHit(hTarget, vLocation)
  local iDamage = self:GetSpecialValueFor( "echo_slam_echo_damage" )
  local damage = {
    victim = hTarget,
    attacker = self:GetCaster(),
    damage = iDamage,
    damage_type = self:GetAbilityDamageType(),
    ability = self
  }
  ApplyDamage( damage )
  return true
end

function earthshaker_echo_slam_lua:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 
