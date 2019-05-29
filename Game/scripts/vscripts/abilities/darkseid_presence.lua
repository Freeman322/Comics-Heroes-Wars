LinkLuaModifier("modifier_darkseid_presence", "abilities/darkseid_presence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_darkseid_presence_aura", "abilities/darkseid_presence.lua", LUA_MODIFIER_MOTION_NONE)

darkseid_presence = class({})

function darkseid_presence:GetIntrinsicModifierName()
  return "modifier_darkseid_presence"
end

modifier_darkseid_presence = class({})

function modifier_darkseid_presence:IsAura() return true end
function modifier_darkseid_presence:IsHidden() return true end
function modifier_darkseid_presence:IsPurgable() return false end
function modifier_darkseid_presence:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("presence_radius") end
function modifier_darkseid_presence:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_darkseid_presence:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_darkseid_presence:GetAuraSearchFlags() return 0 end

function modifier_darkseid_presence:GetModifierAura() return "modifier_darkseid_presence_aura" end

modifier_darkseid_presence_aura = class({})

function modifier_darkseid_presence_aura:IsHidden() return false end
function modifier_darkseid_presence_aura:IsPurgable() return false end
function modifier_darkseid_presence_aura:DeclareFunctions()
  return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE }
end

function modifier_darkseid_presence_aura:GetModifierPhysicalArmorBonus()
  return self:GetAbility():GetSpecialValueFor("presence_armor_reduction") * -1
end
function modifier_darkseid_presence_aura:GetModifierDamageOutgoing_Percentage()
  return self:GetAbility():GetSpecialValueFor("presence_damage_reduction") * -1
end
