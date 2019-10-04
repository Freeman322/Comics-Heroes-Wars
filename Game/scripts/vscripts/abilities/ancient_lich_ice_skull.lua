ancient_lich_ice_skull = class({})

function ancient_lich_ice_skull:OnSpellStart()
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	local bolt_speed = self:GetSpecialValueFor( "bolt_speed" )

	local info = {
			EffectName = "particles/econ/items/lich/lich_ti8_immortal_arms/lich_ti8_chain_frost.vpcf",
			Ability = self,
			iMoveSpeed = 1000,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			bDodgeable = true,
			bProvidesVision = false,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Lich.ChainFrost", self:GetCaster() )
end

--------------------------------------------------------------------------------

function ancient_lich_ice_skull:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
		EmitSoundOn( "Hero_Lich.ChainFrostImpact.Hero", hTarget )
		local duration = self:GetSpecialValueFor( "stun_duration" )
		local damage = self:GetSpecialValueFor( "damage" ) 

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
		}

		ApplyDamage( damage )
    hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
    hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_skadi_slow",  { duration = self:GetSpecialValueFor("slow_duration") } )
    return true
    end
end

function ancient_lich_ice_skull:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 