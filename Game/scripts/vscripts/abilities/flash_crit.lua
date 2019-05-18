if flash_crit == nil then
	flash_crit = class({})
end

function flash_crit:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("cooldown_scepter")
	end

    	return self.BaseClass.GetCooldown( self, nLevel )
end

function flash_crit:GetCastRange( vLocation, hTarget )
	return 600
end

function flash_crit:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	return behav
end

function flash_crit:OnSpellStart()
	local target = self:GetCursorTarget()
	local attacker = self:GetCaster()
	local ability = self
	if target ~= nil then
		if ( not target:TriggerSpellAbsorb( self ) ) then
			self.damage_percent = ability:GetSpecialValueFor( "crit_multiplier" )/100
			
			if attacker:HasScepter() then
				self.damage_percent = ability:GetSpecialValueFor( "crit_multiplier_scepter" )/100
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
			ParticleManager:ReleaseParticleIndex( nFXIndex );
	
			EmitSoundOn( "Ability.LagunaBladeImpact", self:GetCaster() )
			
			self.damage = attacker:GetIdealSpeed() * self.damage_percent

			EmitSoundOn( "Ability.LagunaBladeImpact", target )

			ApplyDamage({victim = target, attacker = attacker, damage = self.damage, damage_type = DAMAGE_TYPE_PURE})
		end

	end
end

function flash_crit:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

