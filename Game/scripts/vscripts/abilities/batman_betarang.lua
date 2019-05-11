batman_betarang = class({})

batman_betarang.m_vLastOrigin = nil

function batman_betarang:OnSpellStart()
	local info = {
			EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor("betarang_speed"),
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_BountyHunter.Shuriken", self:GetCaster() )
	self.max_bounces = self:GetSpecialValueFor("max_bounce")

	if self:GetCaster():HasTalent("special_bonus_unique_batman_1") then self.max_bounces = self.max_bounces + (self:GetCaster():FindTalentValue("special_bonus_unique_batman_1") or 1) end

	if self:GetCaster():HasModifier("modifier_batman_infinity_gauntlet") then
        EmitSoundOn("Batman.InfinityMidas.Cast", self:GetCaster())
    end
end

function batman_betarang:GetCooldown( nLevel )
    return IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_batman") or self.BaseClass.GetCooldown( self, nLevel )
end

--------------------------------------------------------------------------------

function batman_betarang:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_BountyHunter.Shuriken.Impact", hTarget )

		local dmg = self:GetAbilityDamage()

		if self:GetCaster():HasScepter() then
			dmg = dmg + self:GetCaster():GetStrength()
		end

		self.m_vLastOrigin = hTarget:GetAbsOrigin()

		ApplyDamage({
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = dmg,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		})

		AddNewModifier_pcall(hTarget, self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") } )

		if self.max_bounces == 0 then
			return nil
		end

		local next_target = self:GetCaster()

		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), (self.m_vLastOrigin or self:GetCaster():GetAbsOrigin()), nil, self:GetSpecialValueFor("bounce_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #units > 0 then
			for _,target in pairs(units) do
				if target ~= nil and (not target:IsMagicImmune()) and (not target:IsInvulnerable()) and target ~= hTarget then
					local info = {
						EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
						Ability = self,
						iMoveSpeed = self:GetSpecialValueFor("betarang_speed"),
						Source = hTarget,
						Target = target,
						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
					}

					if info.Source:IsNull() or not info.Source then info.Source = self:GetCaster() end 

					self.max_bounces = self.max_bounces - 1
					
					ProjectileManager:CreateTrackingProjectile( info )

					next_target = target
					break
				end
			end
		end

		if self:GetCaster():HasModifier("modifier_batman_infinity_gauntlet") and not hTarget:IsNull() and hTarget then
	        local particle = ParticleManager:CreateParticle ("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	        ParticleManager:SetParticleControlEnt (particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin (), false)
	        ParticleManager:ReleaseParticleIndex(particle)

	        local particle = ParticleManager:CreateParticle ("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	        ParticleManager:SetParticleControlEnt (particle, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin (), false)
	        ParticleManager:SetParticleControlEnt (particle, 1, next_target, PATTACH_POINT_FOLLOW, "attach_attack1", next_target:GetAbsOrigin (), false)
	        ParticleManager:ReleaseParticleIndex(particle)
	    end
	end

	return true
end

function batman_betarang:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
