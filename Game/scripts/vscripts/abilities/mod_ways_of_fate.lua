LinkLuaModifier ("modifier_mod_ways_of_fate", 				"abilities/mod_ways_of_fate.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_mod_ways_of_fate_passive", "abilities/mod_ways_of_fate.lua", LUA_MODIFIER_MOTION_NONE)

mod_ways_of_fate = class ({})

function mod_ways_of_fate:GetIntrinsicModifierName() return "modifier_mod_ways_of_fate" end

modifier_mod_ways_of_fate = class({})

function modifier_mod_ways_of_fate:IsAura() return true end
function modifier_mod_ways_of_fate:IsHidden() return true end
function modifier_mod_ways_of_fate:IsPurgable()	return true end
function modifier_mod_ways_of_fate:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_mod_ways_of_fate:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_mod_ways_of_fate:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_mod_ways_of_fate:GetAuraSearchFlags() return 0 end
function modifier_mod_ways_of_fate:GetModifierAura() return "modifier_mod_ways_of_fate_passive" end

modifier_mod_ways_of_fate_passive = class({})

function modifier_mod_ways_of_fate_passive:IsPurgable() return false end
function modifier_mod_ways_of_fate_passive:IsHidden() return true end

function modifier_mod_ways_of_fate_passive:DeclareFunctions() 
     local funcs = {
          MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
     }
     return funcs
 end
 
 function modifier_mod_ways_of_fate_passive:GetModifierSpellAmplify_Percentage( params )
     return RandomInt(self:GetAbility():GetSpecialValueFor("damage_min"), self:GetAbility():GetSpecialValueFor("damage_max"))
 end
 