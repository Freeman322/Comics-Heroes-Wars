LinkLuaModifier("modifier_item_force_boots_passive", "items/item_force_boots.lua", LUA_MODIFIER_MOTION_NONE)

if item_force_boots == nil then
    item_force_boots = class ( {})
end
  
function item_force_boots:GetIntrinsicModifierName()
    return "modifier_item_force_boots_passive"
end


function item_force_boots:OnSpellStart ()
    local hTarget = self:GetCaster()
    hTarget:AddNewModifier (self:GetCaster (), self, "modifier_item_forcestaff_active", { duration = 1.5 } )
    EmitSoundOn ("DOTA_Item.ForceStaff.Activate",self:GetCaster ())
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if modifier_item_force_boots_passive == nil then
    modifier_item_force_boots_passive = class ( {})
end

function modifier_item_force_boots_passive:IsHidden ()
    return true
end

function modifier_item_force_boots_passive:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_force_boots_passive:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_force_boots_passive:GetModifierMoveSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_movement_speed")
end
function modifier_item_force_boots_passive:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_intellect")
end
function modifier_item_force_boots_passive:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_agility")
end
function modifier_item_force_boots_passive:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end



function item_force_boots:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

