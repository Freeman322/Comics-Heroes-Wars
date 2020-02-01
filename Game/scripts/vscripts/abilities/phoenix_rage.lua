phoenix_rage = class ( {})
LinkLuaModifier ("modifier_phoenix_rage", "abilities/phoenix_rage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_phoenix_rage_caster", "abilities/phoenix_rage.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function phoenix_rage:GetConceptRecipientType ()
    return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function phoenix_rage:SpeakTrigger ()
    return DOTA_ABILITY_SPEAK_CAST
end

function phoenix_rage:GetCooldown (nLevel)
    if self:GetCaster():HasScepter () then
        return 80
    end

    return self.BaseClass.GetCooldown (self, nLevel)
end
--------------------------------------------------------------------------------

function phoenix_rage:GetChannelTime ()
    if self:GetCaster():HasScepter() then
      return self:GetSpecialValueFor ("duration_scepter")
    end

    return self:GetSpecialValueFor ("duration")
end

--------------------------------------------------------------------------------

function phoenix_rage:OnAbilityPhaseStart ()
    if IsServer () then
        self.hVictim = self:GetCursorTarget ()
    end

    return true
end

--------------------------------------------------------------------------------

function phoenix_rage:OnSpellStart ()
    if self.hVictim == nil then
        return
    end
    EmitSoundOn ("Hero_Phoenix.SunRay.Cast", self.hVictim)
    if self.hVictim:TriggerSpellAbsorb (self) then
        self.hVictim = nil
        self:GetCaster ():Interrupt ()
    else
        self.hVictim:AddNewModifier (self:GetCaster (), self, "modifier_phoenix_rage", { duration = self:GetChannelTime () } )
        self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_phoenix_rage_caster", { duration = self:GetChannelTime () } )
        self.hVictim:Interrupt ()
    end
end


--------------------------------------------------------------------------------

function phoenix_rage:OnChannelFinish (bInterrupted)
    if self.hVictim ~= nil then
        self.hVictim:RemoveModifierByName ("modifier_phoenix_rage")
    end
    if self:GetCaster():HasModifier("modifier_phoenix_rage_caster") then
        self:GetCaster ():RemoveModifierByName ("modifier_phoenix_rage_caster")
    end
end

modifier_phoenix_rage_caster = class ( {})

function modifier_phoenix_rage_caster:IsHidden ()
    return true
end

function modifier_phoenix_rage_caster:IsPurgable ()
    return false
end

--------------------------------------------------------------------------------

function modifier_phoenix_rage_caster:GetStatusEffectName ()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf"
end

--------------------------------------------------------------------------------

function modifier_phoenix_rage_caster:StatusEffectPriority ()
    return 1000
end

function modifier_phoenix_rage_caster:GetHeroEffectName ()
    return "particles/frostivus_herofx/juggernaut_fs_omnislash_slashers.vpcf"
end


function modifier_phoenix_rage_caster:HeroEffectPriority ()
    return 100
end


function modifier_phoenix_rage_caster:CheckState ()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end

modifier_phoenix_rage = class ( {})


function modifier_phoenix_rage:IsHidden ()
    return false
end

function modifier_phoenix_rage:IsPurgable ()
    return false
end

function modifier_phoenix_rage:GetStatusEffectName()
    return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

--------------------------------------------------------------------------------

function modifier_phoenix_rage:StatusEffectPriority()
    return 1000
end

--------------------------------------------------------------------------------

function modifier_phoenix_rage:GetEffectName()
    return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_phoenix_rage:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_phoenix_rage:OnCreated (kv)
    if IsServer () then
        local hTarget = self:GetParent ()
        self:StartIntervalThink (0.1)
        EmitSoundOn ("Hero_Phoenix.SunRay.Beam", hTarget)
        StartSoundEvent ("Hero_Phoenix.SunRay.Loop", hTarget)
        local nFXIndex1 = ParticleManager:CreateParticle ("particles/jinn_gray/rage_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
        ParticleManager:SetParticleControlEnt( nFXIndex1, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex1, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
        ParticleManager:SetParticleControl (nFXIndex1, 2, hTarget:GetAbsOrigin () )
        ParticleManager:SetParticleControl (nFXIndex1, 3, hTarget:GetAbsOrigin () )
        ParticleManager:SetParticleControl (nFXIndex1, 4, Vector(1, 0, 0))
        ParticleManager:SetParticleControl (nFXIndex1, 9, hTarget:GetAbsOrigin () )
        self:AddParticle( nFXIndex1, false, false, -1, false, true )
    end
end

function modifier_phoenix_rage:OnIntervalThink ()
    if IsServer () then
        local target = self:GetParent ()
        local caster = self:GetAbility ():GetCaster ()
        local hp_cost = self:GetAbility():GetSpecialValueFor("hp_cost_perc_per_second")
        local damage = (caster:GetMaxHealth()*hp_cost)/10
       
        ApplyDamage({attacker = caster, victim = target, ability = self:GetAbility(), damage = damage , damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS})

        local side_units = FindUnitsInLine(caster:GetTeam (), caster:GetAbsOrigin(), target:GetAbsOrigin(), nil, 120, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
        for i=1, #side_units do
            local targets = side_units[i]
            local targets_damage = (caster:GetMaxHealth()*hp_cost)/100
            if targets == target then
                ApplyDamage({attacker = caster, victim = targets, ability = self:GetAbility(), damage = 1 , damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS})
            else
                ApplyDamage({attacker = caster, victim = targets, ability = self:GetAbility(), damage = damage , damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS})
            end
        end
    end
end
--------------------------------------------------------------------------------
function modifier_phoenix_rage:OnDestroy (kv)
    if IsServer () then
        local target = self:GetParent ()
        local caster = self:GetAbility ():GetCaster ()
        StopSoundEvent ("Hero_Phoenix.SunRay.Loop", target)
        EmitSoundOn ("Hero_Phoenix.SunRay.Stop", target)
    end
end

function modifier_phoenix_rage:CheckState ()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

function phoenix_rage:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

