khan_windrun = class({})
LinkLuaModifier( "modifier_khan_windrun", "abilities/khan_windrun.lua", LUA_MODIFIER_MOTION_NONE )

function khan_windrun:OnSpellStart()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_khan_windrun", { duration = self:GetSpecialValueFor("duration") } )
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Sven.WarCry", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end

modifier_khan_windrun = class({})

function modifier_khan_windrun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}

	return funcs
end

function modifier_khan_windrun:GetEffectName()
	return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end

function modifier_khan_windrun:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_khan_windrun:GetModifierMoveSpeed_Max( params )
	return self:GetAbility():GetSpecialValueFor("movespeed_absolute")
end

function modifier_khan_windrun:GetModifierMoveSpeed_Limit( params )
	return self:GetAbility():GetSpecialValueFor("movespeed_absolute")
end

function modifier_khan_windrun:GetModifierMoveSpeed_Absolute( params )
	return self:GetAbility():GetSpecialValueFor("movespeed_absolute")
end

function modifier_khan_windrun:GetModifierEvasion_Constant( params )
	return self:GetAbility():GetSpecialValueFor("evasion_pct_tooltip")
end

function khan_windrun:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

