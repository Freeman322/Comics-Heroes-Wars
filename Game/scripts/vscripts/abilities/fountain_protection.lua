LinkLuaModifier("modifier_fountain_protection", "abilities/fountain_protection.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fountain_protection_aura", "abilities/fountain_protection.lua", LUA_MODIFIER_MOTION_NONE)

local CONST_DAMAGE_OUTGOING_PTC = -100

fountain_protection = class({})

function fountain_protection:GetCastRange() return 1200 end
function fountain_protection:GetIntrinsicModifierName() return "modifier_fountain_protection" end

modifier_fountain_protection = class({})

function modifier_fountain_protection:IsHidden() return true end
function modifier_fountain_protection:IsAura() return true end
function modifier_fountain_protection:IsPurgable() return false end
function modifier_fountain_protection:GetAuraRadius()	return 1200 end
function modifier_fountain_protection:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_fountain_protection:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_fountain_protection:GetModifierAura() return "modifier_fountain_protection_aura" end

modifier_fountain_protection_aura = class({})

function modifier_fountain_protection_aura:OnCreated() self:ChechForTarget() end
function modifier_fountain_protection_aura:DeclareFunctions() return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE} end
function modifier_fountain_protection_aura:GetEffectName() return "particles/econ/events/ti7/fountain_regen_ti7_lvl3.vpcf" end
function modifier_fountain_protection_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_fountain_protection_aura:GetModifierTotalDamageOutgoing_Percentage() return CONST_DAMAGE_OUTGOING_PTC end

function modifier_fountain_protection_aura:ChechForTarget()
  if IsServer() then
    if not self:GetParent():IsFriendly(self:GetCaster()) then
      self:GetParent():ForceKill(true) self:Destroy() return
    end
  end
end

function modifier_fountain_protection_aura:CheckState()
  if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return {[MODIFIER_STATE_INVULNERABLE] = true} end
	return
end
