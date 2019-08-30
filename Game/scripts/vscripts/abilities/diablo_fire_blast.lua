if diablo_fire_blast == nil then diablo_fire_blast = class({}) end

function diablo_fire_blast:GetAbilityTexture()
	return "diablo_fire_blast"
end

function diablo_fire_blast:GetTexture()
	return "diablo_fire_blast"
end

function diablo_fire_blast:OnSpellStart()
	if IsServer() then 
		local effect = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf"
		local soundEffect = "Hero_SkeletonKing.Hellfire_Blast"

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "freeza") == true then 
			effect = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle_crimson.vpcf" 
			soundEffect = "Freeza.Cast3"
		end 

		local info = {
			EffectName = effect,
			Ability = self,
			iMoveSpeed = 1000,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

		ProjectileManager:CreateTrackingProjectile( info )

		EmitSoundOn( soundEffect, self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function diablo_fire_blast:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_ChaosKnight.ChaosBolt.Impact", hTarget )

		local duration = self:GetSpecialValueFor("blast_stun_duration")
		
		if self:GetCaster():HasTalent("special_bonus_unique_diablo_2") then
			duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_diablo_2") 
		end
		
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration} )
		
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return true
end
function diablo_fire_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

