if quicsilver_relative_blast == nil then quicsilver_relative_blast = class({}) end

function quicsilver_relative_blast:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/quicksilver_blast_custom"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end

function quicsilver_relative_blast:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	local particle = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf"
	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "void_of_darkness") == true then particle = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf" EmitSoundOn("Quicksilver.CustomItem.Cast", self:GetCaster()) end 
	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "android") == true then particle = "particles/qucksilver_blast_gold.vpcf"  end 

	local info = {
		EffectName = particle,
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(),
		fStartRadius = 100,
		fEndRadius = 100,
		vVelocity = vDirection * 1000,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
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

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("blast_stun_duration") } )

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "void_of_darkness") == true then
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn("Quicksilver.CustomItem.Cast", hTarget)
		end

		ApplyDamage( damage )
	end

	return false
end
