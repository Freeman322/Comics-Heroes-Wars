LinkLuaModifier("modifier_jetsu", "items/item_jetsu.lua", LUA_MODIFIER_MOTION_NONE)

item_jetsu = class ({})

function item_jetsu:GetIntrinsicModifierName()
    return "modifier_jetsu"
end

modifier_jetsu = class ({})

function modifier_jetsu:IsHidden() return true end
function modifier_jetsu:IsPurgable() return false end

function modifier_jetsu:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
    }
end

function modifier_jetsu:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_jetsu:GetModifierPercentageCasttime()
    return self:GetAbility():GetSpecialValueFor("bonus_casttime")
end