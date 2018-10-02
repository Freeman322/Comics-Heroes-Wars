if thanos_believer == nil then thanos_believer = class({}) end

LinkLuaModifier( "modifier_thanos_believer", "abilities/thanos_believer.lua", LUA_MODIFIER_MOTION_NONE )

function thanos_believer:GetIntrinsicModifierName()
  return "modifier_thanos_believer"
end

if modifier_thanos_believer == nil then modifier_thanos_believer = class({}) end

function modifier_thanos_believer:IsHidden()
  return true
end

function modifier_thanos_believer:IsPurgable()
  return false
end

function modifier_thanos_believer:GetPriority()
  return MODIFIER_PRIORITY_ULTRA
end

