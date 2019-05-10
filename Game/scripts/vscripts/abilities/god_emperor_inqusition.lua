LinkLuaModifier ("modifier_god_emperor_inqusition", 				"abilities/god_emperor_inqusition.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_god_emperor_inqusition_passive", "abilities/god_emperor_inqusition.lua", LUA_MODIFIER_MOTION_NONE)
god_emperor_inqusition = class ({})

function god_emperor_inqusition:GetIntrinsicModifierName() return "modifier_god_emperor_inqusition" end

modifier_god_emperor_inqusition = class({})

function modifier_god_emperor_inqusition:IsAura() return true end
function modifier_god_emperor_inqusition:IsHidden() return true end
function modifier_god_emperor_inqusition:IsPurgable()	return true end
function modifier_god_emperor_inqusition:GetAuraRadius() return 99999 end
function modifier_god_emperor_inqusition:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_god_emperor_inqusition:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_god_emperor_inqusition:GetAuraSearchFlags()	return 0 end
function modifier_god_emperor_inqusition:GetModifierAura() return "modifier_god_emperor_inqusition_passive" end

modifier_god_emperor_inqusition_passive = class({})

function modifier_god_emperor_inqusition_passive:IsPurgable() return false end
function modifier_god_emperor_inqusition_passive:DeclareFunctions() return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE} end

function modifier_god_emperor_inqusition_passive:GetModifierDamageOutgoing_Percentage(params)
	local distance = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()
	if self:GetParent():IsCreep() and distance > self:GetAbility():GetSpecialValueFor("creep_dist") then
		return 0
	end
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
