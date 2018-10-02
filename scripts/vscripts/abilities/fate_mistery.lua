LinkLuaModifier ("modifier_fate_mistery", 				"abilities/fate_mistery.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_fate_mistery_passive", 		"abilities/fate_mistery.lua", LUA_MODIFIER_MOTION_NONE)
if fate_mistery == nil then fate_mistery = class({}) end

function fate_mistery:GetIntrinsicModifierName()
	return "modifier_fate_mistery"
end

if modifier_fate_mistery == nil then modifier_fate_mistery = class({}) end

function modifier_fate_mistery:IsAura()
	return true
end

function modifier_fate_mistery:IsHidden()
	return true
end

function modifier_fate_mistery:IsPurgable()
	return true
end

function modifier_fate_mistery:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_fate_mistery:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_fate_mistery:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_fate_mistery:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_fate_mistery:GetModifierAura()
	return "modifier_fate_mistery_passive"
end

if modifier_fate_mistery_passive == nil then modifier_fate_mistery_passive = class({}) end

function modifier_fate_mistery_passive:IsDebuff()
    return self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber()
end

function modifier_fate_mistery_passive:IsPurgable(  )
    return false
end

function modifier_fate_mistery_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }

    return funcs
end

function modifier_fate_mistery_passive:GetModifierPercentageManacost (params)
    if self:IsDebuff() then 
        return self:GetAbility():GetSpecialValueFor ("manacost") * (-1)
    end 
    return self:GetAbility():GetSpecialValueFor ("manacost") 
end

function modifier_fate_mistery_passive:GetModifierMagicalResistanceBonus (params)
    if self:IsDebuff() then 
        return self:GetAbility():GetSpecialValueFor ("magical_armor") * (-1)
    end 
    return self:GetAbility():GetSpecialValueFor ("magical_armor") 
end
