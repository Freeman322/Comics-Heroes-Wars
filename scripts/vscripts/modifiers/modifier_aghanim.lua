if modifier_aghanim == nil then modifier_aghanim = class({}) end 

function modifier_aghanim:IsHidden()
    return true;
end

function modifier_aghanim:IsPurgable()
    return false;
end

function modifier_aghanim:RemoveOnDeath()
    return false;
end

function modifier_aghanim:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_IS_SCEPTER,
    }

    return funcs
end

function modifier_aghanim:GetModifierScepter( params )
    return 1
end
function modifier_aghanim:GetModifierBonusStats_Strength( params )
    return 25
end
function modifier_aghanim:GetModifierBonusStats_Intellect( params )
    return 25
end
function modifier_aghanim:GetModifierBonusStats_Agility( params )
    return 25
end