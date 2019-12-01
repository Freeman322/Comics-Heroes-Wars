collector_sun_strike = class({})
LinkLuaModifier( "modifier_collector_sun_strike_thinker", "abilities/collector_sun_strike.lua", LUA_MODIFIER_MOTION_NONE )

function collector_sun_strike:IsStealable()
	return false
end

function collector_sun_strike:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function collector_sun_strike:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- get values
	local delay = self:GetSpecialValueFor("delay")
	local vision_distance = self:GetSpecialValueFor("vision_distance")
	local vision_duration = self:GetSpecialValueFor("vision_duration")

	-- create modifier thinker
	CreateModifierThinker(
		caster,
		self,
		"modifier_collector_sun_strike_thinker",
		{ duration = delay },
		point,
		caster:GetTeamNumber(),
		false
	)

	-- create vision
	AddFOWViewer( caster:GetTeamNumber(), point, vision_distance, vision_duration, false )

    if self:GetCaster():HasTalent("special_bonus_unique_collector_4") then 
        local num = self:GetCaster():FindTalentValue("special_bonus_unique_collector_4")

        for i = 1, num do
        	CreateModifierThinker(
				caster,
				self,
				"modifier_collector_sun_strike_thinker",
				{ duration = delay },
				point + RandomVector(1) * RandomFloat(0, 450),
				caster:GetTeamNumber(),
				false
			)
        end
    end 
end

modifier_collector_sun_strike_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_collector_sun_strike_thinker:IsHidden()
	return true
end

function modifier_collector_sun_strike_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_collector_sun_strike_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		self.damage = self:GetAbility():GetOrbSpecialValueFor("damage","e")
		self.radius = self:GetAbility():GetSpecialValueFor("area_of_effect")

		-- Play effects
		self:PlayEffects1()
	end
end

function modifier_collector_sun_strike_thinker:OnDestroy( kv )
	if IsServer() then
		-- Damage enemies
		local damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			-- damage = self.damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
		}

		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			damageTable.damage = self.damage
			ApplyDamage(damageTable)
		end

		-- Play effects
		self:PlayEffects2()

		-- remove thinker
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_collector_sun_strike_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf"
	local sound_cast = "Hero_Invoker.SunStrike.Charge.Apex"

	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "strange_artifact") then
	    particle_cast = "particles/econ/items/lina/lina_ti7/light_strike_array_pre_ti7_gold.vpcf"
		sound_cast = "Ability.PreLightStrikeArray.ti7"
      end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_collector_sun_strike_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
	local sound_cast = "Hero_Invoker.SunStrike.Ignite.Apex"

	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "strange_artifact") then
		 particle_cast = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7_gold.vpcf"
		 sound_cast = "Hero_Phoenix.SuperNova.Explode"
      end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end