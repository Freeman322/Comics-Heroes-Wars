LinkLuaModifier ("modifier_tzeentch_warp_god", "abilities/tzeentch_warp_god.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_tzeentch_warp_god_passive", "abilities/tzeentch_warp_god.lua", LUA_MODIFIER_MOTION_NONE)

if tzeentch_warp_god == nil then tzeentch_warp_god = class({}) end

function tzeentch_warp_god:GetIntrinsicModifierName()
	return "modifier_tzeentch_warp_god"
end

if modifier_tzeentch_warp_god == nil then modifier_tzeentch_warp_god = class({}) end

function modifier_tzeentch_warp_god:IsAura()
	return true
end

function modifier_tzeentch_warp_god:IsHidden()
	return true
end

function modifier_tzeentch_warp_god:IsPurgable()
	return false
end

function modifier_tzeentch_warp_god:GetAuraRadius()
	return 99999
end

function modifier_tzeentch_warp_god:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_tzeentch_warp_god:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_tzeentch_warp_god:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_tzeentch_warp_god:GetModifierAura()
	return "modifier_tzeentch_warp_god_passive"
end

if modifier_tzeentch_warp_god_passive == nil then modifier_tzeentch_warp_god_passive = class({}) end

function modifier_tzeentch_warp_god_passive:IsPurgable(  )
    return false
end

function modifier_tzeentch_warp_god_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

function modifier_tzeentch_warp_god_passive:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_tzeentch_warp_god_passive:GetModifierTotalPercentageManaRegen( params )
    return self:GetAbility():GetSpecialValueFor("mana_regen_prc")
end

function tzeentch_warp_god:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

