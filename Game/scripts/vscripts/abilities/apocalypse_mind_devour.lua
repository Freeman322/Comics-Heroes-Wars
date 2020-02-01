apocalypse_mind_devour = class({})
LinkLuaModifier ("modifier_apocalypse_mind_devour", "abilities/apocalypse_mind_devour.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function apocalypse_mind_devour:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
function apocalypse_mind_devour:OnSpellStart()
	
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "radius" )

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	
		point,	
		nil,	
		radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		0,	
		0,	
		false	
	)

	for _,enemy in pairs(enemies) do
		-- add debuff
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_apocalypse_mind_devour", -- modifier name
			{ duration = duration } -- kv
		)
	end

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2( point, radius )
end

--------------------------------------------------------------------------------
function apocalypse_mind_devour:PlayEffects1()

	local particle_cast = "particles/units/heroes/hero_silencer/silencer_curse_cast.vpcf"
	local sound_cast = "Hero_Silencer.Curse.Cast"

	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetCaster() )
end

function apocalypse_mind_devour:PlayEffects2( point, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_silencer/silencer_curse_aoe.vpcf"
	local sound_cast = "Hero_Silencer.Curse"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

modifier_apocalypse_mind_devour = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_apocalypse_mind_devour:IsHidden()
	return false
end

function modifier_apocalypse_mind_devour:IsDebuff()
	return true
end

function modifier_apocalypse_mind_devour:IsStunDebuff()
	return false
end

function modifier_apocalypse_mind_devour:IsPurgable()
	return true
end

function modifier_apocalypse_mind_devour:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_apocalypse_mind_devour:OnCreated( kv )
	-- references
	self.penalty = self:GetAbility():GetSpecialValueFor( "penalty_duration" )
	self.slow = self:GetAbility():GetSpecialValueFor( "movespeed" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end
	self.interval = 1

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( self.interval )

	-- play effects
	local sound_cast = "Hero_Silencer.Curse.Impact"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_apocalypse_mind_devour:OnRefresh( kv )
	
end

function modifier_apocalypse_mind_devour:OnRemoved()
end

function modifier_apocalypse_mind_devour:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_apocalypse_mind_devour:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_apocalypse_mind_devour:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_apocalypse_mind_devour:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	-- extend duration
	self:SetDuration( self:GetRemainingTime() + self.penalty, true )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_apocalypse_mind_devour:OnIntervalThink()
	-- pause if silenced
	if self:GetParent():IsSilenced() then
		-- extend duration by interval
		self:SetDuration( self:GetRemainingTime() + self.interval, true )
		return
	end

	-- damage
	ApplyDamage( self.damageTable )

	-- play effect
	local sound_cast = "Hero_Silencer.Curse_Tick"
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_apocalypse_mind_devour:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_curse.vpcf"
end

function modifier_apocalypse_mind_devour:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end