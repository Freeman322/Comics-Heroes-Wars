if neutral_magical_immunity == nil then neutral_magical_immunity = class({}) end

LinkLuaModifier ("modifier_neutral_magical_immunity", "abilities/neutral_magical_immunity.lua", LUA_MODIFIER_MOTION_NONE )

function neutral_magical_immunity:GetIntrinsicModifierName ()
    return "modifier_neutral_magical_immunity"
end

if modifier_neutral_magical_immunity == nil then
    modifier_neutral_magical_immunity = class ( {})
end

function modifier_neutral_magical_immunity:IsHidden ()
    return true
end

function modifier_neutral_magical_immunity:IsPurgable()
    return false
end

function modifier_neutral_magical_immunity:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
    }

    return funcs
end

function modifier_neutral_magical_immunity:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_neutral_magical_immunity:GetAbsoluteNoDamagePure(params)
    return 1
end

function modifier_neutral_magical_immunity:GetAbsoluteNoDamageMagical(params)
    return 1
end
