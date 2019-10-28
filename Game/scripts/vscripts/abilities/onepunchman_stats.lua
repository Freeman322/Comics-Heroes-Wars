if onepunchman_stats == nil then onepunchman_stats = class({}) end 
LinkLuaModifier ("modifier_onepunchman_stats", "abilities/onepunchman_stats.lua" , LUA_MODIFIER_MOTION_NONE)

function onepunchman_stats:GetIntrinsicModifierName ()
    return "modifier_onepunchman_stats"
end

if modifier_onepunchman_stats == nil then
    modifier_onepunchman_stats = class ( {})
end

function modifier_onepunchman_stats:IsHidden ()
    return false
end

function modifier_onepunchman_stats:IsPurgable()
    return false
end

function modifier_onepunchman_stats:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_onepunchman_stats:GetModifierEvasion_Constant(params)
    return self:GetAbility():GetSpecialValueFor( "bonus_evasion" ) + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_saitama_3") or 0)
end


function modifier_onepunchman_stats:GetModifierMoveSpeedBonus_Percentage(params)
    return self:GetAbility():GetSpecialValueFor( "bonus_move_speed_percent" )
end

function modifier_onepunchman_stats:GetModifierBonusStats_Agility(params)
    return self:GetAbility():GetSpecialValueFor( "bonus_agility" ) + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_saitama_3") or 0)
end
