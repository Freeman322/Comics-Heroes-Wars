if not tatsumaki_flying_death then tatsumaki_flying_death = class({}) end 

LinkLuaModifier( "modifier_tatsumaki_flying_death", "abilities/tatsumaki_flying_death", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function tatsumaki_flying_death:OnSpellStart()
     if IsServer() then
          local hTarget = self:GetCursorTarget()

          EmitSoundOn( "Tatsumaki.Cast1.Start", self:GetCaster() )

          self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tatsumaki_flying_death", {target = hTarget:entindex()})
     end
end

--------------------------------------------------------------------------------
-- Projectile
function tatsumaki_flying_death:OnProjectileHit( target, location )
	if not target then return end
	if target:TriggerSpellAbsorb( self ) then return end

     local stun = self:GetSpecialValueFor( "earth_spike_stun" )
     
	-- stun
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = stun } -- kv
	)

     ApplyDamage({
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("earth_spike_damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	})


     EmitSoundOn( "Hero_Lion.ImpaleTargetLand", target )

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_lion/lion_spell_impale_hit_spikes.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( "Hero_Lion.ImpaleHitTarget", target )
end

if not modifier_tatsumaki_flying_death then modifier_tatsumaki_flying_death = class({}) end 

modifier_tatsumaki_flying_death = class({
     IsHidden = function() return true end,
     IsPurgable = function() return false end,
     RemoveOnDeath = function() return true end,
     CheckState = function() return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true} end
 })
 
 function modifier_tatsumaki_flying_death:GetEffectName()
     return "particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_iron.vpcf"
 end
 
 function modifier_tatsumaki_flying_death:OnCreated(params)
     if not IsServer() then return end
     
     self.target = EntIndexToHScript(params.target)
     self.speed = self:GetAbility():GetSpecialValueFor("fly_speed")
     self.traveled_distance = 0
     self:StartIntervalThink(FrameTime())
 end
 
 function modifier_tatsumaki_flying_death:OnIntervalThink()
     if not IsServer() then return end

     self:GetCaster():FaceTowards(self.target:GetAbsOrigin())

     self.distance = (self.target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()

     if self.distance > 120 then
         self:GetCaster():SetOrigin(self:GetCaster():GetAbsOrigin() + (self.target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * self.speed * FrameTime())
         self.traveled_distance = self.traveled_distance + self.speed * FrameTime()
     else
         self:Destroy()
     end
 end
 
 function modifier_tatsumaki_flying_death:OnDestroy()
     if not IsServer() then return end

     local caster = self:GetCaster()

     if self.distance <= 150 then
          local damage = self:GetAbility():GetSpecialValueFor("fly_base_damage") + (caster:GetAverageTrueAttackDamage(self.target) * (self:GetAbility():GetSpecialValueFor("fly_crit_pct") / 100))

          ApplyDamage({
               victim = self.target,
               attacker = caster,
               ability = self:GetAbility(),
               damage = damage,
               damage_type = self:GetAbility():GetAbilityDamageType()
          })

          FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)

          local explosion5 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/death/mk_arcana_spring_cast_outer_death_pnt.vpcf", PATTACH_WORLDORIGIN, self.target)
          ParticleManager:SetParticleControl(explosion5, 0, self.target:GetAbsOrigin())

          local projectile_name = "particles/econ/items/lion/lion_ti9/lion_spell_impale_hit_ti9_spikes.vpcf"
          local projectile_distance = self:GetAbility():GetSpecialValueFor("earth_spike_range")
          local projectile_radius = self:GetAbility():GetSpecialValueFor( "earth_spike_radius" )
          local projectile_speed = self:GetAbility():GetSpecialValueFor( "fly_speed" )
          local projectile_direction = (self.target:GetAbsOrigin() - caster:GetOrigin()):Normalized()

          local info = {
               Source = caster,
               Ability = self:GetAbility(),
               vSpawnOrigin = caster:GetAbsOrigin(),
                    
               bDeleteOnHit = false,
               
               iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
               iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
               iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
               
               EffectName = projectile_name,
               fDistance = projectile_distance,
               fStartRadius = projectile_radius,
               fEndRadius = projectile_radius,
               vVelocity = projectile_direction * projectile_speed,
          }

          ProjectileManager:CreateLinearProjectile(info)
     end
 end
 