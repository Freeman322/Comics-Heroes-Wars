god_emperor_supersonic_strike = class({})

--------------------------------------------------------------------------------

function god_emperor_supersonic_strike:OnSpellStart()
	local info = {
			EffectName = "particles/neutral_fx/satyr_trickster_projectile.vpcf",
			Ability = self,
			iMoveSpeed = 1600,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Invoker.Tornado.Cast", self:GetCaster() )
end

--------------------------------------------------------------------------------

function god_emperor_supersonic_strike:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_Oracle.FalsePromise.Damaged", hTarget )
		
		local iDamage = self:GetAbilityDamage()

		if self:GetCaster():HasTalent("special_bonus_unique_god_emperor") then
	        iDamage = self:GetCaster():FindTalentValue("special_bonus_unique_god_emperor") + self:GetAbilityDamage()
		end

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = iDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("magic_missile_stun") } )

		ApplyDamage( damage )
	end

	return true
end
function god_emperor_supersonic_strike:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

