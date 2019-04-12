LinkLuaModifier("modifier_fountain", "modifiers/modifier_fountain.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fountain_protection", "modifiers/modifier_fountain.lua", LUA_MODIFIER_MOTION_NONE)

HP_PERCENT_REGEN = 50
DAMAGE_REDUCTION = -100

modifier_fountain = class({})

function modifier_fountain:IsAura() return true end
function modifier_fountain:IsHidden() return true end
function modifier_fountain:IsPurgable()	return false end
function modifier_fountain:GetAuraRadius() return 1200 end
function modifier_fountain:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_fountain:GetAuraSearchType() return DOTA_UNIT_TARGET_ALL end

function modifier_fountain:GetModifierAura()
	return "modifier_fountain_protection"
end

modifier_fountain_protection = class({})

function modifier_fountain_protection:IsPurgable() return false end
function modifier_fountain_protection:IsHidden() return true end
function modifier_fountain_protection:DeclareFunctions() return { MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE } end
function modifier_fountain_protection:GetModifierHealthRegenPercentage(params) return HP_PERCENT_REGEN end
function modifier_fountain_protection:GetDuration() return -1 end
function modifier_fountain_protection:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
