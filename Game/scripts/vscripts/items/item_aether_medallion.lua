LinkLuaModifier("modifier_item_aether_medallion", "items/item_aether_medallion.lua", 0)
LinkLuaModifier("modifier_item_aether_medallion_currupion", "items/item_aether_medallion.lua", 0)

item_aether_medallion = class({GetIntrinsicModifierName = function() return "modifier_item_aether_medallion" end})

modifier_item_aether_medallion = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_EVENT_ON_ORDER
    } end,

    IsAura = function() return true end,
    GetModifierAura = function() return "modifier_item_aether_medallion_currupion" end
})

function modifier_item_aether_medallion:GetModifierManaBonus() return self:GetAbility():GetSpecialValueFor("bonus_mana") end
function modifier_item_aether_medallion:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end
function modifier_item_aether_medallion:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("bonus_health_regen") end
function modifier_item_aether_medallion:GetModifierSpellAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("bonus_spell_damage") end
function modifier_item_aether_medallion:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_item_aether_medallion:GetModifierCastRangeBonus() return self:GetAbility():GetSpecialValueFor("bonus_cast_range") end
function modifier_item_aether_medallion:GetModifierPercentageManacost() return self:GetAbility():GetSpecialValueFor("bonus_mana_cost") end
function modifier_item_aether_medallion:GetModifierPercentageCasttime() return self:GetAbility():GetSpecialValueFor("bonus_casttime") end
function modifier_item_aether_medallion:GetModifierPercentageCooldown() return self:GetAbility():GetSpecialValueFor("bonus_cooldown") end
function modifier_item_aether_medallion:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_aether_medallion:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_aether_medallion:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function modifier_item_aether_medallion:GetModifierTotalPercentageManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end

function modifier_item_aether_medallion:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function modifier_item_aether_medallion:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function modifier_item_aether_medallion:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function modifier_item_aether_medallion:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end

function modifier_item_aether_medallion:OnOrder( args )
  if args.order_type and args.order_type == DOTA_UNIT_ORDER_CAST_TARGET and args.unit == self:GetParent() then
    if IsServer() then
      if args.target and args.unit:GetTeam() ~= args.target:GetTeam() then
        args.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_aether_medallion_currupion", {duration = self:GetAbility():GetSpecialValueFor("magical_corruption_duration")})
      end
    end
  end
end
modifier_item_aether_medallion_currupion = class({
    IsHidden = function() return false end,
    IsDebuff = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
})

function modifier_item_aether_medallion_currupion:GetModifierMagicalResistanceBonus() return self:GetAbility():GetSpecialValueFor("magical_corruption") end
