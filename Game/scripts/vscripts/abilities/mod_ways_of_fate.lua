mod_ways_of_fate = class ({})

mod_ways_of_fate.m_flElapsedTime = 0
mod_ways_of_fate.m_vCursorPos = nil
mod_ways_of_fate.units = {}

local EF_MINISTUN_DURATION = 0.03

function mod_ways_of_fate:OnAbilityPhaseStart()
    if IsServer() then 
        local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf"
        local sound_precast = "Hero_Grimstroke.DarkArtistry.PreCastPoint"

        self.m_flElapsedTime = 0
        self.m_vCursorPos = self:GetCursorPosition()
        self.units = {}

        -- Create Particle
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            self:GetCaster(),
            PATTACH_POINT_FOLLOW,
            "attach_attack2",
            Vector( 0,0,0 ), -- unknown
            true -- unknown, true
        )
        ParticleManager:ReleaseParticleIndex( effect_cast )

        -- Create Sound
        EmitSoundOn( sound_precast, self:GetCaster() )
    end

	return true 
end

function mod_ways_of_fate:OnAbilityPhaseInterrupted()
    if IsServer() then 
        local sound_precast = "Hero_Grimstroke.DarkArtistry.PreCastPoint"
        StopSoundOn( sound_precast, self:GetCaster() )
    end
end

function mod_ways_of_fate:OnChannelThink(flTime)
    if IsServer() then 
         self.m_flElapsedTime = self.m_flElapsedTime + flTime
    end 
end


function mod_ways_of_fate:OnChannelFinish( bInterrupted )
    if IsServer() then
        local caster = self:GetCaster()

        -- load data
        local spawnDelta = 150

        -- set up projectile
        local projectile_name = "particles/econ/items/grimstroke/ti9_immortal/gs_ti9_artistry_proj.vpcf"

        local distance = self:GetCastRange( self.m_vCursorPos, nil )
        local start_radius = self:GetSpecialValueFor("start_radius")
        local end_radius = self:GetSpecialValueFor("end_radius")
        local speed = self:GetSpecialValueFor("projectile_speed")

        local spawnPos = caster:GetOrigin()
        local direction = self.m_vCursorPos-spawnPos
        direction.z = 0
        direction = direction:Normalized()

        -- create linear projectile
        local info = {
            Source = self:GetCaster(),
            Ability = self,
            vSpawnOrigin = spawnPos,
            
            bDeleteOnHit = false,
            
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            
            EffectName = projectile_name,
            fDistance = distance,
            fStartRadius = start_radius,
            fEndRadius =end_radius,
            vVelocity = direction * speed,
        
            bHasFrontalCone = false,
            bReplaceExisting = false,
            
            bProvidesVision = false,

            EffectSound = "Hero_Grimstroke.DarkArtistry.Projectile",
            ProjectileSound = "Hero_Grimstroke.DarkArtistry.Projectile",
            SoundName = "Hero_Grimstroke.DarkArtistry.Projectile",
            Sound = "Hero_Grimstroke.DarkArtistry.Projectile",
            SoundEvent = "Hero_Grimstroke.DarkArtistry.Projectile",
        }

        ProjectileManager:CreateLinearProjectile(info)

        caster:StartGesture(ACT_DOTA_CHANNEL_END_ABILITY_3)
        
        -- effects
        local sound_cast1 = "Hero_Grimstroke.DarkArtistry.Cast"
        local sound_cast2 = "Hero_Grimstroke.DarkArtistry.Cast.Layer"

        -- local sound_cast_proj = "Hero_Grimstroke.DarkArtistry.Projectile"
        EmitSoundOn( sound_cast1, caster )
        EmitSoundOn( sound_cast2, caster )
    end 
end

function mod_ways_of_fate:OnProjectileHit( target, location )
    if IsServer() then
        if not target then return false end 

        table.insert( self.units, target )

		-- get data
        local multiplier = #self.units
        
		local base_damage = self:GetSpecialValueFor( "damage" )
		local plus_damage = self:GetSpecialValueFor( "bonus_damage_per_target" )
        local slow = self:GetSpecialValueFor( "slow_duration" )
        
		-- damage
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = ((base_damage + multiplier*plus_damage) * self.m_flElapsedTime) + ((self:GetSpecialValueFor("current_health_damage_ptc") / 100) * target:GetHealth()),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
        }
        
		ApplyDamage(damageTable)

		-- debuff
		target:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_grimstroke_dark_artistry_slow", -- modifier name
			{
				duration = slow,
			} -- kv
        )
        
        target:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{
				duration = EF_MINISTUN_DURATION,
			} -- kv
		)

		-- play effects
		-- Get Resources
        local particle_cast = "particles/econ/items/grimstroke/ti9_immortal/gs_ti9_artistry_dmg_stroke_tgt.vpcf"
        local sound_target = "Hero_Grimstroke.DarkArtistry.Damage"
        local sound_creep = "Hero_Grimstroke.DarkArtistry.Damage.Creep"

        -- Create Particle
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
        ParticleManager:ReleaseParticleIndex( effect_cast )

        -- Create Sound
        if target:IsCreep() then
            EmitSoundOn( sound_creep, target )
        else
            EmitSoundOn( sound_target, target )
        end
	end
end


