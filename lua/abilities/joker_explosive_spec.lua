joker_explosive_spec = class({})
LinkLuaModifier( "modifier_joker_explosive_spec", "abilities/joker_explosive_spec.lua", LUA_MODIFIER_MOTION_NONE )

function joker_explosive_spec:GetIntrinsicModifierName()
	return "modifier_joker_explosive_spec"
end

if modifier_joker_explosive_spec == nil then
    modifier_joker_explosive_spec = class ( {})
end

function modifier_joker_explosive_spec:IsHidden()
    return true
end

function modifier_joker_explosive_spec:IsPurgable()
    return false
end

function modifier_joker_explosive_spec:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }

    return funcs
end

function modifier_joker_explosive_spec:GetModifierManaBonus (params)
    return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_joker_explosive_spec:GetModifierConstantHealthRegen (params)
    return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_joker_explosive_spec:GetModifierCastRangeBonus (params)
    return self:GetAbility():GetSpecialValueFor("cast_range_bonus")
end

function modifier_joker_explosive_spec:GetModifierSpellAmplify_Percentage (params)
    return self:GetAbility():GetSpecialValueFor("spell_amp")
end
