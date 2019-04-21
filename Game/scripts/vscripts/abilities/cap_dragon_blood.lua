LinkLuaModifier ("modifier_cap_dragon_blood", "abilities/cap_dragon_blood.lua", LUA_MODIFIER_MOTION_NONE)

cap_dragon_blood = class({})

function cap_dragon_blood:GetIntrinsicModifierName()
	return "modifier_cap_dragon_blood"
end

modifier_cap_dragon_blood = class({})

function modifier_cap_dragon_blood:IsHidden()
	return true
end

function modifier_cap_dragon_blood:IsPurgable()
    return false
end

function modifier_cap_dragon_blood:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
    }

    return funcs
end

function modifier_cap_dragon_blood:GetModifierPhysicalArmorBonus( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function modifier_cap_dragon_blood:GetModifierConstantHealthRegen( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end
function modifier_cap_dragon_blood:GetModifierPhysical_ConstantBlock( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_block" )
end
