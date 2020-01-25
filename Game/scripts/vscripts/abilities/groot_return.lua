groot_return = class({})
LinkLuaModifier( "modifier_groot_return", "abilities/groot_return.lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function groot_return:OnSpellStart()
	local duration = self:GetSpecialValueFor( "delay" )

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_groot_return", { duration = duration }  )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 0,  self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( nFXIndex, 1,  Vector(500, 500, 0))
	ParticleManager:SetParticleControl( nFXIndex, 2,  self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( nFXIndex, 3,  self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( nFXIndex, 5,  self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( nFXIndex, 6,  self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Centaur.HoofStomp", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
end

if modifier_groot_return == nil then modifier_groot_return = class({}) end

function modifier_groot_return:IsHidden()
	return true
end

function modifier_groot_return:IsPurgable()
	return false
end

function modifier_groot_return:OnCreated( kv )
	if IsServer() then
		self.vPoint = self:GetCaster():GetCursorPosition()
	end
end

function modifier_groot_return:OnDestroy()
	if self.vPoint then
		self:GetParent():SetAbsOrigin(self.vPoint)
		FindClearSpaceForUnit(self:GetParent(), self.vPoint, true)
	end
end

function modifier_groot_return:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = false,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function modifier_groot_return:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_timewalk.vpcf"
end

function modifier_groot_return:StatusEffectPriority()
	return 1000
end

function groot_return:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

