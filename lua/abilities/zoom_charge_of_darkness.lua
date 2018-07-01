zoom_charge_of_darkness = class({})
LinkLuaModifier("modifier_arcana_darkness", "abilities/zoom_charge_of_darkness.lua", LUA_MODIFIER_MOTION_NONE)

function zoom_charge_of_darkness:CastFilterResultTarget( hTarget )
  if IsServer() then

    if hTarget ~= nil and hTarget:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
      return UF_FAIL_MAGIC_IMMUNE_ENEMY
    end

    local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
    return nResult
  end

  return UF_SUCCESS
end

function zoom_charge_of_darkness:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_zoom_arcana") then return "custom/bh_relativistic_run" end
  if self:GetCaster():HasModifier("modifier_zoom_kalyaska") then return "custom/stygian_kolyaska_charge_of_darkness" end
  return self.BaseClass.GetAbilityTextureName(self)
end


function zoom_charge_of_darkness:GetCooldown( nLevel )
  if self:GetCaster():HasModifier("modifier_special_bonus_unique_zoom") then
    return 40
  end

  return self.BaseClass.GetCooldown( self, nLevel )
end

--------------------------------------------------------------------------------

function zoom_charge_of_darkness:GetCastRange( vLocation, hTarget )
  return 99999
end

function zoom_charge_of_darkness:IsRefreshable()
  return false
end

--------------------------------------------------------------------------------

function zoom_charge_of_darkness:OnSpellStart()
  local hTarget = self:GetCursorTarget()
  local caster = self:GetCaster()
  self.start_speed = 500
  if hTarget ~= nil then
    if ( not hTarget:TriggerSpellAbsorb( self ) ) then
      self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arcana_darkness", {duration = 4})
      local ability = self
      local speed = ability:GetSpecialValueFor("movement_speed")
      ability.time_walk_traveled_distance = 0
      local damage_dist = (hTarget:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
      self.damage = damage_dist
      --[[if caster:GetModelName() == "models/heroes/hero_zoom/speed_wraith/blackflash.vmdl" then
      caster:AddNewModifier(caster, self, "modifier_arcana_darkness", nil)
      end]]--
      Timers:CreateTimer(0.03, function()
      local target_point = hTarget:GetAbsOrigin()
      local caster_location = caster:GetAbsOrigin()
      local distance = (target_point - caster_location):Length2D()
      local direction = (target_point - caster_location):Normalized()
      local duration = distance/speed
      if self.start_speed < ability:GetSpecialValueFor("movement_speed") then
        self.start_speed = self.start_speed + (self.start_speed/10)
      end
      -- Saving the data in the ability
      ability.time_walk_distance = distance
      ability.time_walk_speed = self.start_speed * 1/30 -- 1/30 is how often the motion controller ticks
      ability.time_walk_direction = direction
      if ability.time_walk_distance > 150 then
        caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.time_walk_direction * ability.time_walk_speed)
        ability.time_walk_traveled_distance = ability.time_walk_traveled_distance + ability.time_walk_speed
        return 0.03
      else
        -- Remove the motion controller once the distance has been traveled
        local target = hTarget
        caster:InterruptMotionControllers(false)
        FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
        local explosion5 = ParticleManager:CreateParticle("particles/one_punch.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(explosion5, 0, target:GetAbsOrigin() + Vector(0, 0, 1))
        ParticleManager:SetParticleControl(explosion5, 1, Vector(1, 1, 1))
        ParticleManager:SetParticleControl(explosion5, 2, Vector(255, 255, 255))
        ParticleManager:SetParticleControl(explosion5, 3, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion5, 5, Vector(200, 200, 0))

        local explosion9 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(explosion9, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion9, 1, target:GetAbsOrigin()+ target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion9, 3, target:GetAbsOrigin() + target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion9, 11, target:GetAbsOrigin()+ target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion9, 12, caster:GetAbsOrigin())


        local explosion13 = ParticleManager:CreateParticle("particles/hero_zoom/time_crystal_activate.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(explosion13 , 0, target:GetAbsOrigin())

        local explosion10 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(explosion10, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion10, 1, target:GetAbsOrigin() - target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion10, 3, target:GetAbsOrigin() - target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion10, 11, target:GetAbsOrigin() - target:GetForwardVector()*1200)
        ParticleManager:SetParticleControl(explosion10, 12, caster:GetAbsOrigin())

        local explosion12 = ParticleManager:CreateParticle("particles/punch_cracks.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(explosion12, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion12, 1,  Vector(200, 200, 0))
        ParticleManager:SetParticleControl(explosion12, 3,  caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion12, 11,  caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(explosion12, 12,  caster:GetAbsOrigin())

        EmitSoundOn( "Hero_EarthShaker.EchoSlam", hTarget )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", hTarget )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", hTarget )
        EmitSoundOn( "PudgeWarsClassic.echo_slam", hTarget )
        local bonus = 0
        if ability.time_walk_traveled_distance then
          bonus = (ability.time_walk_traveled_distance / self:GetSpecialValueFor("damage"))
        end

        if not self:GetCaster():IsNull() then
          local damage = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = (self.start_speed * (self:GetSpecialValueFor("damage")/100)) + bonus,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self
          }
          ApplyDamage( damage )
        end
        return nil
      end
      end)
      if caster:GetModelName() == "models/heroes/hero_zoom/speed_wraith/blackflash.vmdl" then
        EmitSoundOn( "Hero_Spectre.Haunt", caster )
        EmitSoundOn( "Hero_Spectre.Reality", caster )
        EmitSoundOn( "Hero_Undying.FleshGolem.Cast", caster )
        EmitSoundOn( "Hero_Oracle.FalsePromise.FP", caster )
      end
    end
    EmitSoundOn( "Hero_Spirit_Breaker.ChargeOfDarkness.FP", self:GetCaster() )
  end
end


if modifier_arcana_darkness == nil then modifier_arcana_darkness = class({}) end


function modifier_arcana_darkness:IsPurgable()
  return false
end

function modifier_arcana_darkness:RemoveOnDeath()
  return true
end

function modifier_arcana_darkness:IsHidden()
  return true
end


function modifier_arcana_darkness:GetEffectName()
  if self:GetCaster():HasModifier("modifier_zoom_kalyaska") then return "particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon_flying.vpcf" end
  return "particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_iron.vpcf"
end

function modifier_arcana_darkness:GetEffectAttachType()
  return PATTACH_CUSTOMORIGIN_FOLLOW
end
