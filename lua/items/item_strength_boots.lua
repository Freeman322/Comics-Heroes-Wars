if item_strength_boots == nil then item_strength_boots = class({}) end
LinkLuaModifier("modifier_item_strength_boots", "items/item_strength_boots.lua", LUA_MODIFIER_MOTION_NONE)
  
function item_strength_boots:GetIntrinsicModifierName()
    return "modifier_item_strength_boots"
end

if modifier_item_strength_boots == nil then
    modifier_item_strength_boots = class ( {})
end

function modifier_item_strength_boots:IsHidden ()
    return true
end

function modifier_item_strength_boots:IsPurgable()
    return false
end

function modifier_item_strength_boots:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_strength_boots:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_strength_boots:GetModifierMoveSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_movement_speed")
end
function modifier_item_strength_boots:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_strength")
end

function modifier_item_strength_boots:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_hp_regen")
end



function item_strength_boots:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

