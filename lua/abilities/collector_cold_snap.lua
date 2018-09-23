collector_cold_snap = class({})
LinkLuaModifier( "modifier_collector_cold_snap", "abilities/collector_cold_snap.lua", LUA_MODIFIER_MOTION_NONE )

function collector_cold_snap:IsStealable()
	return false
end

function collector_cold_snap:GetAOERadius()
    return IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_collector_3") or 0
end

function collector_cold_snap:GetBehavior()
    if IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_collector_3") then 
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
    end
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end
 
function collector_cold_snap:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetOrbSpecialValueFor("duration", "q")

	-- logic
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_collector_cold_snap", -- modifier name
		{ duration = duration } -- kv
	)

	self:PlayEffects( target )

	if self:GetCaster():HasTalent("special_bonus_unique_collector_3") then 
         local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	
			target:GetOrigin(),	
			nil,	
			350,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
			DOTA_UNIT_TARGET_FLAG_NONE,
			0,
			false	
        )
		for _, enemy in pairs(enemies) do
            enemy:AddNewModifier(self:GetCaster(), self, "modifier_collector_cold_snap", {duration = duration})         
        end
    end 
end

--------------------------------------------------------------------------------
function collector_cold_snap:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf"
	local sound_cast = "Hero_Invoker.ColdSnap.Cast"
	local sound_target = "Hero_Invoker.ColdSnap"

	-- Get Data
	local direction = target:GetOrigin()-self:GetCaster():GetOrigin()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin() + direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end

modifier_collector_cold_snap = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_collector_cold_snap:IsHidden()
	return false
end

function modifier_collector_cold_snap:IsDebuff()
	return true
end

function modifier_collector_cold_snap:IsStunDebuff()
	return false
end

function modifier_collector_cold_snap:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_collector_cold_snap:OnCreated( kv )
	if IsServer() then
		-- references
		self.damage = self:GetAbility():GetOrbSpecialValueFor( "freeze_damage", "q" )
		self.duration = self:GetAbility():GetOrbSpecialValueFor( "freeze_duration", "q" )
		self.cooldown = self:GetAbility():GetOrbSpecialValueFor( "freeze_cooldown", "q" )
		self.threshold = self:GetAbility():GetOrbSpecialValueFor( "damage_trigger", "q" )

		self.onCooldown = false

		-- Start interval
		self:Freeze()
	end
end

function modifier_collector_cold_snap:OnRefresh( kv )
	if IsServer() then
		-- references
		self.damage = self:GetAbility():GetOrbSpecialValueFor( "freeze_damage", "q" )
		self.duration = self:GetAbility():GetOrbSpecialValueFor( "freeze_duration", "q" )
		self.cooldown = self:GetAbility():GetOrbSpecialValueFor( "freeze_cooldown", "q" )
		self.threshold = self:GetAbility():GetOrbSpecialValueFor( "damage_trigger", "q" )
	end
end

function modifier_collector_cold_snap:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_collector_cold_snap:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_collector_cold_snap:OnTakeDamage( params )
	if IsServer() then
		if params.unit~=self:GetParent() then return end
		if params.damage<self.threshold then return end
		if self.onCooldown then return end
		self:Freeze()

		self:PlayEffects( params.attacker )
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_collector_cold_snap:OnIntervalThink()
	self.onCooldown = false
	self:StartIntervalThink(-1)
end

--------------------------------------------------------------------------------
-- Helper functions
function modifier_collector_cold_snap:Freeze()
	self.onCooldown = true
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_stunned", -- modifier name
		{ duration = self.duration } -- kv
	)
	self:StartIntervalThink( self.cooldown )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_collector_cold_snap:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf"
end

function modifier_collector_cold_snap:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_collector_cold_snap:PlayEffects( attacker )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf"
	local sound_cast = "Hero_Invoker.ColdSnap.Freeze"

	-- Get Data
	local direction = self:GetParent():GetOrigin()-attacker:GetOrigin()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1,  self:GetParent():GetOrigin()+direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end