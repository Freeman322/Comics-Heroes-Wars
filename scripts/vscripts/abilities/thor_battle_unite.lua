LinkLuaModifier("modifier_thor_battle_unite", "abilities/thor_battle_unite.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_thor_battle_unite_aura", "abilities/thor_battle_unite.lua", LUA_MODIFIER_MOTION_NONE)

thor_battle_unite = class({})

function thor_battle_unite:GetIntrinsicModifierName() return "modifier_thor_battle_unite_aura" end

modifier_thor_battle_unite_aura = class({})

function modifier_thor_battle_unite_aura:IsAura()	return true end
function modifier_thor_battle_unite_aura:GetStatusEffectName() return "particles/units/heroes/hero_visage/status_effect_visage_chill_slow.vpcf" end
function modifier_thor_battle_unite_aura:StatusEffectPriority()	return 1000 end
function modifier_thor_battle_unite_aura:GetHeroEffectName() return "particles/units/heroes/hero_chaos_knight/chaos_knight_cast_hero_effect.vpcf" end
function modifier_thor_battle_unite_aura:HeroEffectPriority()	return 100 end
function modifier_thor_battle_unite_aura:IsHidden()	return true end
function modifier_thor_battle_unite_aura:IsPurgable()	return false end
function modifier_thor_battle_unite_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_thor_battle_unite_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_thor_battle_unite_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_thor_battle_unite_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_thor_battle_unite_aura:GetModifierAura() return "modifier_thor_battle_unite" end
modifier_thor_battle_unite = class({})

function modifier_thor_battle_unite:IsPurgable() return false end
function modifier_thor_battle_unite:IsHidden() return true end
function modifier_thor_battle_unite:DeclareFunctions() return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS	} end
function modifier_thor_battle_unite:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("armor_reduction") * -1 end

function modifier_thor_battle_unite:GetModifierMagicalResistanceBonus()
  if IsServer() then
    if self:GetCaster():HasTalent("special_bonus_unique_thor_1") then
       return (self:GetAbility():GetSpecialValueFor("magic_resistance") + self:GetCaster():FindTalentValue("special_bonus_unique_thor_1")) * -1
    end
  end
  return self:GetAbility():GetSpecialValueFor("magic_resistance") * -1
end
