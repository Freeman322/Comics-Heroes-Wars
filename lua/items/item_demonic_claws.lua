LinkLuaModifier("modifier_item_demonic_claws", "items/item_demonic_claws.lua", LUA_MODIFIER_MOTION_NONE)

if item_demonic_claws == nil then
	item_demonic_claws = class({})
end

function item_demonic_claws:GetIntrinsicModifierName()
	return "modifier_item_demonic_claws"
end

if modifier_item_demonic_claws == nil then
	modifier_item_demonic_claws = class({})
end

function modifier_item_demonic_claws:IsHidden()
	return true
end

function modifier_item_demonic_claws:DeclareFunctions () 
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS
    }

    return funcs
end

function modifier_item_demonic_claws:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_intellect")
end

function modifier_item_demonic_claws:GetModifierCastRangeBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("cast_range_bonus")
end

function modifier_item_demonic_claws:GetModifierConstantManaRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end

function modifier_item_demonic_claws:GetModifierManaBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana")
end

function modifier_item_demonic_claws:GetModifierSpellAmplify_Percentage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("spell_amp")
end
