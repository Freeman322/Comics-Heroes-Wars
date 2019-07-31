LinkLuaModifier ("modifier_item_desolator_3", "items/item_desolator_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_desolator_3_corruption", "items/item_desolator_3.lua", LUA_MODIFIER_MOTION_NONE)

if item_desolator_3 == nil then
    item_desolator_3 = class ( {})
end

function item_desolator_3:GetBehavior()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function item_desolator_3:GetIntrinsicModifierName ()
    return "modifier_item_desolator_3"
end

if modifier_item_desolator_3 == nil then
    modifier_item_desolator_3 = class ( {})
end

function modifier_item_desolator_3:IsHidden()
    return true
end

function modifier_item_desolator_3:IsPurgable()
    return false
end

function modifier_item_desolator_3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end





function modifier_item_desolator_3:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_desolator_3:OnAttackLanded(params)
    if params.attacker == self:GetParent() then
  		local hTarget = params.target
  		hTarget:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_item_desolator_3_corruption", {duration = 7})
  		EmitSoundOn("Item_Desolator.Target", hTarget)
    end
end

if modifier_item_desolator_3_corruption == nil then modifier_item_desolator_3_corruption = class({}) end

function modifier_item_desolator_3_corruption:IsHidden()
    return false
end

function modifier_item_desolator_3_corruption:IsPurgable()
    return false
end

function modifier_item_desolator_3_corruption:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_item_desolator_3_corruption:GetModifierPhysicalArmorBonus( params )
    if self:GetParent():IsBuilding() then 
        return self:GetAbility():GetSpecialValueFor("corruption_armor")
    end
    return self:GetAbility():GetSpecialValueFor("corruption_armor") + (-1 * (math.floor( GameRules:GetGameTime() / 60 ) / 2))
end

function item_desolator_3:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

