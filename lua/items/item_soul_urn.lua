item_soul_urn = class({})
LinkLuaModifier ("item_soul_urn_modifier", "items/item_soul_urn.lua", LUA_MODIFIER_MOTION_NONE)

function item_soul_urn:GetIntrinsicModifierName()
    return "item_soul_urn_modifier"
end

item_soul_urn_modifier = class({})

function item_soul_urn_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_soul_urn_modifier:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE
    }

    return funcs
end

function item_soul_urn_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_soul_urn_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_soul_urn_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_soul_urn_modifier:GetModifierPhysicalArmorBonus ( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_armor" )
end

function item_soul_urn_modifier:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end
function item_soul_urn_modifier:GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen" )
end

function item_soul_urn:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

