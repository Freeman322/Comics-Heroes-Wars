modifier_speed_stole = class({})

function modifier_speed_stole:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }

    return funcs
end

function modifier_speed_stole:GetModifierMoveSpeed_Max( params )
    return 999999
end

function modifier_speed_stole:GetModifierMoveSpeed_Limit( params )
    return 999999
end

function modifier_speed_stole:GetModifierMoveSpeed_Absolute( params )
    return 999999
end

function modifier_speed_stole:IsHidden()
    return false
end