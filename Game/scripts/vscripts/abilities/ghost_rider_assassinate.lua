LinkLuaModifier( "modifier_ghost_rider_assassinate", "abilities/ghost_rider_assassinate.lua", LUA_MODIFIER_MOTION_NONE )
ghost_rider_assassinate = class({})

function ghost_rider_assassinate:OnSpellStart()
    if IsServer() then 
        local info = {
			EffectName = "particles/econ/items/sniper/sniper_charlie/sniper_assassinate_charlie.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "projectile_speed" ),
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

        ProjectileManager:CreateTrackingProjectile( info )
       
        EmitSoundOn( "Ability.Assassinate", self:GetCaster() )
    end
end

--------------------------------------------------------------------------------

function ghost_rider_assassinate:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
        EmitSoundOn( "Hero_Sniper.AssassinateDamage", hTarget )
        
        local damage = self:GetAbilityDamage()
        local dmg_mod = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ghost_rider_assassinate", nil )

        self:GetCaster():PerformAttack(hTarget, true, false, true, true, false, false, true)
        
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 0.05 } )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}

        ApplyDamage( damage )
        
        dmg_mod:Destroy()
	end

	return true
end

if modifier_ghost_rider_assassinate == nil then modifier_ghost_rider_assassinate = class({}) end

function modifier_ghost_rider_assassinate:IsHidden ()
    return true
end

function modifier_ghost_rider_assassinate:RemoveOnDeath ()
    return true
end

function modifier_ghost_rider_assassinate:IsPurgable()
    return false
end

function modifier_ghost_rider_assassinate:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }

    return funcs
end

function modifier_ghost_rider_assassinate:GetModifierPreAttack_CriticalStrike (params)
    return self:GetAbility():GetSpecialValueFor ("crit_bonus")
end

function modifier_ghost_rider_assassinate:CheckState()
	local state = {
	    [MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end
