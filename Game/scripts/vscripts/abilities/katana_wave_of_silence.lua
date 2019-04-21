katana_wave_of_silence = class({})

LinkLuaModifier( "modifier_katana_wave_of_silence", "abilities/katana_wave_of_silence.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function katana_wave_of_silence:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/econ/items/drow/drow_ti6/drow_ti6_silence_wave.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = 250,
		fEndRadius = 250,
		vVelocity = vDirection * 2000,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = 250,
	}

	self.nProjID = ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_PhantomAssassin.Strike.End" , self:GetCaster() )
end

function katana_wave_of_silence:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_PURE,
			ability = this,
		}

		ApplyDamage( damage )

		local point = hTarget:GetAbsOrigin()
		local knockbackProperties =
	    {
	        center_x = point.x,
	        center_y = point.y,
	        center_z = point.z,
	        duration = self:GetSpecialValueFor("knockback_duration"),
	        knockback_duration = self:GetSpecialValueFor("knockback_duration"),
	        knockback_distance = self:GetSpecialValueFor("knockback_distance_max"),
	        knockback_height = 0
	    }

        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_katana_wave_of_silence", { duration = self:GetSpecialValueFor("silence_duration") } )
	end

	return false
end

modifier_katana_wave_of_silence = class({})

function modifier_katana_wave_of_silence:IsHidden()
	return true
end

function modifier_katana_wave_of_silence:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf"
end

function modifier_katana_wave_of_silence:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_katana_wave_of_silence:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_katana_wave_of_silence:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("speed_reduction")
end


function modifier_katana_wave_of_silence:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("attack_reduction")
end

function katana_wave_of_silence:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

