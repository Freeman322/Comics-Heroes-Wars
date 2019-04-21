ursa_warrior_will = class({})
LinkLuaModifier( "modifier_ursa_warrior_will", "abilities/ursa_warrior_will.lua",LUA_MODIFIER_MOTION_NONE )

function ursa_warrior_will:GetIntrinsicModifierName()
    return "modifier_ursa_warrior_will"
end

modifier_ursa_warrior_will = class({})

function modifier_ursa_warrior_will:IsHidden()
    return true
end

function modifier_ursa_warrior_will:IsPurgable()
    return false
end

function modifier_ursa_warrior_will:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_ursa_warrior_will:GetModifierIncomingDamage_Percentage( params )
    return self:GetAbility():GetSpecialValueFor( "damage_reduction" ) * (-1)
end