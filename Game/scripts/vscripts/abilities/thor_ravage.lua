thor_ravage = class({})

LinkLuaModifier("modifier_thor_ravage_stun", "abilities/thor_ravage.lua", LUA_MODIFIER_MOTION_NONE)

function thor_ravage:OnAbilityPhaseStart()
  if IsServer() then
    EmitSoundOn("Hero_Zuus.GodsWrath.PreCast.Arcana", self:GetCaster())

    local particle_start = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(particle_start, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_start, 1, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_start, 2, self:GetCaster():GetAbsOrigin())

    self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
  end
  return true
end


function thor_ravage:OnSpellStart()
  if IsServer() then
    EmitSoundOn("Hero_Zuus.Cloud.Cast", self:GetCaster())
    EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetCaster())
    EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", self:GetCaster())

    local radius = self:GetSpecialValueFor("radius")
    local bonus_damage = self:GetSpecialValueFor("damage_health")

    if self:GetCaster():HasTalent("special_bonus_unique_thor_4") then
      bonus_damage = bonus_damage + self:GetCaster():FindTalentValue("special_bonus_unique_thor_4")
    end

    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
    if #units > 0 then
      for _,target in pairs(units) do
        local damage = {
          victim = target,
          attacker = self:GetCaster(),
          damage = self:GetAbilityDamage() + (target:GetMaxHealth() * (bonus_damage / 100)),
          damage_type = self:GetAbilityDamageType(),
        }

        target:AddNewModifier(self:GetCaster(), self, "modifier_thor_ravage_stun", {duration = self:GetSpecialValueFor("duration")})

        if self:GetCaster():HasScepter() then
          self:GetCaster():PerformAttack(target, false, true, true, true, false, false, true)
          self:GetCaster():PerformAttack(target, false, true, true, true, false, false, true)
          self:GetCaster():PerformAttack(target, false, true, true, true, false, false, true)
        end

        local particle = ParticleManager:CreateParticle("particles/hero_zuus/zeus_immortal_thundergod.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
        ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
        ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
       
        EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", target)
        EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", target)

        ApplyDamage( damage )
      end
    end
  end
end

  if modifier_thor_ravage_stun == nil then modifier_thor_ravage_stun = class({}) end

  function modifier_thor_ravage_stun:IsDebuff()
    return true
  end

  function modifier_thor_ravage_stun:IsStunDebuff()
    return true
  end

  function modifier_thor_ravage_stun:OnCreated(ht)
    if IsServer() then
      local eyes = ParticleManager:CreateParticleForPlayer("particles/econ/items/zeus/arcana_chariot/zeus_tgw_screen_damage.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
      self:AddParticle(eyes, false, false, -1, false, false)

      local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_static_field.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
      ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
      ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
      self:AddParticle(particle, false, false, -1, false, false)
    end
  end

  function modifier_thor_ravage_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
  end

  function modifier_thor_ravage_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
  end

  function modifier_thor_ravage_stun:DeclareFunctions()
    local funcs = {
      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
  end

  function modifier_thor_ravage_stun:GetOverrideAnimation( params )
    return ACT_DOTA_DISABLED
  end

  function modifier_thor_ravage_stun:CheckState()
    local state = {
      [MODIFIER_STATE_STUNNED] = true,
    }

    return state
  end
