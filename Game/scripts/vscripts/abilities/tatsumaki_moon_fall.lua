tatsumaki_moon_fall = class({})

LinkLuaModifier( "modifier_tatsumaki_moon_fall_thinker", "abilities/tatsumaki_moon_fall.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tatsumaki_moon_fall_burn", "abilities/tatsumaki_moon_fall.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function tatsumaki_moon_fall:OnChannelFinish( bInterrupted )
     if IsServer() and not bInterrupted then
          -- unit identifier
          local caster = self:GetCaster()
          local point = self:GetCursorPosition()

          -- create thinker
          CreateModifierThinker(
               caster, -- player source
               self, -- ability source
               "modifier_tatsumaki_moon_fall_thinker", -- modifier name
               {}, -- kv
               point,
               self:GetCaster():GetTeamNumber(),
               false
          )
     end
end


modifier_tatsumaki_moon_fall_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tatsumaki_moon_fall_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tatsumaki_moon_fall_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.delay = self:GetAbility():GetSpecialValueFor( "land_time" )
		self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
		self.distance = self:GetAbility():GetSpecialValueFor( "travel_distance")
		self.speed = self:GetAbility():GetSpecialValueFor( "travel_speed" )
		self.vision = self:GetAbility():GetSpecialValueFor( "vision_distance" )
		self.vision_duration = self:GetAbility():GetSpecialValueFor( "end_vision_duration" )
		self.interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )
		self.duration = self:GetAbility():GetSpecialValueFor( "burn_duration" )
		local damage = self:GetAbility():GetSpecialValueFor( "main_damage" )

		-- variables
		self.fallen = false
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- vision
		self:GetParent():SetDayTimeVisionRange( self.vision )
		self:GetParent():SetNightTimeVisionRange( self.vision )

		-- Start interval
		self:StartIntervalThink( self.delay )

		-- play effects
		self:PlayEffects1()
	end
end

function modifier_tatsumaki_moon_fall_thinker:OnRefresh( kv )
	
end

function modifier_tatsumaki_moon_fall_thinker:OnDestroy( kv )
	if IsServer() then
		-- add vision
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.vision, self.vision_duration, false)

		-- stop effects
		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_tatsumaki_moon_fall_thinker:OnIntervalThink()
	if not self.fallen then
		-- meatball has fallen
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
		
		self:PlayEffects2()
	else
		-- move & damages
		self:Move_Burn()
	end
end

function modifier_tatsumaki_moon_fall_thinker:Burn()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- add modifier
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_tatsumaki_moon_fall_burn", -- modifier name
			{ duration = self.duration } -- kv
		)
	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_tatsumaki_moon_fall_thinker:Move_Burn()
	local parent = self:GetParent()

	-- set position
	local target = self.direction*self.speed*self.interval
	parent:SetOrigin( parent:GetOrigin() + target )

	-- Burn
	self:Burn()
	
	-- check distance for next step
	if (parent:GetOrigin() - self.parent_origin + target):Length2D()>self.distance then
		self:Destroy()
		return
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_tatsumaki_moon_fall_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_tatsumaki_moon_fall_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
	local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControl( effect_cast, 1, self.direction * self.speed )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- -- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )
	EmitSoundOn( sound_loop, self:GetParent() )
end

modifier_tatsumaki_moon_fall_burn = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tatsumaki_moon_fall_burn:IsHidden()
	return false
end

function modifier_tatsumaki_moon_fall_burn:IsDebuff()
	return true
end

function modifier_tatsumaki_moon_fall_burn:IsStunDebuff()
	return false
end

function modifier_tatsumaki_moon_fall_burn:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_tatsumaki_moon_fall_burn:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tatsumaki_moon_fall_burn:OnCreated( kv )
	if IsServer() then
		-- references
		local damage = self:GetAbility():GetSpecialValueFor( "burn_dps" )
		local delay = 1
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- Start interval
		self:StartIntervalThink( delay )
	end
end

function modifier_tatsumaki_moon_fall_burn:OnRefresh( kv )
	
end

function modifier_tatsumaki_moon_fall_burn:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_tatsumaki_moon_fall_burn:OnIntervalThink()
	-- damage
	ApplyDamage( self.damageTable )

	-- play effects
	local sound_tick = "Hero_Invoker.ChaosMeteor.Damage"
	EmitSoundOn( sound_tick, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_tatsumaki_moon_fall_burn:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf"
end

function modifier_tatsumaki_moon_fall_burn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
