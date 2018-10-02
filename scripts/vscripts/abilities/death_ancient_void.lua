LinkLuaModifier ("modifier_death_ancient_void_debuff", "abilities/death_ancient_void.lua", LUA_MODIFIER_MOTION_NONE)
death_ancient_void = class ( {})

function death_ancient_void:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            local duration = self:GetSpecialValueFor ("duration")
            hTarget:AddNewModifier (self:GetCaster (), self, "modifier_death_ancient_void_debuff", { duration = duration } )
            local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_reflection_cast.vpcf"
            local particle = ParticleManager:CreateParticle (particleName, PATTACH_POINT_FOLLOW, self:GetCaster ())
            ParticleManager:SetParticleControl (particle, 3, Vector (1, 0, 0))
            ParticleManager:SetParticleControlEnt (particle, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin (), true)
            ParticleManager:SetParticleControlEnt (particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin (), true)
            EmitSoundOn ("Hero_Bane.Nightmare", self:GetCaster () )

            hTarget:AddNewModifier (self:GetCaster (), self, "modifier_death_touch_of_death_debuff", nil)
            local debuff_scepter = hTarget:FindModifierByName ("modifier_death_touch_of_death_debuff")
            local debuff_scepter_count = debuff_scepter:GetStackCount ()
            local bonus_stacks = self:GetSpecialValueFor ("bonus_stacks")
            debuff_scepter:SetStackCount (debuff_scepter_count + bonus_stacks)

        end
    end
end


modifier_death_ancient_void_debuff = class ( {})


function modifier_death_ancient_void_debuff:GetEffectName ()
    return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
end

function modifier_death_ancient_void_debuff:GetEffectAttachType ()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_death_ancient_void_debuff:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_death_ancient_void_debuff:GetOverrideAnimation (params)
    return ACT_DOTA_FLAIL
end

function modifier_death_ancient_void_debuff:GetOverrideAnimationRate (params)
    return 0.6
end

function modifier_death_ancient_void_debuff:OnCreated ()
    if IsServer () then
        local parent = self:GetParent ()
        local soundName = "Hero_Bane.Nightmare.Loop"
        StartSoundEvent (soundName, parent)
        self:StartIntervalThink (1)
    end
end

function modifier_death_ancient_void_debuff:OnIntervalThink ()
    if IsServer () then
        local target = self:GetParent ()
        local hAbility = self:GetAbility ()
        local damage_pers = hAbility:GetSpecialValueFor ("damage")
        local damage = (damage_pers / 100) * target:GetMaxHealth ()
        ApplyDamage ( { attacker = hAbility:GetCaster (), victim = target, ability = hAbility, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function modifier_death_ancient_void_debuff:OnDestroy ()
    if IsServer () then
        StopSoundEvent ("Hero_Bane.Nightmare.Loop", self:GetParent ())
    end
end

function modifier_death_ancient_void_debuff:CheckState ()
    return {[MODIFIER_STATE_NIGHTMARED] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function death_ancient_void:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

