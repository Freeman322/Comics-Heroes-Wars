if galactus_world_devour == nil then galactus_world_devour = class({}) end

function galactus_world_devour:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_galactus_seed_of_ambition") then return "custom/galactus_seed_of_ambition" end
  return self.BaseClass.GetAbilityTextureName(self) 
end

function galactus_world_devour:GetBehavior()
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function galactus_world_devour:GetCooldown( nLevel )
  return self.BaseClass.GetCooldown( self, nLevel )
end

function galactus_world_devour:OnSpellStart()
  if IsServer() then
    self:CreateExplosion(self:GetCaster())

    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
    if #units > 0 then
      for _,target in pairs(units) do
        target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("duration") } )
       
        local dmg = self:GetAbilityDamage() + (target:GetMaxHealth() * (self:GetSpecialValueFor("damage") / 100))

        self:GetCaster():Heal(dmg, target)
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_ti8_immortal_arms/doom_ti8_immortal_devour.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        FindClearSpaceForUnit(target, self:GetCaster():GetAbsOrigin(), true)

        ApplyDamage({victim = target, attacker = self:GetCaster(), damage = dmg, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
      end
    end

    FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), true)
  end
end

function galactus_world_devour:CreateExplosion(caster)
  if Util:PlayerEquipedItem(caster:GetPlayerOwnerID(), "seed_of_ambitions") == true then
    local nFXIndex = ParticleManager:CreateParticle( "particles/galactus/galactus_seed_of_ambition_eternal_item.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl(nFXIndex, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 2, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 3, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(nFXIndex, 6, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl (nFXIndex, 1, Vector (750, 750, 0))
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse.TI8", self:GetCaster() )

    self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    return
  end

  local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )

  local explosion5 = ParticleManager:CreateParticle("particles/effects/echo_slam.vpcf", PATTACH_WORLDORIGIN, caster)
  ParticleManager:SetParticleControl(explosion5, 0, caster:GetAbsOrigin() + Vector(0, 0, 1))
  ParticleManager:SetParticleControl(explosion5, 1, caster:GetAbsOrigin() + Vector(0, 0, 1))
  ParticleManager:SetParticleControl (explosion5, 2, Vector (1500, 1500, 0))
  ParticleManager:SetParticleControl(explosion5, 3, caster:GetAbsOrigin() + Vector(0, 0, 1))
  ParticleManager:SetParticleControl(explosion5, 4, caster:GetAbsOrigin() + Vector(0, 0, 1))
  ParticleManager:SetParticleControl (explosion5, 5, Vector (1500, 1500, 0))

  caster:EmitSound("PudgeWarsClassic.echo_slam")
  caster:EmitSound("PudgeWarsClassic.echo_slam")
  caster:EmitSound("PudgeWarsClassic.echo_slam")

  ScreenShake( caster:GetOrigin(), 600, 600, 2, 9999, 0, true)

  EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.EchoSlamSmall", self:GetCaster() )
  ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 1, 1 ) )
end

