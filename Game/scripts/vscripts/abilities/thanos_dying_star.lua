LinkLuaModifier( "thanos_dying_star_thinker", "abilities/thanos_dying_star.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "thanos_dying_star_modifier", "abilities/thanos_dying_star.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

thanos_dying_star = class ( {})

function thanos_dying_star:OnInventoryContentsChanged()
    self:SetHidden(not self:GetCaster():HasScepter())
    self:SetLevel(1)
end

function thanos_dying_star:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local point = self:GetCursorPosition()
        local team_id = caster:GetTeamNumber()
        local thinker = CreateModifierThinker(caster, self, "thanos_dying_star_thinker", {duration = 4}, point, team_id, false)
    end
end

thanos_dying_star_thinker = class ({})

function thanos_dying_star_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()

        self.damage = ability:GetAbilityDamage()
        self.radius = ability:GetSpecialValueFor("radius")
  
        self:StartIntervalThink(0.1)

        local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target)
        ParticleManager:SetParticleControl( nFXIndex, 1, target)
        ParticleManager:SetParticleControl( nFXIndex, 3, target)

        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("Hero_Phoenix.SuperNova.Cast", thinker)

        self.sound = "Hero_Phoenix.SuperNova.Begin"

        StartSoundEvent( self.sound, thinker)

        AddFOWViewer( thinker:GetTeam(), target, 1500, 5, false)
        GridNav:DestroyTreesAroundPoint(target, 1500, false)
    end
end

function thanos_dying_star_thinker:OnIntervalThink()
    local thinker = self:GetParent()
    local thinker_pos = thinker:GetAbsOrigin()
    
    local nearby_targets = FindUnitsInRadius(thinker:GetTeam(), thinker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for i, target in ipairs(nearby_targets) do
        ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = self.damage*0.1, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function thanos_dying_star_thinker:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()
        
        StopSoundEvent(self.sound, caster)
        
        local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova_explode_a.vpcf", PATTACH_CUSTOMORIGIN, nil );

        ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetAbsOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 1, caster:GetAbsOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 3, caster:GetAbsOrigin());

        ParticleManager:SetParticleControl( nFXIndex, 5, Vector(self.radius, self.radius, 0));
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn( "Hero_EarthShaker.EchoSlam", caster )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", caster )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", caster )
        EmitSoundOn( "PudgeWarsClassic.echo_slam", caster )

        local thinker =  self:GetParent()
        local nearby_targets = FindUnitsInRadius(thinker:GetTeam(), thinker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, target in ipairs(nearby_targets) do
            target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 2})
        end
    end
end

function thanos_dying_star_thinker:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end

function thanos_dying_star_thinker:IsAura()
    return true
end

function thanos_dying_star_thinker:GetAuraRadius()
    return self.radius
end

function thanos_dying_star_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function thanos_dying_star_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function thanos_dying_star_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function thanos_dying_star_thinker:GetModifierAura()
    return "thanos_dying_star_modifier"
end

thanos_dying_star_modifier = class ( {})

function thanos_dying_star_modifier:IsDebuff ()
    return true
end

function thanos_dying_star_modifier:OnCreated (event)
    local ability = self:GetAbility ()
end

function thanos_dying_star_modifier:DeclareFunctions ()
    return { MODIFIER_PROPERTY_MISS_PERCENTAGE }
end

function thanos_dying_star_modifier:GetModifierMiss_Percentage()
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("miss_chance")
end

function thanos_dying_star_modifier:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end

function thanos_dying_star_modifier:GetEffectAttachType ()
    return PATTACH_POINT_FOLLOW
end
