tatsumaki_moon_fall = class({})

LinkLuaModifier( "modifier_tatsumaki_moon_fall_thinker", "abilities/tatsumaki_moon_fall.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tatsumaki_moon_fall_burn_thinker", "abilities/tatsumaki_moon_fall.lua", LUA_MODIFIER_MOTION_NONE )
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
			damage_type = DAMAGE_TYPE_PURE,
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

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_tatsumaki_moon_fall_thinker:OnIntervalThink()
	if not self.fallen then
		-- meatball has fallen
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
	else
		self:Destroy()
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

function modifier_tatsumaki_moon_fall_thinker:OnDestroy()
	if IsServer() then
		-- Get Resources
		local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"

		-- add vision
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision, self.vision_duration, false)

		StopSoundOn( "Hero_Invoker.ChaosMeteor.Loop", self:GetParent() )
		
		EmitSoundOnLocationWithCaster( self:GetParent():GetAbsOrigin(), "Hero_Invoker.ChaosMeteor.Destroy", self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetAbsOrigin(), "Hero_Invoker.ChaosMeteor.Impact", self:GetParent() )
		
		EmitSoundOn( sound_impact, self:GetParent() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/tatsumaki/tatsumaki_ground.vpcf", PATTACH_CUSTOMORIGIN, thinker)
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 5, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		self:AddParticle( nFXIndex, false, false, -1, false, true )

		local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova_explode_a.vpcf", PATTACH_CUSTOMORIGIN, nil );

		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin());
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetAbsOrigin());
		ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetAbsOrigin());

		ParticleManager:SetParticleControl( nFXIndex, 5, Vector(self.radius, self.radius, 0));
		ParticleManager:ReleaseParticleIndex( nFXIndex );
		self:AddParticle( nFXIndex, false, false, -1, false, true )

		EmitSoundOn( "Hero_EarthShaker.EchoSlam", self:GetParent() )
		EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", self:GetParent() )
		EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", self:GetParent() )
		EmitSoundOn( "PudgeWarsClassic.echo_slam", self:GetParent() )

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
			ApplyDamage( {
				attacker = self:GetCaster(),
				victim = enemy,
				damage = self:GetAbility():GetAbilityDamage(),
				damage_type = DAMAGE_TYPE_PURE,
				ability = self:GetAbility()
			} )

			-- add modifier
			enemy:AddNewModifier(
				self:GetCaster(), -- player source
				self:GetAbility(), -- ability source
				"modifier_stunned", -- modifier name
				{ duration = 1.75 } -- kv
			)
		end

		local team_id = self:GetCaster():GetTeamNumber()
		CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_tatsumaki_moon_fall_burn_thinker", {duration = self:GetAbility():GetSpecialValueFor("burn_duration")}, self.parent_origin, team_id, false)
	end
end

modifier_tatsumaki_moon_fall_burn_thinker = class ({})

function modifier_tatsumaki_moon_fall_burn_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
	   local target = self:GetParent():GetAbsOrigin()
	   
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard_fire_inner.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target)
        ParticleManager:SetParticleControl( nFXIndex, 1, target)
	   self:AddParticle( nFXIndex, false, false, -1, false, true )
	   
        AddFOWViewer( thinker:GetTeam(), target, 1500, 5, false)
        GridNav:DestroyTreesAroundPoint(target, 1500, false)
    end
end

function modifier_tatsumaki_moon_fall_burn_thinker:CheckState()
	return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_tatsumaki_moon_fall_burn_thinker:IsAura()
    return true
end

function modifier_tatsumaki_moon_fall_burn_thinker:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("vision_distance")
end

function modifier_tatsumaki_moon_fall_burn_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_tatsumaki_moon_fall_burn_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_tatsumaki_moon_fall_burn_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_tatsumaki_moon_fall_burn_thinker:GetModifierAura()
    return "modifier_tatsumaki_moon_fall_burn"
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
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self:GetAbility():GetSpecialValueFor( "damage_interval" ) )
	end
end

function modifier_tatsumaki_moon_fall_burn:OnRefresh( kv )
	
end

function modifier_tatsumaki_moon_fall_burn:OnDestroy( kv )

end

function modifier_tatsumaki_moon_fall_burn:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true
	}

	return state
end

function modifier_tatsumaki_moon_fall_burn:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_tatsumaki_moon_fall_burn:GetModifierMoveSpeed_Absolute()
	return 155
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
