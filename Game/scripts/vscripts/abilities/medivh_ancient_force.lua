LinkLuaModifier ("modifier_medivh_ancient_force", "abilities/medivh_ancient_force.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_medivh_ancient_force_passive", "abilities/medivh_ancient_force.lua", LUA_MODIFIER_MOTION_NONE)

medivh_ancient_force = class({})

function medivh_ancient_force:GetIntrinsicModifierName() return "modifier_medivh_ancient_force" end

modifier_medivh_ancient_force = class({})

function modifier_medivh_ancient_force:IsAura()	return true end
function modifier_medivh_ancient_force:IsHidden()	return true end
function modifier_medivh_ancient_force:IsPurgable() return false end
function modifier_medivh_ancient_force:GetAuraRadius() return 99999 end
function modifier_medivh_ancient_force:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_medivh_ancient_force:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_medivh_ancient_force:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_medivh_ancient_force:GetModifierAura() return "modifier_medivh_ancient_force_passive" end

modifier_medivh_ancient_force_passive = class({})

function modifier_medivh_ancient_force_passive:IsHidden() return false end
function modifier_medivh_ancient_force_passive:IsPurgable() return false end
function modifier_medivh_ancient_force_passive:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf" end
function modifier_medivh_ancient_force_passive:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_medivh_ancient_force_passive:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
				MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
end

function modifier_medivh_ancient_force_passive:GetModifierAttackSpeedBonus_Constant()
  local distance = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()
	if self:GetParent():IsCreep() and distance <= self:GetAbility():GetSpecialValueFor("creep_radius") then
		return self:GetAbility():GetSpecialValueFor("creep_attack_speed")
	end
end

function modifier_medivh_ancient_force_passive:GetModifierPhysicalArmorBonus()
  local distance = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()
	if self:GetParent():IsCreep() and distance <= self:GetAbility():GetSpecialValueFor("creep_radius") then
		return self:GetAbility():GetSpecialValueFor("creep_armor")
	end
end

function modifier_medivh_ancient_force_passive:GetModifierSpellAmplify_Percentage()
	if not self:GetParent():IsCreep() then return self:GetAbility():GetSpecialValueFor("spell_amp") end
end
