if sauron_decay_aura == nil then sauron_decay_aura = class({}) end
LinkLuaModifier( "modifier_sauron_decay", 		 "abilities/sauron_decay_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sauron_decay_aura", "abilities/sauron_decay_aura.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sauron_decay_aura:GetIntrinsicModifierName()
	return "modifier_sauron_decay_aura"
end

modifier_sauron_decay_aura = class({})

function modifier_sauron_decay_aura:IsAura()
	return true
end

function modifier_sauron_decay_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_sauron_decay_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_sauron_decay_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_sauron_decay_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_sauron_decay_aura:GetModifierAura()
	return "modifier_sauron_decay"
end

modifier_sauron_decay = class({})

function modifier_sauron_decay:IsBuff()
	return false
end

function modifier_sauron_decay:DeclareFunctions()
	return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_sauron_decay:GetModifierDamageOutgoing_Percentage()
	local ability = self:GetAbility()
	if ability then
		if IsServer() then
			if self:GetParent():HasTalent("special_bonus_unique_sauron") then
				return self:GetParent():FindTalentValue("special_bonus_unique_sauron") + self:GetAbility():GetSpecialValueFor("damage_reduction_pct")
			end
		end
		
		return self:GetAbility():GetSpecialValueFor("damage_reduction_pct")
	end
	return 
end

function sauron_decay_aura:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

