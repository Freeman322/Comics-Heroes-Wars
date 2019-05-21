LinkLuaModifier( "enigma_midnight_pulse_new_thinker", "abilities/enigma_midnight_pulse_new.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "enigma_midnight_pulse_new_modifier", "abilities/enigma_midnight_pulse_new.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier("thanos_dying_star_modifier", "abilities/thanos_dying_star.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

enigma_midnight_pulse_new = class ( {})

function enigma_midnight_pulse_new:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local thinker = CreateModifierThinker(caster, self, "enigma_midnight_pulse_new_thinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
end

enigma_midnight_pulse_new_thinker = class ({})

function enigma_midnight_pulse_new_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()

        self.radius = ability:GetSpecialValueFor("radius")
        self:StartIntervalThink(1)

        local pfx = "particles/hero_infinity/enigma_void_pulse.vpcf"

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "enigma_bracers") == true then
          pfx = "particles/hero_infinity/enigma_void_pulse_bracers.vpcf"
          EmitSoundOn("Hero_ArcWarden.MagneticField", thinker)
        end


        local nFXIndex = ParticleManager:CreateParticle( pfx, PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target)
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 1))
        ParticleManager:SetParticleControl( nFXIndex, 2, target)
        ParticleManager:SetParticleControl( nFXIndex, 3, target)
        ParticleManager:SetParticleControl( nFXIndex, 5, target)
        ParticleManager:SetParticleControl( nFXIndex, 6, Vector(self.radius, self.radius, 1))
        ParticleManager:SetParticleControl( nFXIndex, 7, target)
        ParticleManager:SetParticleControl( nFXIndex, 8, target)
        ParticleManager:SetParticleControl( nFXIndex, 9, target)
        ParticleManager:SetParticleControl( nFXIndex, 20, target)
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        self.sound = "Hero_Enigma.Midnight_Pulse"
        StartSoundEvent( self.sound, thinker)

        AddFOWViewer( thinker:GetTeam(), target, 500, 5, false)
        GridNav:DestroyTreesAroundPoint(target, 600, false)
    end
end

function enigma_midnight_pulse_new_thinker:OnIntervalThink()
    local thinker = self:GetParent()
    local thinker_pos = thinker:GetAbsOrigin()
    local nearby_targets = FindUnitsInRadius(thinker:GetTeam(), thinker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

    for i, target in ipairs(nearby_targets) do
        local damage =  target:GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("damage_per_tick")/100)
        if self:GetCaster():HasTalent("special_bonus_unique_infinity") then
            target:ModifyHealth(target:GetHealth() - damage, self:GetAbility(), true, 0)
        else
            if not target:IsAncient() then
                ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE})
            end
        end
    end
end

function enigma_midnight_pulse_new_thinker:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end

function enigma_midnight_pulse_new_thinker:IsAura()
    return true
end

function enigma_midnight_pulse_new_thinker:GetAuraRadius()
    return self.radius
end

function enigma_midnight_pulse_new_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function enigma_midnight_pulse_new_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function enigma_midnight_pulse_new_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function enigma_midnight_pulse_new_thinker:GetModifierAura()
    return "thanos_dying_star_modifier"
end

enigma_midnight_pulse_new_modifier = class ( {})

function enigma_midnight_pulse_new_modifier:IsDebuff ()
    return true
end

function enigma_midnight_pulse_new_modifier:OnCreated (event)
    local ability = self:GetAbility ()
end

function enigma_midnight_pulse_new_modifier:DeclareFunctions ()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function enigma_midnight_pulse_new_modifier:GetModifierMoveSpeedBonus_Percentage()
    return -25
end

function enigma_midnight_pulse_new_modifier:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end

function enigma_midnight_pulse_new_modifier:GetEffectAttachType ()
    return PATTACH_ABSORIGIN_FOLLOW
end

function enigma_midnight_pulse_new:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

