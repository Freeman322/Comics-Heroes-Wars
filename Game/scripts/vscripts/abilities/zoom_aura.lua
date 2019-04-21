LinkLuaModifier ("modifier_zoom_aura", "abilities/zoom_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_zoom_aura_passive", "abilities/zoom_aura.lua", LUA_MODIFIER_MOTION_NONE)

zoom_aura = class({})

function zoom_aura:GetIntrinsicModifierName()
	return "modifier_zoom_aura"
end

modifier_zoom_aura = class({})
function modifier_zoom_aura:IsAura() return true end
function modifier_zoom_aura:IsHidden() return true end
function modifier_zoom_aura:IsPurgable() return true end
function modifier_zoom_aura:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_zoom_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_zoom_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_zoom_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_zoom_aura:GetModifierAura() return "modifier_zoom_aura_passive" end

modifier_zoom_aura_passive = class({})
function modifier_zoom_aura_passive:IsPurgable() return false end
function modifier_zoom_aura_passive:IsHidden() return true end


function modifier_zoom_aura_passive:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_zoom_aura_passive:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("attack_speed_bonus") * -1
end

function modifier_zoom_aura_passive:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("speed_bonus") * -1
end

function zoom_aura:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_doomsday_clock") then return "custom/reverse_speed_passive" end
	return self.BaseClass.GetAbilityTextureName(self)
end
