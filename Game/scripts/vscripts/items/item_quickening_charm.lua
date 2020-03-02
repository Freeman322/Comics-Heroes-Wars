LinkLuaModifier ("modifier_item_quickening_charm", "items/item_quickening_charm.lua", LUA_MODIFIER_MOTION_NONE)

if item_quickening_charm == nil then item_quickening_charm = class({}) end
function item_quickening_charm:GetIntrinsicModifierName()  return "modifier_item_quickening_charm" end

--------------------------------------------------------------------------------

if modifier_item_quickening_charm == nil then modifier_item_quickening_charm = class({}) end

function modifier_item_quickening_charm:IsPurgable() return false end
function modifier_item_quickening_charm:IsHidden() return true end
function modifier_item_quickening_charm:GetAttributes () return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end
function modifier_item_quickening_charm:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
    }

    return funcs
end

function modifier_item_quickening_charm:GetModifierConstantHealthRegen( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_item_quickening_charm:GetModifierPercentageCooldown( params )
    return self:GetAbility():GetSpecialValueFor( "bonus_cooldown" )
end