LinkLuaModifier ("modifier_modifier_brilliance_aura_self", "abilities/strange_brilliance_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_modifier_brilliance_aura_effect_radius", "abilities/strange_brilliance_aura.lua", LUA_MODIFIER_MOTION_NONE)

if strange_brilliance_aura == nil then strange_brilliance_aura = class({}) end

function strange_brilliance_aura:GetIntrinsicModifierName()
	return "modifier_modifier_brilliance_aura_self"
end

if modifier_modifier_brilliance_aura_self == nil then modifier_modifier_brilliance_aura_self = class({}) end

function modifier_modifier_brilliance_aura_self:IsAura()
	return true
end

function modifier_modifier_brilliance_aura_self:IsHidden()
	return true
end

function modifier_modifier_brilliance_aura_self:IsPurgable()
	return false
end

function modifier_modifier_brilliance_aura_self:GetAuraRadius()
	return 99999
end

function modifier_modifier_brilliance_aura_self:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_modifier_brilliance_aura_self:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_modifier_brilliance_aura_self:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_modifier_brilliance_aura_self:GetModifierAura()
	return "modifier_modifier_brilliance_aura_effect_radius"
end

if modifier_modifier_brilliance_aura_effect_radius == nil then modifier_modifier_brilliance_aura_effect_radius = class({}) end

function modifier_modifier_brilliance_aura_effect_radius:IsPurgable(  )
    return false
end

function modifier_modifier_brilliance_aura_effect_radius:OnCreated(table)
end

function modifier_modifier_brilliance_aura_effect_radius:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

function modifier_modifier_brilliance_aura_effect_radius:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_modifier_brilliance_aura_effect_radius:GetModifierConstantHealthRegen( params )
    if self:GetCaster():HasScepter() then
        return self:GetAbility():GetSpecialValueFor("health_regen") + GameRules:GetGameTime()/30
    end
    return self:GetAbility():GetSpecialValueFor("health_regen")
end

function strange_brilliance_aura:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

