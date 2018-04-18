LinkLuaModifier( "modifier_death_death_mark", "abilities/death_death_mark.lua", LUA_MODIFIER_MOTION_NONE )
death_death_mark = class({})
--------------------------------------------------------------------------------

function death_death_mark:OnSpellStart()
	local info = {
			EffectName = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "lance_speed" ),
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_PhantomLancer.SpiritLance.Throw", self:GetCaster() )
end

--------------------------------------------------------------------------------

function death_death_mark:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_PhantomLancer.SpiritLance.Impact", hTarget )
		local duration = self:GetSpecialValueFor( "duration" )
		local damage = self:GetAbilityDamage()

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_death_death_mark", { duration = duration } )
	end

	return true
end

modifier_death_death_mark = class({})

function modifier_death_death_mark:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_death_death_mark:IsPurgable()
	return false
end

function modifier_death_death_mark:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
            local attacker = params.attacker
            local particle_lifesteal = "particles/items3_fx/octarine_core_lifesteal.vpcf"
            local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, attacker)
			ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())
			local restore = params.damage*(self:GetAbility():GetSpecialValueFor("bonus_vampirism")/100)
			attacker:Heal(restore, attacker)
        end
	end
end


function modifier_death_death_mark:GetModifierIncomingDamage_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("bonus_damage")*(-1)
end

function modifier_death_death_mark:CheckState()
	local state = {
	[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end

function death_death_mark:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

