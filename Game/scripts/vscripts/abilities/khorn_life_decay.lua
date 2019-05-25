LinkLuaModifier( "khorn_life_decay_aura", "abilities/khorn_life_decay.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_khorn_life_decay", "abilities/khorn_life_decay.lua", LUA_MODIFIER_MOTION_NONE )

khorn_life_decay = class({})

function khorn_life_decay:GetIntrinsicModifierName()
	return "khorn_life_decay_aura"
end

khorn_life_decay_aura = class({})

function khorn_life_decay_aura:IsAura()
	return true
end

function khorn_life_decay_aura:IsHidden()
	return true
end

function khorn_life_decay_aura:IsPurgable()
	return false
end

function khorn_life_decay_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function khorn_life_decay_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function khorn_life_decay_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function khorn_life_decay_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function khorn_life_decay_aura:GetModifierAura()
	return "modifier_khorn_life_decay"
end

modifier_khorn_life_decay = class({})

function modifier_khorn_life_decay:IsBuff()
	return false
end

function modifier_khorn_life_decay:IsPurgable()
	return false
end

function modifier_khorn_life_decay:OnCreated(htable)
    if IsServer() then
		local armor = self:GetParent():GetPhysicalArmorValue( false )
		self.armor = math.floor( (GameRules:GetGameTime()/60) ) * (-1)
		if self:GetParent():IsBuilding() then
			self.armor = self.armor / 4
		end
	end
end

function modifier_khorn_life_decay:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }

    return funcs
end


function modifier_khorn_life_decay:GetModifierPhysicalArmorBonus( params )
    return self.armor
end

function modifier_khorn_life_decay:GetModifierMagicalResistanceBonus( params )
    return self:GetAbility():GetSpecialValueFor("magical_armor_reduction")
end

function khorn_life_decay:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

