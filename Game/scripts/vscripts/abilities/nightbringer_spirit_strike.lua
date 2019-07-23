nightbringer_spirit_strike = class({})
LinkLuaModifier( "modifier_nightbringer_spirit_strike", "abilities/nightbringer_spirit_strike.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function nightbringer_spirit_strike:OnSpellStart()
	local info = {
			EffectName = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf",
			Ability = self,
			iMoveSpeed = 1000,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Bane.Enfeeble.Cast", self:GetCaster() )
end

--------------------------------------------------------------------------------

function nightbringer_spirit_strike:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_Bane.Nightmare.End", hTarget )
		local damage_tooltip = self:GetSpecialValueFor( "damage_tooltip" )
  	local slow_durtion_tooltip = self:GetSpecialValueFor( "slow_durtion_tooltip" )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage_tooltip,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_nightbringer_spirit_strike", { duration = slow_durtion_tooltip } )

		ApplyDamage( damage )
	end

	return true
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_nightbringer_spirit_strike = class({})
--------------------------------------------------------------------------------

function modifier_nightbringer_spirit_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_nightbringer_spirit_strike:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor( "movespeed" )
end

function nightbringer_spirit_strike:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

