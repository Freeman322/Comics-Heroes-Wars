rough_wave = class({})

--------------------------------------------------------------------------------

function rough_wave:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()
	 
	local sound = "Hero_VengefulSpirit.WaveOfTerror"
	local projectile = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
	if self:GetCaster():HasModifier("modifier_arcana") then
		projectile = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf" 
	    sound = "Hero_QueenOfPain.SonicWave" end

	local info = {
		EffectName = projectile,
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = 150,
		fEndRadius = 150,
		vVelocity = vDirection * 1000,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = 100,
	}
	self.nProjID = ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( sound, self:GetCaster() )
end



function rough_wave:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self,
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun") } )
	end

	return false
end

function rough_wave:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

