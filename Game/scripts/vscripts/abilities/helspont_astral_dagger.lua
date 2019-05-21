helspont_astral_dagger = class({})

--------------------------------------------------------------------------------

function helspont_astral_dagger:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )
	self.dagger_speed = self:GetSpecialValueFor( "dagger_speed" )
	self.dagger_offset = self:GetSpecialValueFor( "dagger_offset" )
	self.dagger_count = self:GetSpecialValueFor( "dagger_count" )
	self.dagger_rate = self:GetSpecialValueFor( "dagger_rate" )
	self.dagger_range = self:GetSpecialValueFor( "dagger_range" )

	self.vTargetLocation = self:GetCursorPosition()
	self.flAccumulatedTime = 0.0
	self.vDirection = self.vTargetLocation - self:GetCaster():GetOrigin()
	self.nDaggersThrown = 0

	local vDirection = self.vTargetLocation  - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self:ThrowDagger( vDirection )
end

--------------------------------------------------------------------------------

function helspont_astral_dagger:OnChannelThink( flInterval )
	self.flAccumulatedTime = self.flAccumulatedTime + flInterval
	if self.flAccumulatedTime >= self.dagger_rate then
		self.flAccumulatedTime = self.flAccumulatedTime - self.dagger_rate

		local vOffset = RandomVector( self.dagger_offset )
		vOffset.z = 0.0

		local vDirection = ( self.vTargetLocation + vOffset ) - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self:ThrowDagger( vDirection )
	end
end

--------------------------------------------------------------------------------

function helspont_astral_dagger:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
		EmitSoundOn( "Hero_PhantomAssassin.Dagger.Target", hTarget )
		
    		ApplyDamage({attacker = self:GetCaster(), victim = hTarget, damage = (self:GetSpecialValueFor("dmg_pct_fake")/100)*hTarget:GetHealth(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
	end

	return true
end

--------------------------------------------------------------------------------

function helspont_astral_dagger:ThrowDagger( vDirection )
	local info =
	{
		EffectName = "particles/econ/items/vengeful/vengeful_weapon_talon/vengeful_wave_of_terror_weapon_talon.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = 50.0,
		fEndRadius = 50.0,
		vVelocity = vDirection * self.dagger_speed,
		fDistance = self.dagger_range,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_PhantomAssassin.Dagger.Cast", self:GetCaster() )

	self.nDaggersThrown = self.nDaggersThrown + 1
	if self.nDaggersThrown >= self.dagger_count then
		self:EndChannel( false )
	else
		self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_1, 1.33 )
	end
end

function helspont_astral_dagger:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

