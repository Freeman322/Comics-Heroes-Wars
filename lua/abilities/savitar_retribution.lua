if savitar_retribution == nil then savitar_retribution = class({}) end

LinkLuaModifier( "modifier_savitar_retribution", "abilities/savitar_retribution.lua", LUA_MODIFIER_MOTION_NONE )

function savitar_retribution:GetIntrinsicModifierName()
  return "modifier_savitar_retribution"
end

if modifier_savitar_retribution == nil then modifier_savitar_retribution = class({}) end

function modifier_savitar_retribution:IsHidden()
  return true
end

function modifier_savitar_retribution:IsPurgable()
  return false
end

function modifier_savitar_retribution:GetPriority()
  return MODIFIER_PRIORITY_ULTRA
end

function modifier_savitar_retribution:GetStatusEffectName()
  return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end

function modifier_savitar_retribution:StatusEffectPriority()
  return 1000
end

function modifier_savitar_retribution:DeclareFunctions ()
  local funcs = {
    MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }

  return funcs
end

function modifier_savitar_retribution:OnTakeDamage( params )
  if IsServer() then
    if params.unit == self:GetParent() then
      local target = params.attacker
      if target == self:GetParent() then
        return
      end
      if self:GetAbility():IsCooldownReady() == false then
        return
      end
      if self:GetParent():GetHealth() <= 10 then
        return
      end
      if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
        local damage = self:GetAbility():GetAbilityDamage()
        if (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= 250 then
          target:ModifyHealth(target:GetHealth() - damage, self:GetAbility(), true, 0)
          self:GetCaster():Heal(params.damage, self:GetAbility())
          self:TeleportCaster(target)
          self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
        end
      end
    end
  end
end

function modifier_savitar_retribution:TeleportCaster(target)
  if IsServer() then
    local victim_angle = target:GetAnglesAsVector()
    local victim_forward_vector = target:GetForwardVector()
    local victim_angle_rad = victim_angle.y*math.pi/180
    local victim_position = target:GetAbsOrigin()
    local attacker_new = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)

    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start_sparkles.vpcf", PATTACH_CUSTOMORIGIN, nil );
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true );
    ParticleManager:ReleaseParticleIndex( nFXIndex );
    EmitSoundOn("Hero_Spectre.Reality", self:GetCaster())

    self:GetCaster():SetAbsOrigin(attacker_new)
    FindClearSpaceForUnit(self:GetCaster(), attacker_new, true)
    self:GetCaster():SetForwardVector(victim_forward_vector)
  end
end

function modifier_savitar_retribution:GetModifierTurnRate_Percentage(params)
  return	self:GetAbility():GetSpecialValueFor("turn_rate")
end

function savitar_retribution:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

