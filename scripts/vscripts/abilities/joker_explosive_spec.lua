LinkLuaModifier( "modifier_joker_explosive_spec", "abilities/joker_explosive_spec.lua", LUA_MODIFIER_MOTION_NONE )

joker_explosive_spec = class({})

function joker_explosive_spec:GetIntrinsicModifierName() return "modifier_joker_explosive_spec" end

modifier_joker_explosive_spec = class ( {})


function modifier_joker_explosive_spec:IsHidden() return true end
function modifier_joker_explosive_spec:IsPurgable() return false end

function modifier_joker_explosive_spec:DeclareFunctions()
    return { MODIFIER_PROPERTY_MANA_BONUS,
						 MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
						 MODIFIER_PROPERTY_CAST_RANGE_BONUS,
						 MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE }
end

function modifier_joker_explosive_spec:GetModifierManaBonus() return self:GetAbility():GetSpecialValueFor("bonus_mana") end
function modifier_joker_explosive_spec:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_joker_explosive_spec:GetModifierCastRangeBonus() return self:GetAbility():GetSpecialValueFor("cast_range_bonus") end
function modifier_joker_explosive_spec:GetModifierSpellAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("spell_amp") end
