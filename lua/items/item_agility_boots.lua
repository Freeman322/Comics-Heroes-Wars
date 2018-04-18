if item_agility_boots == nil then item_agility_boots = class({}) end
LinkLuaModifier("modifier_item_agility_boots", "items/item_agility_boots.lua", LUA_MODIFIER_MOTION_NONE)
  
function item_agility_boots:GetIntrinsicModifierName()
    return "modifier_item_agility_boots"
end

if modifier_item_agility_boots == nil then
    modifier_item_agility_boots = class ( {})
end

function modifier_item_agility_boots:IsHidden ()
    return true
end

function modifier_item_agility_boots:IsPurgable()
    return false
end

function modifier_item_agility_boots:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_agility_boots:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_agility_boots:GetModifierMoveSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_movement_speed")
end
function modifier_item_agility_boots:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_agility")
end

function modifier_item_agility_boots:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end



function item_agility_boots:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

