enigma_missile = class({})
--------------------------------------------------------------------------------

function enigma_missile:OnSpellStart()
    if IsServer() then 
        local hTarget = self:GetCursorTarget()
        if hTarget ~= nil then
            local info = {
                EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
                Ability = self,
                iMoveSpeed = self:GetSpecialValueFor("magic_missile_speed"),
                Source = self:GetCaster(),
                Target = hTarget,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

            ProjectileManager:CreateTrackingProjectile( info )
            
            EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
        end
    end
end

--------------------------------------------------------------------------------

function enigma_missile:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
        
        EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )
        
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("magic_missile_stun") } )
        
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetAbilityDamage(),
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}

        ApplyDamage( damage )
	end

	return true
end
