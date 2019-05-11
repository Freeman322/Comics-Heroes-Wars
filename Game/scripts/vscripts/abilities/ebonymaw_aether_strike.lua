if ebonymaw_aether_strike == nil then ebonymaw_aether_strike = class({}) end

LinkLuaModifier( "modifier_ebonymaw_aether_strike", "abilities/ebonymaw_aether_strike.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ebonymaw_aether_strike:OnSpellStart()
	if IsServer() then 
		local info = {
				EffectName = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_stifling_dagger.vpcf",
				Ability = self,
				iMoveSpeed = self:GetSpecialValueFor("dagger_speed"),
				Source = self:GetCaster(),
				Target = self:GetCursorTarget(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
			}

		ProjectileManager:CreateTrackingProjectile( info )

		EmitSoundOn( "Hero_VengefulSpirit.MagicMissile.TI8", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function ebonymaw_aether_strike:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact.TI8", hTarget )
		EmitSoundOn( "Hero_VengefulSpirit.Missile.Cast.TI8.Layer", hTarget )

		local fDamage = self:GetSpecialValueFor("base_damage") + (hTarget:GetMaxHealth() * (self:GetSpecialValueFor("damage") / 100))
		if self:GetCaster():HasTalent("special_bonus_unique_ebonymaw_2") then 
	        fDamage = fDamage + (hTarget:GetMaxHealth() * (self:GetCaster():FindTalentValue("special_bonus_unique_ebonymaw_2") / 100))
	    end
	    
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = fDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}
		
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_silence", { duration = self:GetSpecialValueFor( "silence_duration" ) } )

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_stifling_dagger_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		ApplyDamage( damage )
	end

	return true
end