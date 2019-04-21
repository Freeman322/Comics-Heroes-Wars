if item_speed_essence == nil then item_speed_essence = class({}) end 

LinkLuaModifier ("modifier_item_speed_essence", "items/item_speed_essence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_speed_essence_activated", "items/item_speed_essence.lua", LUA_MODIFIER_MOTION_NONE)

function item_speed_essence:GetIntrinsicModifierName()
	return "modifier_item_speed_essence"
end

if modifier_item_speed_essence == nil then
	modifier_item_speed_essence = class({})
end

function modifier_item_speed_essence:IsHidden()
	return true
end

function modifier_item_speed_essence:OnCreated(htable)
    if IsServer() then 
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_speed_essence_activated", nil):IncrementStackCount()

        self:GetParent():RemoveItem(self:GetAbility())
    end
end

function modifier_item_speed_essence:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

if modifier_item_speed_essence_activated == nil then
	modifier_item_speed_essence_activated = class({})
end

function modifier_item_speed_essence_activated:IsHidden()
	return false
end

function modifier_item_speed_essence_activated:GetTexture()
	return "item_speed_essence"
end

function modifier_item_speed_essence_activated:IsPurgable()
	return false
end

function modifier_item_speed_essence_activated:RemoveOnDeath()
	return false
end

function modifier_item_speed_essence_activated:DeclareFunctions() 
local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

	return funcs
end

function modifier_item_speed_essence_activated:GetModifierMoveSpeedBonus_Constant( params )
 	 return 20 * self:GetStackCount()
end

function modifier_item_speed_essence_activated:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function item_speed_essence:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

