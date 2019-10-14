death_eater_aura = class({})
LinkLuaModifier("modifier_death_eater", "abilities/death_eater_aura.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function death_eater_aura:GetIntrinsicModifierName()
	return "modifier_death_eater"
end

modifier_death_eater = class({})
--------------------------------------------------------------------------------

function modifier_death_eater:IsDebuff()
	return self:GetParent()~=self:GetAbility():GetCaster()
end

function modifier_death_eater:IsHidden()
	return self:GetParent()==self:GetAbility():GetCaster()
end

function modifier_death_eater:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------

function modifier_death_eater:IsAura()
	if self:GetCaster() == self:GetParent() then
		if not self:GetCaster():PassivesDisabled() then
			return true
		end
	end
	
	return false
end

function modifier_death_eater:GetModifierAura()
	return "modifier_death_eater"
end

function modifier_death_eater:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_death_eater:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_death_eater:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_death_eater:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_death_eater:GetAuraEntityReject( hEntity )
	return not hEntity:CanEntityBeSeenByMyTeam(self:GetCaster())
end
--------------------------------------------------------------------------------

function modifier_death_eater:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" ) * (-1)
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resistance" ) * (-1)
	self.damage = self:GetAbility():GetSpecialValueFor( "plague_damage" )

	if not self:IsAura() and IsServer() then
		self:StartIntervalThink(1)
	end 
end

function modifier_death_eater:OnIntervalThink()
	if IsServer() then
		ApplyDamage ({
			victim = self:GetParent(),
			attacker = self:GetCaster (),
			damage = (self.damage / 100) * self:GetParent():GetMaxHealth(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		})
	end 
end

function modifier_death_eater:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" ) * (-1)
	self.magic_resist = self:GetAbility():GetSpecialValueFor( "magic_resistance" ) * (-1)
	self.damage = self:GetAbility():GetSpecialValueFor( "plague_damage" )
end

--------------------------------------------------------------------------------

function modifier_death_eater:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_death_eater:GetModifierPhysicalArmorBonus( params )
	if self:GetParent() == self:GetCaster() then
		return 0
	end

	return self.armor_reduction
end


function modifier_death_eater:GetModifierMagicalResistanceBonus( params )
	if self:GetParent() == self:GetCaster() then
		return 0
	end

	return self.magic_resist
end
