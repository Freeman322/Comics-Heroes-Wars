nightking_frostbite = class({})
LinkLuaModifier ("nightking_nightking_frostbite", "abilities/nightking_frostbite.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function nightking_frostbite:OnSpellStart()
    if IsServer() then 
        local info = {
			EffectName = "particles/hero_nightking/nightking_frostbite_debuff.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "speed" ),
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	    ProjectileManager:CreateTrackingProjectile( info )
	    EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
    end

end

--------------------------------------------------------------------------------

function nightking_frostbite:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
        EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )
        
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

        ApplyDamage( damage )
        
		hTarget:AddNewModifier( self:GetCaster(), self, "nightking_nightking_frostbite", { duration = self:GetSpecialValueFor("stun") } )
	end

	return true
end


nightking_nightking_frostbite = class({})

function nightking_nightking_frostbite:IsPurgable()
	return false
end

function nightking_nightking_frostbite:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function nightking_nightking_frostbite:StatusEffectPriority()
	return 1000
end

function nightking_nightking_frostbite:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function nightking_nightking_frostbite:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function nightking_nightking_frostbite:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function nightking_nightking_frostbite:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function nightking_nightking_frostbite:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function nightking_nightking_frostbite:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function nightking_nightking_frostbite:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end