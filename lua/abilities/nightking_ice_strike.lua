if nightking_ice_strike == nil then nightking_ice_strike = class({}) end

LinkLuaModifier("modifier_nightking_ice_strike", "abilities/nightking_ice_strike", LUA_MODIFIER_MOTION_NONE)

function nightking_ice_strike:GetIntrinsicModifierName()
  return "modifier_nightking_ice_strike"
end

function nightking_ice_strike:OnProjectileHit(hTarget, vLocation)
  if IsServer() then
    self:GetCaster():PerformAttack(hTarget, true, false, true, false, false, false, true)
    ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = self:GetSpecialValueFor("bonus_damage"), damage_type = self:GetAbilityDamageType()})

    EmitSoundOn("Hero_Lich.FrostBlast.Immortal", hTarget)
  end
end

if modifier_nightking_ice_strike == nil then modifier_nightking_ice_strike = class({}) end

function modifier_nightking_ice_strike:IsHidden()
  return false
end

function modifier_nightking_ice_strike:IsPurgable()
  return false
end

function modifier_nightking_ice_strike:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED,
  }

  return funcs
end

function modifier_nightking_ice_strike:OnAttackLanded( params )
  if IsServer() then
    if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
      if self:GetParent():PassivesDisabled() then
        return 0
      end
      if self:GetAbility():IsCooldownReady() then
        local target = params.target
        if target ~= nil and target:IsBuilding() == false then
            self:CheckAngels(params)
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
        end
      end
    end
  end

  return 0
end

function modifier_nightking_ice_strike:CheckAngels( params )
  if IsServer() then
    local caster = params.attacker
    local target = params.target

    local first_target_origin = target:GetAbsOrigin()
    local caster_origin_difference = caster:GetAbsOrigin() - first_target_origin
    local caster_origin_difference_radian = math.atan2(caster_origin_difference.y, caster_origin_difference.x)
    caster_origin_difference_radian = caster_origin_difference_radian * 180
    local attacker_angle = caster_origin_difference_radian / math.pi
    attacker_angle = attacker_angle + 180.0

    local radius = self:GetAbility():GetSpecialValueFor("attack_spill_range")
    local attack_spill_width = self:GetAbility():GetSpecialValueFor("attack_spill_width") 

    local units = FindUnitsInRadius(caster:GetTeamNumber(), first_target_origin, nil, radius, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), 0, 0, false)

    for i,unit in ipairs(units) do
      if unit ~= target then

        local target_origin_difference = target:GetAbsOrigin() - unit:GetAbsOrigin()

        -- Get the radian of the origin difference between the last target and the unit. We use this to figure out at what angle the unit is at relative to the the target.
        local target_origin_difference_radian = math.atan2(target_origin_difference.y, target_origin_difference.x)

        -- Convert the radian to degrees.
        target_origin_difference_radian = target_origin_difference_radian * 180
        local victim_angle = target_origin_difference_radian / math.pi
        -- Turns negative angles into positive ones and make the math simpler.
        victim_angle = victim_angle + 180.0

        -- The difference between the world angle of the caster-target vector and the target-unit vector
        local angle_difference = math.abs(victim_angle - attacker_angle)

        local new_target = false

        -- Ensures the angle difference is less than the allowed width
        if angle_difference <= attack_spill_width then
            print(angle_difference <= attack_spill_width)
          local info = {
            Target = unit,
            Source = target,
            Ability = self:GetAbility(),
            EffectName = "particles/units/heroes/hero_winter_wyvern/winter_wyvern_arctic_attack.vpcf",
            bDodgeable = false,
            iMoveSpeed = 2000,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
          }
          ProjectileManager:CreateTrackingProjectile( info )

          new_target = true
        end
      end
    end
  end
end