LinkLuaModifier ("modifier_tzeentch_warp_god", "abilities/tzeentch_warp_god.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_tzeentch_warp_god_passive", "abilities/tzeentch_warp_god.lua", LUA_MODIFIER_MOTION_NONE)

tzeentch_warp_god = class({})

function tzeentch_warp_god:GetIntrinsicModifierName()	return "modifier_tzeentch_warp_god" end

modifier_tzeentch_warp_god = class({})

function modifier_tzeentch_warp_god:IsAura()	return true end
function modifier_tzeentch_warp_god:IsHidden()	return true end
function modifier_tzeentch_warp_god:IsPurgable()	return false end
function modifier_tzeentch_warp_god:GetAuraRadius()	return 99999 end
function modifier_tzeentch_warp_god:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_tzeentch_warp_god:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_tzeentch_warp_god:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_tzeentch_warp_god:GetModifierAura()	return "modifier_tzeentch_warp_god_passive" end

modifier_tzeentch_warp_god_passive = class({})

function modifier_tzeentch_warp_god_passive:IsPurgable() return false end

function modifier_tzeentch_warp_god_passive:DeclareFunctions()
    return { MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
        		 MODIFIER_PROPERTY_MANA_REGEN_CONSTANT }
end

function modifier_tzeentch_warp_god_passive:GetModifierTotalPercentageManaRegen()
    return self:GetAbility():GetSpecialValueFor("mana_regen_pct")
end
