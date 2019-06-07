LinkLuaModifier("modifier_sam_charged_strike", "abilities/sam_charged_strike.lua", LUA_MODIFIER_MOTION_NONE)

sam_charged_strike = class({})

function sam_charged_strike:GetBehavior()
  return self:GetLevel() == 4 and DOTA_ABILITY_BEHAVIOR_POINT or DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

function sam_charged_strike:GetChannelTime()
  if self:GetLevel() == 4 then return 0 end
  return self:GetSpecialValueFor("channel_time")
end

function sam_charged_strike:OnSpellStart()
  if self:GetLevel() == 4 then
    local vDirection = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized()

    local particle = "particles/sam/magnataur_shockwave.vpcf"
		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alisa") == true then particle = "particles/jetstream_alisa.vpcf" EmitSoundOn("Alisa.First.Impact", self:GetCaster()) end 

    ProjectileManager:CreateLinearProjectile({
      EffectName = particle,
      Ability = self,
      vSpawnOrigin = self:GetCaster():GetOrigin(),
      fStartRadius = self:GetSpecialValueFor("wave_width"),
      fEndRadius = self:GetSpecialValueFor("wave_width"),
      vVelocity = vDirection * self:GetSpecialValueFor("wave_speed"),
      fDistance = self:GetCastRange(self:GetCaster():GetOrigin(), self:GetCaster()),
      Source = self:GetCaster(),
      iUnitTargetTeam = self:GetAbilityTargetTeam(),
      iUnitTargetType = self:GetAbilityTargetType(),
      iUnitTargetFlags = self:GetAbilityTargetFlags(),
      bProvidesVision = true,
      iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
      iVisionRadius = self:GetSpecialValueFor("wave_width"),
    })
    EmitSoundOn("Hero_StormSpirit.Orchid_BallLightning", self:GetCaster())

  else
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sam_charged_strike", {duration = self:GetChannelTime()})

  end
end

function sam_charged_strike:OnChannelFinish(bInterrupted)
  if not bInterrupted then

    local particle = "particles/sam/magnataur_shockwave.vpcf"
    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alisa") == true then particle = "particles/jetstream_alisa.vpcf" end 


    local vDirection = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Normalized()
    ProjectileManager:CreateLinearProjectile({
      EffectName = particle,
      Ability = self,
      vSpawnOrigin = self:GetCaster():GetOrigin(),
      fStartRadius = self:GetSpecialValueFor("wave_width"),
      fEndRadius = self:GetSpecialValueFor("wave_width"),
      vVelocity = vDirection * self:GetSpecialValueFor("wave_speed"),
      fDistance = self:GetCastRange(self:GetCaster():GetOrigin(), self:GetCaster()),
      Source = self:GetCaster(),
      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
      iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      iUnitTargetFlags = 0,
      bProvidesVision = true,
      iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
      iVisionRadius = self:GetSpecialValueFor("wave_width"),
    })
    EmitSoundOn("Hero_StormSpirit.Orchid_BallLightning", self:GetCaster())
  else

    self:GetCaster():RemoveModifierByName("modifier_sam_charged_strike")
  end
end

function sam_charged_strike:OnProjectileHit( hTarget, vLocation )
  if hTarget ~= nil then
    local ult = false;  if self:GetCaster():HasModifier("modifier_sam_bladerun_buff") then ult = true end
    local attack_count = self:GetSpecialValueFor("attack_count") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_sam_charged_strike_bonus_attack") or 0)
    for attack = 1, attack_count do
      self:GetCaster():PerformAttack(hTarget, ult, true, false, true, false, false, true)
    end
    ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = self:GetSpecialValueFor("damage"), damage_type = self:GetAbilityDamageType(), ability = self})
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
  end
end

modifier_sam_charged_strike = class({})
function modifier_sam_charged_strike:IsHidden() return true end
function modifier_sam_charged_strike:IsPurgable() return false end
