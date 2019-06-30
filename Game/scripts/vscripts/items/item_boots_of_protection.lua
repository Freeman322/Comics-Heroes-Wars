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
    return { MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end


function modifier_boots_of_protection:OnTakeDamage (event)
    if event.unit == self:GetParent() then
        self:GetAbility():StartCooldown(2)
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

function modifier_boots_of_protection:GetModifierPhysicalArmorBonus()
    return 10
end

function modifier_boots_of_protection:GetModifierMoveSpeedBonus_Constant()
    return 100
end



function item_boots_of_protection:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

