thanos_first_blood = class({})
LinkLuaModifier ("modifier_thanos_first_blood", "abilities/thanos_first_blood.lua", LUA_MODIFIER_MOTION_NONE)


function thanos_first_blood:OnAbilityPhaseStart()
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_loadout.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetCaster():GetOrigin(), true )

	local vLightningOffset = self:GetCaster():GetOrigin() + Vector( 0, 0, 1600 )
	ParticleManager:SetParticleControl( nFXIndex, 1, vLightningOffset )

	ParticleManager:ReleaseParticleIndex( nFXIndex )

	return true
end

--------------------------------------------------------------------------------

function thanos_first_blood:OnSpellStart()
	local vision_radius = 225
	local bolt_speed = 2000

	local info = {
			EffectName = "particles/items4_fx/nullifier_proj.vpcf",
			Ability = self,
			iMoveSpeed = bolt_speed,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			bDodgeable = true,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = vision_radius,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, 
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_DarkWillow.Fear.Target", self:GetCaster() )
	EmitSoundOn( "Hero_DarkWillow.Fear.FP", self:GetCaster() )
end

--------------------------------------------------------------------------------

function thanos_first_blood:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then

		EmitSoundOn( "Hero_DarkWillow.Fear.Cast", hTarget )

		local stun_duration = self:GetSpecialValueFor( "stun_duration" )

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_thanos_first_blood", { duration = self:GetSpecialValueFor( "debuff_duration" ) } )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}

		ApplyDamage( damage )
	end

	return true
end

modifier_thanos_first_blood = class({})


function modifier_thanos_first_blood:IsHidden()
	return true
end

function modifier_thanos_first_blood:IsPurgable()
	return false
end


function modifier_thanos_first_blood:OnCreated( kv )
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:StartIntervalThink(1)

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

function modifier_thanos_first_blood:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

function modifier_thanos_first_blood:OnIntervalThink()
	if IsServer() then
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetSpecialValueFor("health_drain"),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}

		ApplyDamage( damage )

		self:GetCaster():Heal(self:GetAbility():GetSpecialValueFor("health_drain"), self)

		local particle_lifesteal = "particles/units/heroes/hero_dark_willow/dark_willow_loadout.vpcf"
		local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	end
end


function modifier_thanos_first_blood:CheckState()
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}

	return state
end

