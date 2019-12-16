LinkLuaModifier ("modifier_item_octarine_core_lua", "items/item_octarine_core.lua", LUA_MODIFIER_MOTION_NONE)

if item_octarine_core == nil then
    item_octarine_core = class({})
end

function item_octarine_core:GetIntrinsicModifierName ()
    return "modifier_item_octarine_core_lua"
end

--------------------------------------------------------------------------------

if modifier_item_octarine_core_lua == nil then
    modifier_item_octarine_core_lua = class({})
end

function modifier_item_octarine_core_lua:IsPurgable() return false end
function modifier_item_octarine_core_lua:IsHidden() return true end
function modifier_item_octarine_core_lua:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end
function modifier_item_octarine_core_lua:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }

    return funcs
end

function modifier_item_octarine_core_lua:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intelligence" )
end

function modifier_item_octarine_core_lua:GetModifierManaBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana" )
end

function modifier_item_octarine_core_lua:GetModifierHealthBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health" )
end

function modifier_item_octarine_core_lua:GetModifierPercentageCooldown( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_cooldown" )
end

function item_octarine_core:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

