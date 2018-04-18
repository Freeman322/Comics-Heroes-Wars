if quicsilver_relative_blast == nil then quicsilver_relative_blast = class({}) end

function quicsilver_relative_blast:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = 100,
		fEndRadius = 100,
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
	EmitSoundOn( "Hero_Sven.StormBolt" , self:GetCaster() )
end


function quicsilver_relative_blast:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		self.damage = self:GetAbilityDamage()
		local vDist = (hTarget:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
		self.damage = self.damage + (vDist* (self:GetSpecialValueFor("blast_damage")/100))
		 if self:GetCaster():HasTalent("special_bonus_unique_quicksilver") then
	        self.damage = self.damage * 1.5
	    end
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = this,
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("blast_stun_duration") } )
	end

	return false
end

function quicsilver_relative_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

