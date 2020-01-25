zeus_thundergods_vengeance = class({})
LinkLuaModifier( "modifier_zeus_thundergods_vengeance_thinker", "abilities/zeus_thundergods_vengeance.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_zeus_thundergods_vengeance", "abilities/zeus_thundergods_vengeance.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

function zeus_thundergods_vengeance:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function zeus_thundergods_vengeance:OnAbilityPhaseStart()
    if IsServer() then
        if self:GetCaster():HasModifier("modifier_zuus_immortal") then
            EmitSoundOn("Hero_Zuus.GodsWrath.PreCast.Arcana", self:GetCaster())
            local particle_start = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
            ParticleManager:SetParticleControl(particle_start, 0, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_start, 1, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_start, 2, self:GetCaster():GetAbsOrigin())
        else
            local particle_start = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_WORLDORIGIN, target)
            ParticleManager:SetParticleControl(particle_start, 0, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_start, 1, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_start, 2, self:GetCaster():GetAbsOrigin())
            EmitSoundOn("Hero_Zuus.GodsWrath.PreCast", self:GetCaster())
        end
        self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
    end
    return true
end

function zeus_thundergods_vengeance:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_zuus_immortal") then
        return "custom/lina_laguna_blade"
    end
    return "custom/zeus_thundergods_wraith"
end


function zeus_thundergods_vengeance:OnSpellStart()
    if IsServer() then
        if self:GetCaster():HasModifier("modifier_zuus_immortal") then
            EmitSoundOn("Hero_Zuus.Cloud.Cast", self:GetCaster())
            EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetCaster())
            EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", self:GetCaster())
        else
            EmitSoundOn("Hero_Zuus.GodsWrath", self:GetCaster())
        end

        CreateModifierThinker(caster, self, "modifier_zeus_thundergods_vengeance_thinker", {duration = self:GetSpecialValueFor("duration")}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

        --[[local cooldown = self:GetCooldown(self:GetLevel() - 1)
        local abilityManaCost = self:GetManaCost(self:GetLevel() - 1 )
        local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 99999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for i = 1, #targets do
            local target = targets[i]

            EmitSoundOn("Hero_Zuus.GodsWrath.Target", target)
            if not target:HasModifier("modifier_thundergods_wrath_vision") then
                target:AddNewModifier(self:GetCaster(), self, "modifier_thundergods_wrath_stun", {duration = 2})
            end

            AddFOWViewer(self:GetCaster():GetTeam(), target:GetAbsOrigin(), 250, 1.5, false)
            target:AddNewModifier(self:GetCaster(), self, "modifier_truesight", {duration = 3.5})
            GridNav:DestroyTreesAroundPoint( target:GetAbsOrigin(), 250, false)

            self.damage = self:GetSpecialValueFor( "damage" )
            self.damage_pers = self:GetSpecialValueFor( "damage_pers" )/100

            if self:GetCaster():HasScepter() then
                self.damage_pers = self:GetSpecialValueFor( "damage_pers_scepter" )/100
            end

            ApplyDamage ( {victim = target,attacker = self:GetCaster(),damage = target:GetMaxHealth() * self.damage_pers,damage_type = self:GetAbilityDamageType(),ability = self, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  + DOTA_DAMAGE_FLAG_HPLOSS })
            ApplyDamage ( {victim = target,attacker = self:GetCaster(),damage = self:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL,ability = self})

            if self:GetCaster():HasModifier("modifier_zuus_immortal") then
                local particle = ParticleManager:CreateParticle("particles/hero_zuus/zeus_immortal_thundergod.vpcf", PATTACH_WORLDORIGIN, target)
                ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
                ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
                ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
                EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", target)
                EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", target)
            else
                local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, target)
                ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
                ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000 ))
                ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
            end
        end]]
    end
end

modifier_zeus_thundergods_vengeance_thinker = class ({})

function modifier_zeus_thundergods_vengeance_thinker:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end

function modifier_zeus_thundergods_vengeance_thinker:IsAura()
    return true
end

function modifier_zeus_thundergods_vengeance_thinker:GetAuraRadius()
    return 9999999
end

function modifier_zeus_thundergods_vengeance_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_zeus_thundergods_vengeance_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_zeus_thundergods_vengeance_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS
end

function modifier_zeus_thundergods_vengeance_thinker:GetModifierAura()
    return "modifier_zeus_thundergods_vengeance"
end

modifier_zeus_thundergods_vengeance = class ( {})

function modifier_zeus_thundergods_vengeance:IsDebuff ()
    return true
end

function modifier_zeus_thundergods_vengeance:IsPurgable()
    return false
end

function modifier_zeus_thundergods_vengeance:GetEffectName()
    return "particles/generic_gameplay/screen_stun_indicator.vpcf"
end

function modifier_zeus_thundergods_vengeance:GetEffectAttachType()
    return PATTACH_EYES_FOLLOW
end

function modifier_zeus_thundergods_vengeance:OnCreated (event)
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_zeus_thundergods_vengeance:OnIntervalThink()
    if IsServer() then
        if RollPercentage(self:GetAbility():GetSpecialValueFor("damage_chance")) and not self:GetParent():IsMagicImmune() then
            EmitSoundOn("Hero_Zuus.Cloud.Cast", self:GetParent())
            EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetParent())
            EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", self:GetParent())

            EmitSoundOn("Hero_Zuus.GodsWrath.Target", self:GetParent())

            AddFOWViewer(self:GetAbility():GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 250, 4, false)
            self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_truesight", {duration = 3.5})
            GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), 250, false)

            ApplyDamage ( {victim = self:GetParent(),
                           attacker = self:GetAbility():GetCaster(),
                           damage = self:GetAbility():GetAbilityDamage(),
                           damage_type = self:GetAbility():GetAbilityDamageType(),
                           ability = self:GetAbility()
            })

            if self:GetAbility():GetCaster():HasModifier("modifier_zuus_immortal") then
                local particle = ParticleManager:CreateParticle("particles/hero_zuus/zeus_immortal_thundergod.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
                ParticleManager:SetParticleControl(particle, 0, Vector(self:GetParent():GetAbsOrigin().x,self:GetParent():GetAbsOrigin().y,3000 ))
                ParticleManager:SetParticleControl(particle, 1, Vector(self:GetParent():GetAbsOrigin().x,self:GetParent():GetAbsOrigin().y,self:GetParent():GetAbsOrigin().z + self:GetParent():GetBoundingMaxs().z ))
                ParticleManager:SetParticleControl(particle, 2, Vector(self:GetParent():GetAbsOrigin().x,self:GetParent():GetAbsOrigin().y,self:GetParent():GetAbsOrigin().z + self:GetParent():GetBoundingMaxs().z ))

                EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetParent())
                EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", self:GetParent())
            else
                local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
                ParticleManager:SetParticleControl(particle, 0, Vector(self:GetParent():GetAbsOrigin().x,self:GetParent():GetAbsOrigin().y,self:GetParent():GetAbsOrigin().z + self:GetParent():GetBoundingMaxs().z ))
                ParticleManager:SetParticleControl(particle, 1, Vector(self:GetParent():GetAbsOrigin().x,self:GetParent():GetAbsOrigin().y,3000 ))
                ParticleManager:SetParticleControl(particle, 2, Vector(self:GetParent():GetAbsOrigin().x,self:GetParent():GetAbsOrigin().y,self:GetParent():GetAbsOrigin().z + self:GetParent():GetBoundingMaxs().z ))
            end
        end
    end
end


function modifier_zeus_thundergods_vengeance:DeclareFunctions ()
    return { MODIFIER_PROPERTY_MISS_PERCENTAGE }
end

function modifier_zeus_thundergods_vengeance:GetModifierMiss_Percentage()
    return self:GetAbility():GetSpecialValueFor ("miss")
end

function modifier_zeus_thundergods_vengeance:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end

function modifier_zeus_thundergods_vengeance:GetEffectAttachType ()
    return PATTACH_POINT_FOLLOW
end
