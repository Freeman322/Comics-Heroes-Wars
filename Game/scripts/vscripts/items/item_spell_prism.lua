LinkLuaModifier ("modifier_item_spell_prism", "items/item_spell_prism.lua", LUA_MODIFIER_MOTION_NONE)

if item_spell_prism == nil then item_spell_prism = class({}) end
function item_spell_prism:GetIntrinsicModifierName()  return "modifier_item_spell_prism" end

--------------------------------------------------------------------------------

if modifier_item_spell_prism == nil then modifier_item_spell_prism = class({}) end

function modifier_item_spell_prism:IsPurgable() return false end
function modifier_item_spell_prism:IsHidden() return true end

function modifier_item_spell_prism:DeclareFunctions() --we want to use these functions in this item
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

function modifier_item_spell_prism:GetModifierBonusStats_Strength (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_spell_prism:GetModifierBonusStats_Agility (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_spell_prism:GetModifierBonusStats_Intellect( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_spell_prism:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor( "mana_regen" )
end

function modifier_item_spell_prism:GetModifierPercentageCooldown( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_cooldown" )
end