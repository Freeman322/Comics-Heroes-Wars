if item_aether_medallion == nil then item_aether_medallion = class({}) end
LinkLuaModifier("modifier_item_aether_medallion", "items/item_aether_medallion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_aether_medallion_currupion", "items/item_aether_medallion.lua", LUA_MODIFIER_MOTION_NONE)

function item_aether_medallion:GetIntrinsicModifierName()
    return "modifier_item_aether_medallion"
end

if modifier_item_aether_medallion == nil then modifier_item_aether_medallion = class({}) end

function modifier_item_aether_medallion:IsHidden()
    return true
end

function modifier_item_aether_medallion:IsPurgable()
    return false
end

function modifier_item_aether_medallion:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_EVENT_ON_ORDER
    }

    return funcs
end

function modifier_item_aether_medallion:GetModifierManaBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana" )
end
function modifier_item_aether_medallion:GetModifierHealthBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health" )
end
function modifier_item_aether_medallion:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end
function modifier_item_aether_medallion:GetModifierSpellAmplify_Percentage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_spell_damage" )
end
function modifier_item_aether_medallion:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_armor" )
end
function modifier_item_aether_medallion:GetModifierCastRangeBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_cast_range" )
end
function modifier_item_aether_medallion:GetModifierPercentageManacost( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_cost" )
end
function modifier_item_aether_medallion:GetModifierPercentageCasttime( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_casttime" )
end
function modifier_item_aether_medallion:GetModifierPercentageCooldown( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_cooldown" )
end
function modifier_item_aether_medallion:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_aether_medallion:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_aether_medallion:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_aether_medallion:GetModifierConstantManaRegen( params )
    local mana = self:GetParent():GetMaxMana() * (self:GetAbility():GetSpecialValueFor ("bonus_mana_regen") / 100)
    return mana
end
function modifier_item_aether_medallion:OnOrder( args )
  if args.order_type and args.order_type == DOTA_UNIT_ORDER_CAST_TARGET then
    if IsServer() then
      if args.target then
        args.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_aether_medallion_currupion", {duration = 7})
      end
    end
  end
end
if modifier_item_aether_medallion_currupion == nil then modifier_item_aether_medallion_currupion = class({}) end

function modifier_item_aether_medallion_currupion:IsHidden()
    return false
end

function modifier_item_aether_medallion_currupion:IsPurgable()
    return false
end

function modifier_item_aether_medallion_currupion:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_item_aether_medallion_currupion:GetModifierMagicalResistanceBonus( params )
    return self:GetAbility():GetSpecialValueFor( "magical_corruption" )
end

function item_aether_medallion:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

