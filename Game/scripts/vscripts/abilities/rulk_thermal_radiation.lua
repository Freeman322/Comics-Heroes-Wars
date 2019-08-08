LinkLuaModifier("modifier_rulk_thermal_radiation", "abilities/rulk_thermal_radiation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rulk_thermal_radiation_aura", "abilities/rulk_thermal_radiation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rulk_thermal_radiation_stacks", "abilities/rulk_thermal_radiation.lua", LUA_MODIFIER_MOTION_NONE)

rulk_thermal_radiation = class({})

function rulk_thermal_radiation:GetIntrinsicModifierName() return "modifier_rulk_thermal_radiation" end

modifier_rulk_thermal_radiation = class({})

function modifier_rulk_thermal_radiation:IsHidden() return true end
function modifier_rulk_thermal_radiation:IsAura() return true end
function modifier_rulk_thermal_radiation:IsPurgable() return false end
function modifier_rulk_thermal_radiation:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_rulk_thermal_radiation:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_rulk_thermal_radiation:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_rulk_thermal_radiation:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_rulk_thermal_radiation:GetModifierAura() return "modifier_rulk_thermal_radiation_aura" end
function modifier_rulk_thermal_radiation:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_rulk_thermal_radiation:OnTakeDamage(params)
  if params.unit == self:GetParent() and params.attacker:IsRealHero() and not self:GetParent():PassivesDisabled() then
    if not self:GetCaster():HasModifier("modifier_rulk_thermal_radiation_stacks") then
      self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_rulk_thermal_radiation_stacks", {duration = self:GetAbility():GetSpecialValueFor("stack_duration")})
      self:GetCaster():FindModifierByName("modifier_rulk_thermal_radiation_stacks"):SetStackCount(1)
    else
      self:GetCaster():FindModifierByName("modifier_rulk_thermal_radiation_stacks"):IncrementStackCount()
      self:GetCaster():FindModifierByName("modifier_rulk_thermal_radiation_stacks"):SetDuration(self:GetAbility():GetSpecialValueFor("stack_duration"), false)
    end
  end
end

function modifier_rulk_thermal_radiation:GetEffectName() return "particles/econ/events/ti6/radiance_owner_ti6.vpcf" end
function modifier_rulk_thermal_radiation:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

modifier_rulk_thermal_radiation_aura = class({})

function modifier_rulk_thermal_radiation_aura:IsHidden() return true end
function modifier_rulk_thermal_radiation_aura:OnCreated() self:StartIntervalThink(0.1) end

function modifier_rulk_thermal_radiation_aura:OnIntervalThink()
  if IsServer() and not self:GetParent():PassivesDisabled() then
    if self:GetCaster():HasModifier("modifier_rulk_thermal_radiation_stacks") then
      ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = (self:GetAbility():GetSpecialValueFor("base_damage") + self:GetCaster():FindModifierByName("modifier_rulk_thermal_radiation_stacks"):GetStackCount()) / 10, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self})
    else
      ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetAbility():GetSpecialValueFor("base_damage") / 10, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self})
    end
  end
end

function modifier_rulk_thermal_radiation_aura:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf" end
function modifier_rulk_thermal_radiation_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

modifier_rulk_thermal_radiation_stacks = class({})

function modifier_rulk_thermal_radiation_stacks:IsHidden() return false end
function modifier_rulk_thermal_radiation_stacks:IsPurgable() return false end
function modifier_rulk_thermal_radiation_stacks:OnDestroy() if IsServer() then if self:GetCaster():HasModifier("modifier_rulk_thermal_radiation_stacks") then self:GetCaster():FindModifierByName("modifier_rulk_thermal_radiation_stacks"):SetStackCount(0) end end end
function modifier_rulk_thermal_radiation_stacks:GetTexture() return "custom/rulk_exile" end
