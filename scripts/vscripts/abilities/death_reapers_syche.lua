LinkLuaModifier ("modifier_death_reapers_syche", "abilities/death_reapers_syche.lua", LUA_MODIFIER_MOTION_NONE)

death_reapers_syche = class ( {})

function death_reapers_syche:GetCooldown (nLevel)
    if self:GetCaster ():HasScepter () then
        return 40
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end

function death_reapers_syche:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local delay = 1.5
            local caster = self:GetCaster ()
            local ability = self
            self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_death_reapers_syche", { duration = delay } )
            EmitSoundOn ("Hero_Terrorblade.Sunder.Cast", hTarget)
            EmitSoundOn ("Hero_Terrorblade.Sunder.Target", hTarget)

            local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
            local particle = ParticleManager:CreateParticle (particleName, PATTACH_POINT_FOLLOW, hTarget)

            ParticleManager:SetParticleControlEnt (particle, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin (), true)
            ParticleManager:SetParticleControlEnt (particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin (), true)

            -- Show the particle target-> caster
            local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
            local particle = ParticleManager:CreateParticle (particleName, PATTACH_POINT_FOLLOW, caster)

            ParticleManager:SetParticleControlEnt (particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin (), true)
            ParticleManager:SetParticleControlEnt (particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin (), true)

            local primary_damage = self:GetSpecialValueFor ("damage")
            local damage_per_stack_scepter = self:GetSpecialValueFor ("damage_per_stack_scepter")
            local damage_per_stack = self:GetSpecialValueFor ("damage_per_stack")
            if hTarget:HasModifier("modifier_death_touch_of_death_debuff") then
                debuff = hTarget:FindModifierByName ("modifier_death_touch_of_death_debuff")
                debuff_counts = debuff:GetStackCount ()
            else
                debuff_counts = 1
            end
            local damage = primary_damage + (damage_per_stack * debuff_counts)
            if caster:HasScepter () then
                hTarget:AddNewModifier (caster, ability, "modifier_death_touch_of_death_debuff", nil)
                debuff_scepter = hTarget:FindModifierByName ("modifier_death_touch_of_death_debuff")
                debuff_scepter_count = debuff_scepter:GetStackCount ()
                debuff_scepter:SetStackCount (debuff_scepter_count + 25)
                damage = primary_damage + (damage_per_stack_scepter * debuff_counts)
            end
            caster:SetHealth(caster:GetHealth() + damage)
            ApplyDamage ( {
                victim = hTarget,
                attacker = caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = ability,
                damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS,
            })
            if self:GetCaster():HasModifier("modifier_death_dress") then
              local vPos = self:GetCursorTarget():GetOrigin()
              local vDirection = vPos - self:GetCaster():GetOrigin()
            	vDirection.z = 0.0
            	vDirection = vDirection:Normalized()
              local info = {
            		EffectName = "particles/hero_death/death_immortal_sunder.vpcf",
            		Ability = self,
            		vSpawnOrigin = self:GetCaster():GetOrigin(),
            		fStartRadius = 1,
            		fEndRadius = 1,
            		vVelocity = vDirection * 1000,
            		fDistance = 400,
            		Source = self:GetCaster(),
            		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE
            	}
            	ProjectileManager:CreateLinearProjectile( info )
            	EmitSoundOn( "Hero_DeathProphet.CarrionSwarm.Mortis", self:GetCaster() )
              EmitSoundOn( "Hero_DeathProphet.CarrionSwarm.Damage.Mortis", hTarget )
            end
        end
    end
end

modifier_death_reapers_syche = class ( {})

function modifier_death_reapers_syche:IsHidden()
    return true
end

function modifier_death_reapers_syche:GetStatusEffectName()
    return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf"
end



function modifier_death_reapers_syche:StatusEffectPriority()
	return 1000
end


function modifier_death_reapers_syche:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
end

--------------------------------------------------------------------------------

function modifier_death_reapers_syche:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function death_reapers_syche:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

