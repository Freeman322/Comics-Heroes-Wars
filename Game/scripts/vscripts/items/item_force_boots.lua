LinkLuaModifier("modifier_item_force_boots_passive", "items/item_force_boots.lua", LUA_MODIFIER_MOTION_NONE)

item_force_boots = class({})

function item_force_boots:GetIntrinsicModifierName()
    return "modifier_item_force_boots_passive"
end

function item_force_boots:OnSpellStart ()
    self:GetCaster():AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { duration = 1.5 } )
    EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
end

modifier_item_force_boots_passive = class({})

function modifier_item_force_boots_passive:IsHidden () return true end
function modifier_item_force_boots_passive:DeclareFunctions ()
    return {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_item_force_boots_passive:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor ("bonus_damage")
end
function modifier_item_force_boots_passive:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor ("bonus_movement_speed")
end
function modifier_item_force_boots_passive:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor ("bonus_intellect")
end
function modifier_item_force_boots_passive:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor ("bonus_agility")
end
function modifier_item_force_boots_passive:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor ("bonus_health_regen")
end
