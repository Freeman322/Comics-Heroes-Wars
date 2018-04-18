if diablo_fire_blast == nil then diablo_fire_blast = class({}) end

function diablo_fire_blast:GetAbilityTexture()
	return "diablo_fire_blast"
end

function diablo_fire_blast:GetTexture()
	return "diablo_fire_blast"
end

function diablo_fire_blast:OnSpellStart()
	local clients = { [158527594] = true,[158527594] = true, [87670156] = true, [104473272] = true }
    if clients[PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID())] then
    	self.effect = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast.vpcf"
    else
    	self.effect = "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf"
    end
	local info = {
			EffectName = self.effect,
			Ability = self,
			iMoveSpeed = 1000,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_SkeletonKing.Hellfire_Blast", self:GetCaster() )
end

--------------------------------------------------------------------------------

function diablo_fire_blast:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_ChaosKnight.ChaosBolt.Impact", hTarget )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("blast_stun_duration") } )
	end

	return true
end
function diablo_fire_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

