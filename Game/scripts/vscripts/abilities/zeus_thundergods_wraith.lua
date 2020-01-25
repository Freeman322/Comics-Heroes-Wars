zeus_thundergods_wraith = class({})
LinkLuaModifier("modifier_thundergods_wrath_stun", "abilities/zeus_thundergods_wraith.lua", LUA_MODIFIER_MOTION_NONE)
function zeus_thundergods_wraith:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 90
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function zeus_thundergods_wraith:OnAbilityPhaseStart()
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

function zeus_thundergods_wraith:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_zuus_immortal") then
        return "custom/lina_laguna_blade"
    end
    return "custom/zeus_thundergods_wraith"
end


function zeus_thundergods_wraith:OnSpellStart()
    if IsServer() then
        if self:GetCaster():HasModifier("modifier_zuus_immortal") then
            EmitSoundOn("Hero_Zuus.Cloud.Cast", self:GetCaster())
            EmitSoundOn("Hero_Zeus.BlinkDagger.Arcana", self:GetCaster())
            EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", self:GetCaster())
        else
            EmitSoundOn("Hero_Zuus.GodsWrath", self:GetCaster())
        end
        local cooldown = self:GetCooldown(self:GetLevel() - 1)
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

            ApplyDamage ( {victim = target,attacker = self:GetCaster(),damage = target:GetMaxHealth() * self.damage_pers,damage_type = self:GetAbilityDamageType(),ability = self, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION  + DOTA_DAMAGE_FLAG_HPLOSS })
            ApplyDamage ( {victim = target,attacker = self:GetCaster(),damage = self:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL,ability = self})
        end
    end
end

if modifier_thundergods_wrath_stun == nil then modifier_thundergods_wrath_stun = class({}) end

function modifier_thundergods_wrath_stun:IsDebuff()
    return true
end

function modifier_thundergods_wrath_stun:IsStunDebuff()
    return true
end

function modifier_thundergods_wrath_stun:OnCreated(ht)
    if IsServer() then
        if self:GetCaster():HasModifier("modifier_zuus_immortal") then
            local eyes = ParticleManager:CreateParticleForPlayer("particles/econ/items/zeus/arcana_chariot/zeus_tgw_screen_damage.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
            self:AddParticle(eyes, false, false, -1, false, false)
            local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_static_field.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
            ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
            self:AddParticle(particle, false, false, -1, false, false)
        end
    end
end

function modifier_thundergods_wrath_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_thundergods_wrath_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_thundergods_wrath_stun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

function modifier_thundergods_wrath_stun:GetOverrideAnimation( params )
    return ACT_DOTA_DISABLED
end

function modifier_thundergods_wrath_stun:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

function zeus_thundergods_wraith:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

