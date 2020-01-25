beyonder_void_strike = class({})

function beyonder_void_strike:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function beyonder_void_strike:OnSpellStart()
	print("On spell start is called!")
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local angle = 0.5 * self:GetSpecialValueFor("angle")

	local origin = caster:GetOrigin()
	local target_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles(target_direction).y
	local targets = FindUnitsInRadius (caster:GetTeamNumber(), origin, nil,	radius,	self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(),	FIND_ANY_ORDER,	false )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/voidspirit_overload_discharge.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Complete", self:GetCaster() )

	for _, target in pairs(targets) do
		local target_direction = (target:GetOrigin() - origin):Normalized()
		local target_angle = VectorToAngles(target_direction).y
		local angle_diff = math.abs(AngleDiff(cast_angle, target_angle))	
		local stun = self:GetCaster():GetMana()/1000


		target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun})

		caster:PerformAttack(target, true, true, true, true, true, false, true)
		self:PlayEffects2( target, origin, target_direction )
	end
end

function beyonder_void_strike:PlayEffects1( caught, direction )

	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"
	local sound_cast = "Hero_Mars.Shield.Cast"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function beyonder_void_strike:PlayEffects2( target, origin, direction )

	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"
	local sound_cast = "Hero_Mars.Shield.Crit"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end