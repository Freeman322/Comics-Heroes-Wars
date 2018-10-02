waden_clock_freeze = class({})
LinkLuaModifier( "modifier_waden_clock_freeze", "abilities/waden_clock_freeze.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function waden_clock_freeze:OnSpellStart()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            local info = {
                EffectName = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf",
                Ability = self,
                iMoveSpeed = 1900,
                Source = self:GetCaster(),
                Target = hTarget,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

            ProjectileManager:CreateTrackingProjectile( info )
            
            EmitSoundOn( "Hero_FacelessVoid.TimeDilation.Cast.ti7", self:GetCaster() )
        end
    end
end

--------------------------------------------------------------------------------

function waden_clock_freeze:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
        
        EmitSoundOn( "Hero_FacelessVoid.TimeLockImpact", hTarget )
        
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}

        ApplyDamage( damage )
        
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_waden_clock_freeze", { duration = self:GetSpecialValueFor("duration") } )
	end

	return true
end

modifier_waden_clock_freeze = class({})

--------------------------------------------------------------------------------

function modifier_waden_clock_freeze:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_waden_clock_freeze:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_waden_clock_freeze:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_waden_clock_freeze:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_waden_clock_freeze:CheckState()
	local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true
	}

	return state
end