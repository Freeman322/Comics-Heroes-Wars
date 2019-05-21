if predator_plasma_shot == nil then predator_plasma_shot = class({}) end

function predator_plasma_shot:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function predator_plasma_shot:OnUpgrade()
	if self:GetCaster():HasAbility("predator_plasma_shot_mode") then
    self:GetCaster():FindAbilityByName("predator_plasma_shot_mode"):SetLevel(1)
  end
end

function predator_plasma_shot:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function predator_plasma_shot:GetCastRange( vLocation, hTarget )
  if self:GetCaster():HasModifier("modifier_predator_tree_dance_tree") then
		return self.BaseClass.GetCastRange( self, vLocation, hTarget ) + 1500
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function predator_plasma_shot:GetCooldown( nLevel )
	if self:GetCaster():HasModifier("modifier_predator_plasma_shot_mode") then
		return self.BaseClass.GetCooldown( self, nLevel ) + self.BaseClass.GetCooldown( self, nLevel )/5
	end

	return self.BaseClass.GetCooldown( self, nLevel )
end


function predator_plasma_shot:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()

		EmitSoundOn("Beerus.Ult", self:GetCaster())
	end

	return true
end

function predator_plasma_shot:OnSpellStart()
  if IsServer() then
    if self:GetCaster():HasModifier("modifier_predator_plasma_shot_mode") then
        self:GetCaster():ModifyHealth(self:GetCaster():GetHealth() - (self:GetCaster():GetMaxHealth() * 0.33), self, false, 0)
    end
  end

  	local effect = "particles/items2_fx/skadi_projectile.vpcf"

  	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "beerus") then
  		effect = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf"
  	end 
  	
	local info = {
			EffectName = effect,
			Ability = self,
			iMoveSpeed = 1700,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Invoker.EMP.Cast", self:GetCaster() )
end


function predator_plasma_shot:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		EmitSoundOn( "Hero_Invoker.EMP.Discharge", hTarget )
		EmitSoundOn( "Hero_Lina.LagunaBladeImpact.Immortal", hTarget )

		self.damage = self:GetAbilityDamage() + (hTarget:GetMaxHealth() * (self:GetSpecialValueFor("bonus_damage")/100))
		
		if self:GetCaster():HasModifier("modifier_predator_plasma_shot_mode") then
			self.damage = self.damage + (hTarget:GetMaxHealth() * 0.33)
		end
		
		self.bonus = 0
		
		if self:GetCaster():HasTalent("special_bonus_unique_predator") then
			self.bonus = self:GetCaster():FindTalentValue("special_bonus_unique_predator")	
		end	
		
		self.damage = self.damage + self.bonus
		
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_predator/predator_plasma_shot_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 0.50 } )

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "beerus") then
			local nFXIndex = ParticleManager:CreateParticle( "particles/galactus/galactus_seed_of_ambition_eternal_item.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControl(nFXIndex, 0, hTarget:GetAbsOrigin())
			ParticleManager:SetParticleControl(nFXIndex, 2, hTarget:GetAbsOrigin())
			ParticleManager:SetParticleControl(nFXIndex, 3, hTarget:GetAbsOrigin())
			ParticleManager:SetParticleControl(nFXIndex, 6, hTarget:GetAbsOrigin())
			ParticleManager:SetParticleControl (nFXIndex, 1, Vector (750, 750, 0))
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse.TI8", self:GetCaster() )
		end

		ApplyDamage( damage )
	end

	return true
end

function predator_plasma_shot:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

