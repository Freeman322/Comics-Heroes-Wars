LinkLuaModifier ("modifier_kyloren_ways_of_faith", 				"abilities/kyloren_ways_of_faith.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_kyloren_ways_of_faith_passive", "abilities/kyloren_ways_of_faith.lua", LUA_MODIFIER_MOTION_NONE)

if kyloren_ways_of_faith == nil then kyloren_ways_of_faith = class({}) end

function kyloren_ways_of_faith:GetIntrinsicModifierName()
	return "modifier_kyloren_ways_of_faith"
end

if modifier_kyloren_ways_of_faith == nil then modifier_kyloren_ways_of_faith = class({}) end

function modifier_kyloren_ways_of_faith:IsAura() return true end
function modifier_kyloren_ways_of_faith:IsHidden() return true end
function modifier_kyloren_ways_of_faith:IsPurgable() return false end
function modifier_kyloren_ways_of_faith:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_kyloren_ways_of_faith:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_kyloren_ways_of_faith:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_kyloren_ways_of_faith:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_kyloren_ways_of_faith:GetModifierAura() return "modifier_kyloren_ways_of_faith_passive" end

if modifier_kyloren_ways_of_faith_passive == nil then modifier_kyloren_ways_of_faith_passive = class({}) end
function modifier_kyloren_ways_of_faith_passive:IsHidden() return true end
function modifier_kyloren_ways_of_faith_passive:IsPurgable() return false end
function modifier_kyloren_ways_of_faith_passive:DeclareFunctions() return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE} end
function modifier_kyloren_ways_of_faith_passive:GetModifierDamageOutgoing_Percentage( params ) return self:GetAbility():GetSpecialValueFor("damage_reduction_pct") * (-1) end
