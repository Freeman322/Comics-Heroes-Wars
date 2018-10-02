if item_intelligence_boots == nil then item_intelligence_boots = class({}) end
LinkLuaModifier("modifier_item_intelligence_boots", "items/item_intelligence_boots.lua", LUA_MODIFIER_MOTION_NONE)
  
function item_intelligence_boots:GetIntrinsicModifierName()
    return "modifier_item_intelligence_boots"
end

if modifier_item_intelligence_boots == nil then
    modifier_item_intelligence_boots = class ( {})
end

function modifier_item_intelligence_boots:IsHidden ()
    return true
end

function modifier_item_intelligence_boots:IsPurgable()
    return false
end

function modifier_item_intelligence_boots:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_intelligence_boots:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed")
end
function modifier_item_intelligence_boots:GetModifierMoveSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_movement_speed")
end
function modifier_item_intelligence_boots:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_intellect")
end

function modifier_item_intelligence_boots:GetModifierConstantManaRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen")
end



function item_intelligence_boots:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

