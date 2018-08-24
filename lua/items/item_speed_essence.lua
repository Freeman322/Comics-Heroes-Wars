if item_speed_essence == nil then item_speed_essence = class({}) end 

LinkLuaModifier ("modifier_item_speed_essence", "items/item_speed_essence.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_speed_essence_activated", "items/item_speed_essence.lua", LUA_MODIFIER_MOTION_NONE)

function item_speed_essence:GetIntrinsicModifierName()
	return "modifier_item_speed_essence"
end

function item_speed_essence:OnSpellStart()
    if IsServer() then 
        if not self:GetCaster():HasModifier("modifier_item_speed_essence_activated") then 
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_speed_essence_activated", nil)
            local mod = self:GetCaster():FindModifierByName("modifier_item_speed_essence_activated")
            mod:SetStackCount(1)
        else
            local mod = self:GetCaster():FindModifierByName("modifier_item_speed_essence_activated")
            mod:SetStackCount(mod:GetStackCount() + 1)
        end
        self:RemoveSelf()
    end
end

if modifier_item_speed_essence == nil then
	modifier_item_speed_essence = class({})
end

function modifier_item_speed_essence:IsHidden()
	return true
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
 	 return 25 * self:GetStackCount()
end

function modifier_item_speed_essence_activated:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_speed_essence:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

