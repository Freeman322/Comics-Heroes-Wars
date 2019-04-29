LinkLuaModifier( "modifier_zoom_damage_speed", "abilities/zoom_damage_speed.lua", LUA_MODIFIER_MOTION_NONE )

zoom_damage_speed = class({})

function zoom_damage_speed:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hTarget:TriggerSpellAbsorb(self) then return end
	local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControlEnt( nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nCasterFX )

	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	EmitSoundOn( "Hero_Invoker.ColdSnap", hCaster )
	EmitSoundOn( "Hero_Invoker.ColdSnap.Cast", hTarget )

	local caster_ms = hCaster:GetIdealSpeed()
	if caster_ms > 1000 then
		caster_ms = 1000
	end

	local damage = caster_ms * self:GetSpecialValueFor("damage") / 100

	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})

	ApplyDamage({
		victim = hTarget,
		attacker = hCaster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	})


	if hTarget:IsRealHero() and hTarget:GetHealth() <= 0 then
		hCaster:SetBaseMoveSpeed(hCaster:GetBaseMoveSpeed() + self:GetSpecialValueFor("speed_steal"))
		hTarget:SetBaseMoveSpeed(hTarget:GetBaseMoveSpeed() - self:GetSpecialValueFor("speed_steal"))
	end

end

function zoom_damage_speed:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_doomsday_clock") then return "custom/reverse_speed_entire_speed" end
	return self.BaseClass.GetAbilityTextureName(self)
end
