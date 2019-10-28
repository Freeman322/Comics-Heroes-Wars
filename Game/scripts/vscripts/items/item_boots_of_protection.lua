if item_boots_of_protection == nil then
    item_boots_of_protection = class({})
end

LinkLuaModifier ("modifier_boots_of_protection", "items/item_boots_of_protection.lua", LUA_MODIFIER_MOTION_NONE)

function item_boots_of_protection:GetIntrinsicModifierName ()
    return "modifier_boots_of_protection"
end

function item_boots_of_protection:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function item_boots_of_protection:GetCooldown(nLevel)
    return self.BaseClass.GetCooldown (self, nLevel)
end


if modifier_boots_of_protection == nil then
    modifier_boots_of_protection = class({})
end

function modifier_boots_of_protection:DeclareFunctions ()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE, 
             MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
             MODIFIER_PROPERTY_HEALTH_BONUS,
             MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
             MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
             MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
             MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
             MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 
             MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_boots_of_protection:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_boots_of_protection:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_boots_of_protection:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_boots_of_protection:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_boots_of_protection:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_magical_armor")
end

function modifier_boots_of_protection:GetModifierHealthBonus() 
    return self:GetAbility():GetSpecialValueFor("bonus_health") 
end

function modifier_boots_of_protection:GetModifierMoveSpeedBonus_Percentage() 
    return self:GetAbility():GetSpecialValueFor ("bonus_movement_speed") 
end
    

function modifier_boots_of_protection:OnTakeDamage (event)
    if event.unit == self:GetParent() then
        self:GetAbility():StartCooldown(7)
    end
end

function modifier_boots_of_protection:IsHidden ()
    return true
end

function modifier_boots_of_protection:GetModifierConstantHealthRegen ()
    local regen = self:GetParent():GetMaxHealth () * 0.03
    if self:GetAbility():IsCooldownReady() then
        return regen
    else
        return 0
    end
end

function modifier_boots_of_protection:GetModifierMoveSpeedBonus_Constant()
    return 100
end

function item_boots_of_protection:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

