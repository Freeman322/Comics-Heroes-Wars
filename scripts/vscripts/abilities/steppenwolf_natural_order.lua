LinkLuaModifier ("modifier_steppenwolf_natural_order", "abilities/steppenwolf_natural_order.lua", LUA_MODIFIER_MOTION_NONE)
if steppenwolf_natural_order == nil then steppenwolf_natural_order = class({}) end

function steppenwolf_natural_order:GetIntrinsicModifierName()
	return "modifier_steppenwolf_natural_order"
end

if modifier_steppenwolf_natural_order == nil then modifier_steppenwolf_natural_order = class({}) end

function modifier_steppenwolf_natural_order:IsHidden()
	return true
end

function modifier_steppenwolf_natural_order:IsPurgable()
	return true
end

function modifier_steppenwolf_natural_order:OnCreated(htable)
	self.damage = 0
	self.armor = 0
	
    if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_steppenwolf_natural_order:OnIntervalThink()
	if IsServer() then 
		self.damage = 0
		self.armor = 0

		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #units > 0 then
			for _,unit in pairs(units) do
				if unit then 
					self.armor = self.armor + (unit:GetPhysicalArmorBaseValue() * (self:GetAbility():GetSpecialValueFor("armor_stole_pct") / 100))
					self.damage = self.damage + (unit:GetAttackDamage() * (self:GetAbility():GetSpecialValueFor("damage_stole_oct") / 100))
				end
			end
		end
	end
end

function modifier_steppenwolf_natural_order:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE
    }

    return funcs
end

function modifier_steppenwolf_natural_order:GetModifierBaseAttack_BonusDamage( params )
    return self.damage
end

function modifier_steppenwolf_natural_order:GetModifierPhysicalArmorBonusUnique( params )
    return self.armor
end

function modifier_steppenwolf_natural_order:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

