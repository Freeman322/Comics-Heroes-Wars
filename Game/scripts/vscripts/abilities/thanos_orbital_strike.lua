thanos_orbital_strike = class({})
LinkLuaModifier( "modifier_thanos_orbital_strike_thinker", "abilities/thanos_orbital_strike.lua", LUA_MODIFIER_MOTION_NONE )

function thanos_orbital_strike:IsStealable() return false end
function thanos_orbital_strike:GetAOERadius() return self:GetSpecialValueFor( "area_of_effect" ) end

function thanos_orbital_strike:OnSpellStart()
     if IsServer() then
          -- unit identifier
          local caster = self:GetCaster()
          local point = self:GetCursorPosition()

          -- get values
          local delay = self:GetSpecialValueFor("delay")
          local vision_distance = self:GetSpecialValueFor("vision_distance")
          local vision_duration = self:GetSpecialValueFor("vision_duration")
          
          local min_dist = self:GetSpecialValueFor("strike_distance")

          local curr_dist = 0

          -- create vision
          AddFOWViewer( caster:GetTeamNumber(), point, vision_distance, vision_duration, false )

          local num = self:GetSpecialValueFor("strike_count")

          for i = 1, num do
               CreateModifierThinker(
                    caster,
                    self,
                    "modifier_thanos_orbital_strike_thinker",
                    { duration = delay },
                    point + RandomVector(1) * RandomFloat(curr_dist, curr_dist + 450),
                    caster:GetTeamNumber(),
                    false
               )

               curr_dist = curr_dist + min_dist --- минимум 75 друг от друга
          end
     end
end

modifier_thanos_orbital_strike_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_thanos_orbital_strike_thinker:IsHidden() return true end
function modifier_thanos_orbital_strike_thinker:IsPurgable() return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_thanos_orbital_strike_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		self.damage = self:GetAbility():GetSpecialValueFor("damage_of_each_strike")
		self.radius = self:GetAbility():GetSpecialValueFor("area_of_effect")

		-- Play effects
		self:PlayEffects1()
	end
end

function modifier_thanos_orbital_strike_thinker:OnDestroy( kv )
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
function modifier_thanos_orbital_strike_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_big_ray_immortal1.vpcf"
	local sound_cast = "Hero_Invoker.SunStrike.Charge.Apex"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_thanos_orbital_strike_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
	local sound_cast =    "Hero_Invoker.SunStrike.Ignite.Apex"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end