LinkLuaModifier ("modifier_item_moon_shard_marvel", "items/item_moon_shard_marvel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_moon_shard_activated_as", "items/item_moon_shard_marvel.lua", LUA_MODIFIER_MOTION_NONE)

if item_moon_shard_marvel == nil then
	item_moon_shard_marvel = class({})
end

function item_moon_shard_marvel:GetIntrinsicModifierName()
	return "modifier_item_moon_shard_marvel"
end

function item_moon_shard_marvel:OnSpellStart()
	if IsServer() then
		EmitSoundOn("Item.MoonShard.Consume", self:GetCaster())
		if not self:GetCaster():HasModifier("modifier_moon_shard_activated_as") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_moon_shard_activated_as", nil)
			local mod = self:GetCaster():FindModifierByName("modifier_moon_shard_activated_as")
			mod:SetStackCount(mod:GetStackCount() + 1)
		else
			local mod = self:GetCaster():FindModifierByName("modifier_moon_shard_activated_as")
			mod:SetStackCount(mod:GetStackCount() + 1)
		end
		self:RemoveSelf()
	end
end

if modifier_item_moon_shard_marvel == nil then
	modifier_item_moon_shard_marvel = class({})
end

function modifier_item_moon_shard_marvel:IsHidden()
	return true
end

function modifier_item_moon_shard_marvel:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_BONUS_NIGHT_VISION
}

	return funcs
end

function modifier_item_moon_shard_marvel:GetBonusNightVision( params )
	 local hAbility = self:GetAbility()
 	 return hAbility:GetSpecialValueFor( "bonus_night_vision" )
end

function modifier_item_moon_shard_marvel:GetModifierAttackSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_attack_speed" )
end

if modifier_moon_shard_activated_as == nil then
	modifier_moon_shard_activated_as = class({})
end

function modifier_moon_shard_activated_as:IsHidden()
	return false
end

function modifier_moon_shard_activated_as:GetTexture()
	return "item_moon_shard"
end

function modifier_moon_shard_activated_as:IsPurgable()
	return false
end

function modifier_moon_shard_activated_as:RemoveOnDeath()
	return false
end

function modifier_moon_shard_activated_as:DeclareFunctions()
local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		---MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
    MODIFIER_PROPERTY_BONUS_NIGHT_VISION
	}

	return funcs
end

function modifier_moon_shard_activated_as:GetBonusNightVision( params )
 	 return 150
end

--[[function modifier_moon_shard_activated_as:GetModifierBaseAttackTimeConstant( params )
	if self:GetStackCount() == 0 then
   	   return 0.03
   	else
   	   return 0.03*self:GetStackCount()
   	end
end]]

function modifier_moon_shard_activated_as:GetModifierAttackSpeedBonus_Constant( params )
	if self:GetStackCount() == 0 then
   	   return 50
   	else
   	   return 50*self:GetStackCount()
   	end
end

function modifier_moon_shard_activated_as:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_moon_shard_marvel:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

