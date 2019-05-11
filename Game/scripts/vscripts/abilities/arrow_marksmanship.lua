arrow_marksmanship = class({})

function arrow_marksmanship:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function arrow_marksmanship:OnSpellStart()
    if IsServer() then 
        local info = {
                EffectName = "particles/arrow_arrow.vpcf",
                Ability = self,
                iMoveSpeed = 1200,
                Source = self:GetCaster(),
                Target = self:GetCursorTarget(),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

        ProjectileManager:CreateTrackingProjectile( info )
        EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
    end
end

function arrow_marksmanship:OnProjectileHit( hTarget, vLocation )
    if IsServer() then 
        if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
            local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for _, unit in pairs(targets) do
                EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )

                local damage = {
                    victim = unit,
                    attacker = self:GetCaster(),
                    damage = self:GetAbilityDamage(),
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self
                }
    
                ApplyDamage( damage )

                AddNewModifier_pcall( unit, self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") } )

                if not unit:IsNull() and unit then
                    local pop_pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_cluckles/courier_cluckles_ambient_rocket_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
                    ParticleManager:SetParticleControl(pop_pfx, 0, unit:GetAbsOrigin())
                    ParticleManager:SetParticleControl(pop_pfx, 3, unit:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(pop_pfx)
                end
            end
        end
    end
	return true
end