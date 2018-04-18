LinkLuaModifier("modifier_item_ethernal_dagon_scepter", "items/item_ethernal_dagon_scepter.lua", LUA_MODIFIER_MOTION_NONE)
if item_ethernal_dagon_scepter == nil then
	item_ethernal_dagon_scepter = class({})
end

function item_ethernal_dagon_scepter:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function item_ethernal_dagon_scepter:GetIntrinsicModifierName()
	return "modifier_item_ethernal_dagon_scepter"
end

function item_ethernal_dagon_scepter:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			local base_damage = self:GetSpecialValueFor("tooltip_damage")
			local stats = self:GetCaster():GetIntellect() + self:GetCaster():GetStrength() + self:GetCaster():GetAgility()
			local mult = self:GetSpecialValueFor("blast_stats_multiplier")
			local damage = (base_damage + stats + mult)
			local DamageTable = {
			victim = hTarget,
			attacker = self:GetCaster(),
			ability = self,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL 
		}
			ApplyDamage(DamageTable)
			EmitSoundOn( "DOTA_Item.MedallionOfCourage.Activate", self:GetCaster() )
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:SetParticleControl(nFXIndex, 2, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 3, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 4, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( nFXIndex );
	end
end

if modifier_item_ethernal_dagon_scepter == nil then
	modifier_item_ethernal_dagon_scepter = class({})
end

function modifier_item_ethernal_dagon_scepter:IsHidden()
	return true
end

function modifier_item_ethernal_dagon_scepter:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_IS_SCEPTER,
	}

	return funcs
end

function modifier_item_ethernal_dagon_scepter:GetModifierBonusStats_Strength( params )
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_ethernal_dagon_scepter:GetModifierBonusStats_Agility( params )
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_ethernal_dagon_scepter:GetModifierBonusStats_Intellect( params )
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_ethernal_dagon_scepter:GetModifierTotalDamageOutgoing_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("spell_amp_bonus")
end

function modifier_item_ethernal_dagon_scepter:GetModifierPercentageCooldown( params )
	return self:GetAbility():GetSpecialValueFor("cooldown_reduction_bonus")
end

function modifier_item_ethernal_dagon_scepter:GetModifierScepter( params )
	return 1
end

function modifier_item_ethernal_dagon_scepter:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_ethernal_dagon_scepter:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

