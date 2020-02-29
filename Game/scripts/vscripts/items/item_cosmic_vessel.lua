LinkLuaModifier ("modifier_item_cosmic_vessel", "items/item_cosmic_vessel.lua", LUA_MODIFIER_MOTION_NONE)

if item_cosmic_vessel == nil then item_cosmic_vessel = class({}) end
function item_cosmic_vessel:GetIntrinsicModifierName()  return "modifier_item_cosmic_vessel" end

--------------------------------------------------------------------------------

if modifier_item_cosmic_vessel == nil then
    modifier_item_cosmic_vessel = class({})
end

function modifier_item_cosmic_vessel:IsPurgable() return false end
function modifier_item_cosmic_vessel:IsHidden() return true end
function modifier_item_cosmic_vessel:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end
function modifier_item_cosmic_vessel:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }

    return funcs
end

function modifier_item_cosmic_vessel:GetModifierBonusStats_Strength (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_agility_and_str")
end

function modifier_item_cosmic_vessel:GetModifierBonusStats_Agility (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_agility_and_str")
end

function modifier_item_cosmic_vessel:GetModifierBonusStats_Intellect( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_intelligence" )
end

function modifier_item_cosmic_vessel:GetModifierSpellAmplify_Percentage( params )
    return self:GetAbility():GetSpecialValueFor( "spell_amp" )
end

function modifier_item_cosmic_vessel:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor( "mp_regen" )
end

function modifier_item_cosmic_vessel:GetModifierConstantHealthRegen( params )
    return self:GetAbility():GetSpecialValueFor( "hp_regen" )
end

function modifier_item_cosmic_vessel:GetModifierPercentageCooldown( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_cooldown" )
end