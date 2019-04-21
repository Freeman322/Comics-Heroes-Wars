LinkLuaModifier ("modifier_rough_cooldown_aura", 				"abilities/rough_cooldown_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_rough_cooldown_aura_passive", "abilities/rough_cooldown_aura.lua", LUA_MODIFIER_MOTION_NONE)
if rough_cooldown_aura == nil then rough_cooldown_aura = class({}) end

function rough_cooldown_aura:GetIntrinsicModifierName()
	return "modifier_rough_cooldown_aura"
end

if modifier_rough_cooldown_aura == nil then modifier_rough_cooldown_aura = class({}) end

function modifier_rough_cooldown_aura:IsAura()
	return true
end

function modifier_rough_cooldown_aura:IsHidden()
	return true
end

function modifier_rough_cooldown_aura:IsPurgable()
	return false
end

function modifier_rough_cooldown_aura:GetAuraRadius()
	return 99999
end

function modifier_rough_cooldown_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_rough_cooldown_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_rough_cooldown_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_rough_cooldown_aura:GetModifierAura()
	return "modifier_rough_cooldown_aura_passive"
end

if modifier_rough_cooldown_aura_passive == nil then modifier_rough_cooldown_aura_passive = class({}) end

function modifier_rough_cooldown_aura_passive:IsHidden()
	return true
end

function modifier_rough_cooldown_aura_passive:IsPurgable()
	return false
end

function modifier_rough_cooldown_aura_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
    }

    return funcs
end

function modifier_rough_cooldown_aura_passive:GetModifierPercentageCooldownStacking( params )
    return self:GetAbility():GetSpecialValueFor("cooldown")
end

function rough_cooldown_aura:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

