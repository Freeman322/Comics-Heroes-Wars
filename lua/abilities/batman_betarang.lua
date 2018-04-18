if batman_betarang == nil then batman_betarang = class({}) end

function batman_betarang:OnSpellStart()
	local info = {
			EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
			Ability = self,
			iMoveSpeed = 500,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_BountyHunter.Shuriken", self:GetCaster() )
	self.max_bounces = self:GetSpecialValueFor("max_bounce")
end

--------------------------------------------------------------------------------

function batman_betarang:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_BountyHunter.Shuriken.Impact", hTarget )
		local dmg = self:GetAbilityDamage()
		if self:GetCaster():HasScepter() then
			dmg = dmg + self:GetCaster():GetStrength()
		end
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = dmg,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") } )
		if self.max_bounces == 0 then
			return nil
		end
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #units > 0 then
			for _,target in pairs(units) do
				if target ~= nil and ( not target:IsMagicImmune() ) and ( not target:IsInvulnerable() ) and target ~= hTarget then
					local info = {
						EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
						Ability = self,
						iMoveSpeed = 500,
						Source = hTarget,
						Target = target,
						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
					}
					self.max_bounces = self.max_bounces - 1
					ProjectileManager:CreateTrackingProjectile( info )
					break
				end
			end
		end
	end

	return true
end

function batman_betarang:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

