LinkLuaModifier("modifier_draks_unholy_strength", "abilities/draks_unholy_strength.lua", LUA_MODIFIER_MOTION_NONE)

draks_unholy_strength = class({})

function draks_unholy_strength:GetIntrinsicModifierName()
    return "modifier_draks_unholy_strength"
end

modifier_draks_unholy_strength = class({})

function modifier_draks_unholy_strength:IsHidden() return true end
function modifier_draks_unholy_strength:IsPurgable() return false end

function modifier_draks_unholy_strength:DeclareFunctions()
  return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

function modifier_draks_unholy_strength:GetModifierConstantHealthRegen()
  local regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
  if self:GetCaster():HasScepter() then
    regen = regen + (GameRules:GetGameTime() / 60) * self:GetAbility():GetSpecialValueFor("scepter_regen_per_minute")
    if GameRules:GetGameTime() > 0 then
    end
  end
  return regen
end

function modifier_draks_unholy_strength:GetModifierBonusStats_Strength()
  return self:GetAbility():GetSpecialValueFor("bonus_strength")
end
