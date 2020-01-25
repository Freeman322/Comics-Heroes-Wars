LinkLuaModifier("modifier_item_elemental_treads_stats", "items/item_elemental_treads.lua", LUA_MODIFIER_MOTION_NONE)

item_elemental_treads = class({})

function item_elemental_treads:GetIntrinsicModifierName()
	return "modifier_item_elemental_treads_stats"
end

modifier_item_elemental_treads_stats = class ({})

function modifier_item_elemental_treads_stats:IsPurgable()
    return false
end

function modifier_item_elemental_treads_stats:IsHidden()
    return true
end

function modifier_item_elemental_treads_stats:RemoveOnDeath()
    return false
end

function modifier_item_elemental_treads_stats:DeclareFunctions()
    local funcs = { 
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS_PERCENTAGE
    }   
    return funcs
end

function modifier_item_elemental_treads_stats:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_elemental_treads_stats:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_elemental_treads_stats:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_elemental_treads_stats:GetModifierBonusStats_Strength_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_stats_all_pct") end
function modifier_item_elemental_treads_stats:GetModifierBonusStats_Intellect_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_stats_all_pct")  end
function modifier_item_elemental_treads_stats:GetModifierBonusStats_Agility_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_stats_all_pct") end
function modifier_item_elemental_treads_stats:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
function modifier_item_elemental_treads_stats:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_movespeed_pct") end
