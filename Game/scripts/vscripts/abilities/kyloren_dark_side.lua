kyloren_dark_side = class({})

function kyloren_dark_side:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_queenofpain/queen_sonic_wave_streak.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = 250,
		fEndRadius = 300,
		vVelocity = vDirection * 1500,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = 250,
	}

    self.nProjID = ProjectileManager:CreateLinearProjectile( info )
    
    EmitSoundOn( "Kyloren.Blast" , self:GetCaster() )
end

function kyloren_dark_side:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self,
		}

		ApplyDamage( damage )

        local point = self:GetCaster():GetAbsOrigin()

        local duration = self:GetSpecialValueFor("knockback_duration")
        if self:GetCaster():HasTalent("special_bonus_unique_kyloren_3") then
            duration = duration + (self:GetCaster():FindTalentValue("special_bonus_unique_kyloren_3") or 0)
        end
        
		local knockbackProperties =
	    {
	        center_x = point.x,
	        center_y = point.y,
	        center_z = point.z,
	        duration = duration,
	        knockback_duration = duration,
	        knockback_distance = 600,
	        knockback_height = 0
	    }

        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
	end

	return false
end

