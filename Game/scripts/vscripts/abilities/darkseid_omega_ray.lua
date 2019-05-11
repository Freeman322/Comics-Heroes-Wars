darkseid_omega_ray = class({})

function darkseid_omega_ray:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/darkseid_omega_ray_immortal"
	end
	return "custom/darkseid_omega_ray"
end


function darkseid_omega_ray:GetCooldown (nLevel)
    if self:GetCaster ():HasScepter () then
        return self:GetSpecialValueFor ("cooldown_scepter")
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end

function darkseid_omega_ray:OnSpellStart ()
    local projectile = "particles/items_fx/desolator_projectile.vpcf"
    if self:GetCaster():HasModifier("modifier_arcana") then
      projectile = "particles/darkseid/darkseid_glove_omega_sanction.vpcf"

      EmitSoundOn ("Hero_ObsidianDestroyer.AstralImprisonment.End", hCaster)
      EmitSoundOn ("Hero_ObsidianDestroyer.SanityEclipse.Cast", hTarget)
    end
    local info = {
        EffectName = projectile,
        Ability = self,
        iMoveSpeed = 1400,
        Source = self:GetCaster (),
        Target = self:GetCursorTarget (),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
        bDrawsOnMinimap = true,
        bDodgeable = false,
    }
    local hTarget = self:GetCursorTarget ()
    ProjectileManager:CreateTrackingProjectile (info)
    local hCaster = self:GetCaster()

    EmitSoundOn ("Hero_Omniknight.Purification.Wingfall", hCaster)
    EmitSoundOn ("Hero_Omniknight.Purification.Wingfall.Layer", hTarget)
end

--------------------------------------------------------------------------------

function darkseid_omega_ray:OnProjectileHit (hTarget, vLocation)
    if hTarget ~= nil and ( not hTarget:IsInvulnerable () ) and ( not hTarget:TriggerSpellAbsorb (self) ) then
        EmitSoundOn ("Hero_VengefulSpirit.MagicMissileImpact", hTarget)
        local stun = self:GetSpecialValueFor ("stun")
        local damage = self:GetSpecialValueFor ("damage")

        if self:GetCaster():HasScepter() then
            damage = (hTarget:GetMaxHealth () * (self:GetSpecialValueFor ("damage_scepter")/100) + self:GetSpecialValueFor ("damage"))
        end
        
        if self:GetCaster():HasModifier("modifier_arcana") then
            EmitSoundOn ("Hero_ObsidianDestroyer.SanityEclipse", hTarget)
            EmitSoundOn ("Hero_ObsidianDestroyer.SanityEclipse", hTarget)
    
            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/death/mk_arcana_spring_cast_outer_death_pnt.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetAbsOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 4, hTarget:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex( nFXIndex );
        end
        
        hTarget:AddNewModifier (self:GetCaster (), self, "modifier_stunned", { duration = stun} )

        local damage_table = {
            victim = hTarget,
            attacker = self:GetCaster (),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }

        ApplyDamage (damage_table)
    end
    return true
end
