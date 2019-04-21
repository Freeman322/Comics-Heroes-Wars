if iron_ower == nil then iron_ower = class({}) end

LinkLuaModifier("modifier_iron_ower", "abilities/iron_ower.lua", LUA_MODIFIER_MOTION_NONE) --- PATH WERY IMPORTANT

function iron_ower:GetIntrinsicModifierName()
    return "modifier_iron_ower"
end

if modifier_iron_ower == nil then modifier_iron_ower = class({}) end

function modifier_iron_ower:IsHidden()
	return true
end

function modifier_iron_ower:IsPurgable()
	return false
end

function modifier_iron_ower:RemoveOnDeath()
	return false
end

function modifier_iron_ower:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
	return funcs
end

function modifier_iron_ower:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor( "mana" )
end

function modifier_iron_ower:GetModifierPhysicalArmorBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus" )
end
