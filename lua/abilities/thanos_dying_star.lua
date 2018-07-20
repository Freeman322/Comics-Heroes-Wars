LinkLuaModifier( "thanos_dying_star_thinker", "abilities/thanos_dying_star.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "thanos_dying_star_modifier", "abilities/thanos_dying_star.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

thanos_dying_star = class ( {})

function thanos_dying_star:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_item_glove_of_the_creator") then
        return "custom/thanos_dying_star_gauntelt"
    end
    return "custom/thanos_supernova"
end

function thanos_dying_star:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local thinker = CreateModifierThinker(caster, self, "thanos_dying_star_thinker", {duration = 4}, point, team_id, false)
end

thanos_dying_star_thinker = class ({})

function thanos_dying_star_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()
        self.damage = ability:GetSpecialValueFor("damage")/100
        self.radius = ability:GetSpecialValueFor("radius")
        if self:GetCaster():HasModifier("modifier_item_glove_of_the_creator") then
            self.radius = 99999
        end
        self:StartIntervalThink(0.1)
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "thanos_crystals_of_foundation") then 
            local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_crystal_weapon_supernova.vpcf", PATTACH_CUSTOMORIGIN, thinker )
            ParticleManager:SetParticleControl( nFXIndex, 0, target)
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(500, 500, 0))
            ParticleManager:SetParticleControl( nFXIndex, 3, target)
            self:AddParticle( nFXIndex, false, false, -1, false, true )
            EmitSoundOn("hero_Crystal.freezingField.explosion", thinker)
            self.sound = "hero_Crystal.freezingField.wind"
            StartSoundEvent( self.sound, thinker)
        else
            local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova.vpcf", PATTACH_CUSTOMORIGIN, thinker )
            ParticleManager:SetParticleControl( nFXIndex, 0, target)
            ParticleManager:SetParticleControl( nFXIndex, 1, target)
            ParticleManager:SetParticleControl( nFXIndex, 3, target)
            self:AddParticle( nFXIndex, false, false, -1, false, true )
            EmitSoundOn("Hero_Phoenix.SuperNova.Cast", thinker)
            self.sound = "Hero_Phoenix.SuperNova.Begin"
            StartSoundEvent( self.sound, thinker)
        end
        AddFOWViewer( thinker:GetTeam(), target, 1500, 5, false)
        GridNav:DestroyTreesAroundPoint(target, 1500, false)
    end
end

function thanos_dying_star_thinker:OnIntervalThink()
    local thinker = self:GetParent()
    local thinker_pos = thinker:GetAbsOrigin()
    local nearby_targets = FindUnitsInRadius(thinker:GetTeam(), thinker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for i, target in ipairs(nearby_targets) do
        local damage =  target:GetMaxHealth()*self.damage
        ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = damage*0.1, damage_type = DAMAGE_TYPE_PURE})
    end
end

function thanos_dying_star_thinker:OnDestroy()
    if IsServer() then
        StopSoundEvent(self.sound, self:GetParent())
        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "thanos_crystals_of_foundation") then 
            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, thinker )
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, 0));
            ParticleManager:SetParticleControl( nFXIndex, 2, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 3, Vector(self.radius, self.radius, 0));
            ParticleManager:ReleaseParticleIndex( nFXIndex );
        else
            local nFXIndex = ParticleManager:CreateParticle( "particles/thanos/thanos_supernova_explode_a.vpcf", PATTACH_CUSTOMORIGIN, nil );
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetAbsOrigin());
            ParticleManager:SetParticleControl( nFXIndex, 5, Vector(self.radius, self.radius, 0));
            ParticleManager:ReleaseParticleIndex( nFXIndex );
        end
        local caster = self:GetParent()
        EmitSoundOn( "Hero_EarthShaker.EchoSlam", caster )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", caster )
        EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", caster )
        EmitSoundOn( "PudgeWarsClassic.echo_slam", caster )
        local thinker =  self:GetParent()
        local nearby_targets = FindUnitsInRadius(thinker:GetTeam(), thinker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, target in ipairs(nearby_targets) do
            local damage =  target:GetHealth()*0.5
            ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE})
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
