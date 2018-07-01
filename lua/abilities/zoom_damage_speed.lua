LinkLuaModifier( "modifier_zoom_damage_speed", "abilities/zoom_damage_speed.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zoom_damage_speed_caster", "abilities/zoom_damage_speed.lua", LUA_MODIFIER_MOTION_NONE )

zoom_damage_speed = class({})

function zoom_damage_speed:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControlEnt( nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nCasterFX )

	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	EmitSoundOn( "Hero_Invoker.ColdSnap", hCaster )
	EmitSoundOn( "Hero_Invoker.ColdSnap.Cast", hTarget )

	local caster_as = hCaster:GetIdealSpeed()

	local damage = caster_as * self:GetSpecialValueFor("damage")/100

	if damage > 2000 then
		damage = 2000 
	end

	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun")})
	
	local damageTable = {
		victim = hTarget,
		attacker = hCaster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	ApplyDamage(damageTable)


	if hTarget:GetHealth() <= 0 then
		self:GetCaster():SetBaseMoveSpeed(self:GetCaster():GetBaseMoveSpeed() + 5)
		hTarget:SetBaseMoveSpeed(hTarget:GetBaseMoveSpeed() - 5)
	end
end

function zoom_damage_speed:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_doomsday_clock") then return "custom/reverse_speed_entire_speed" end
	return self.BaseClass.GetAbilityTextureName(self) 
end
