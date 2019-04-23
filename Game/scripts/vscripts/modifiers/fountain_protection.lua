LinkLuaModifier("modifier_fountain_protection", "modifiers/fountain_protection.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fountain_protection_aura", "modifiers/fountain_protection.lua", LUA_MODIFIER_MOTION_NONE)

fountain_protection = class({})

function fountain_protection:GetCastRange() return 1200 end
function fountain_protection:GetIntrinsicModifierName() return "modifier_fountain_protection" end

modifier_fountain_protection = class({})

function modifier_fountain_protection:IsHidden() return true end
function modifier_fountain_protection:IsAura() return true end
function modifier_fountain_protection:IsPurgable() return false end

function modifier_fountain_protection:OnCreated()
  self.say = false
  self:StartIntervalThink(0.1)
end


function modifier_fountain_protection:OnIntervalThink()
  if IsServer() then
    local time_to_off = GameRules:GetGameTime() - 120 >= 60 * self:GetAbility():GetSpecialValueFor("time_to_off")
    local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 16 + 64 + 262144, 0, false )
    for _, target in pairs(enemies) do
      local particle = ParticleManager:CreateParticle("particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf", 0, self:GetParent())
      ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
      target:EmitSound("Hero_Lina.LagunaBlade.Immortal")
      if not time_to_off then
        target:ForceKill(false)
        target:Destroy()
      else
        target:SetHealth(target:GetHealth() - target:GetMaxHealth() * 0.02)
        if target:GetHealth() < 1 then
          target:ForceKill(false)
        end
        target:Purge(true, false, false, false, false)
      end
    end
    if time_to_off and self.say == false then
      GameRules:SendCustomMessage("<font color=\"#F80000\">Fountain protection disabled.</font>", 0, 0)
      self.say = true
    end
  end
end

function modifier_fountain_protection:GetAuraRadius()	return 1200 end
function modifier_fountain_protection:GetAuraDuration() return 0.5 end
function modifier_fountain_protection:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_fountain_protection:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_fountain_protection:GetModifierAura() return "modifier_fountain_protection_aura" end

modifier_fountain_protection_aura = class({})

function modifier_fountain_protection_aura:OnCreated() self:StartIntervalThink(FrameTime()) end
function modifier_fountain_protection_aura:OnIntervalThink() if IsServer() then self:GetParent():Purge(false, true, false, true, false) end end
function modifier_fountain_protection_aura:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE, MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_fountain_protection_aura:CheckState()
local time_to_off = GameRules:GetGameTime() - 120 >= 60 * self:GetAbility():GetSpecialValueFor("time_to_off")
  if not time_to_off then
    return {MODIFIER_STATE_INVULNERABLE, MODIFIER_STATE_NO_HEALTH_BAR, MODIFIER_STATE_NO_UNIT_COLLISION, MODIFIER_STATE_ATTACK_IMMUNE, MODIFIER_STATE_MAGIC_IMMUNE, MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES, MODIFIER_STATE_TRUESIGHT_IMMUNE, MODIFIER_STATE_CANNOT_MISS}
  end
  return
end
function modifier_fountain_protection_aura:GetModifierHealthRegenPercentage()
local time_to_off = GameRules:GetGameTime() - 120 >= 60 * self:GetAbility():GetSpecialValueFor("time_to_off")
  if not time_to_off then
    return self:GetAbility():GetSpecialValueFor("health_regen_pct")
  end
  return self:GetAbility():GetSpecialValueFor("healrh_regen_pct_off")
end
function modifier_fountain_protection_aura:GetModifierTotalPercentageManaRegen()
local time_to_off = GameRules:GetGameTime() - 120 >= 60 * self:GetAbility():GetSpecialValueFor("time_to_off")
  if not time_to_off then
    return self:GetAbility():GetSpecialValueFor("mana_regen_pct")
  end
  return self:GetAbility():GetSpecialValueFor("mana_regen_pct_off")
end
function modifier_fountain_protection_aura:GetModifierTotalDamageOutgoing_Percentage()
local time_to_off = GameRules:GetGameTime() - 120 >= 60 * self:GetAbility():GetSpecialValueFor("time_to_off")
  if not time_to_off then
    return self:GetAbility():GetSpecialValueFor("outgoing_damage_reduction") * -1
  end
  return self:GetAbility():GetSpecialValueFor("outgoing_damage_reduction_off") * -1
end
function modifier_fountain_protection_aura:GetModifierIncomingDamage_Percentage()
local time_to_off = GameRules:GetGameTime() - 120 >= 60 * self:GetAbility():GetSpecialValueFor("time_to_off")
  if not time_to_off then
    return self:GetAbility():GetSpecialValueFor("incoming_damage_reduction") * -1
  end
  return self:GetAbility():GetSpecialValueFor("incoming_damage_reduction_off") * -1
end
function modifier_fountain_protection_aura:GetEffectName() return "particles/econ/events/ti7/fountain_regen_ti7_lvl3.vpcf" end
function modifier_fountain_protection_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
