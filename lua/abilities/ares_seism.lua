if not ares_seism then ares_seism = class({}) end

function ares_seism:GetBehavior()
  local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
  return behav
end

function ares_seism:GetCooldown( nLevel )
  return self.BaseClass.GetCooldown( self, nLevel )
end

function ares_seism:OnSpellStart()
  if IsServer() then
    local iAoE = self:GetSpecialValueFor( "radius" )
    local iDmg = ((self:GetSpecialValueFor( "damage" ) / 100) * self:GetCaster():GetHealthDeficit()) + self:GetAbilityDamage()

    if self:GetCaster():HasScepter() then
      local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), iAoE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
      if #allies > 0 then
        for _,ally in pairs(allies) do
          self:ApplyAbilityDamage(ally, iAoE, iDmg)
        end
      end
    else
      self:ApplyAbilityDamage(self, iAoE, iDmg)
    end
  end
end

function ares_seism:ApplyAbilityDamage(caster, iAoE, iDmg)
  if IsServer() then
    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), caster:GetOrigin(), self:GetCaster(), iAoE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
  	if #units > 0 then
  		for _, target in pairs(units) do
  			target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor( "stun" ) } )
        ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = iDmg, damage_type = DAMAGE_TYPE_MAGICAL})
        EmitSoundOn("Hero_ElderTitan.EarthSplitter.Destroy", target)
  		end
  	end
    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ares/ares_seism_main.vpcf", PATTACH_CUSTOMORIGIN, nil );
    ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetAbsOrigin());
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector(iAoE, iAoE, 0));
    ParticleManager:SetParticleControl( nFXIndex, 2, Vector(14, 187, 222));
    ParticleManager:SetParticleControl( nFXIndex, 3, caster:GetAbsOrigin());
    ParticleManager:SetParticleControl( nFXIndex, 6, caster:GetAbsOrigin());
    ParticleManager:ReleaseParticleIndex( nFXIndex );

    EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster)
    EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7_layer", caster)
  end
end

function ares_seism:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
