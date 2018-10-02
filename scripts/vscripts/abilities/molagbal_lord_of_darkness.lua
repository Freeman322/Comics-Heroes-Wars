molagbal_lord_of_darkness = class({})
LinkLuaModifier( "modifier_molagbal_lord_of_darkness", "abilities/molagbal_lord_of_darkness.lua",LUA_MODIFIER_MOTION_NONE )

function molagbal_lord_of_darkness:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function molagbal_lord_of_darkness:GetIntrinsicModifierName()
    return "modifier_molagbal_lord_of_darkness"
end

--------------------------------------------------------------------------------
-------------------------------------------------------------------------------

modifier_molagbal_lord_of_darkness = class({})

function modifier_molagbal_lord_of_darkness:IsHidden()
    return true
end

function modifier_molagbal_lord_of_darkness:IsPurgable()
    return false
end

function modifier_molagbal_lord_of_darkness:DeclareFunctions() 
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
         MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
    return funcs
end

function modifier_molagbal_lord_of_darkness:GetModifierIncomingDamage_Percentage( params ) return self:GetAbility():GetSpecialValueFor( "damage_reduce" ) * (-1) end
function modifier_molagbal_lord_of_darkness:GetModifierBonusStats_Strength (params) return self:GetAbility():GetSpecialValueFor ("str_bonus") end