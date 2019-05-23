LinkLuaModifier( "modifier_dormammu_static_storm_thinker", "abilities/dormammu_static_storm.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_dormammu_static_storm_thinker_modifier", "abilities/dormammu_static_storm.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

dormammu_static_storm = class ( {})

function dormammu_static_storm:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local thinker = CreateModifierThinker(caster, self, "modifier_dormammu_static_storm_thinker", {duration = 4}, point, team_id, false)
end

modifier_dormammu_static_storm_thinker = class ({})

function modifier_dormammu_static_storm_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()
        self.damage = ability:GetSpecialValueFor("damage")
        self.radius = ability:GetSpecialValueFor("radius")

        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target)
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 0))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("duration"), 0, 0))
        self:AddParticle(nFXIndex, false, false, -1, false, false)

        AddFOWViewer( thinker:GetTeam(), target, 1500, 5, false)
        GridNav:DestroyTreesAroundPoint(target, 1500, false)

        self:StartIntervalThink(1)
        self:OnIntervalThink()

        EmitSoundOn("Hero_ArcWarden.SparkWraith.Cast", self:GetParent())
        EmitSoundOn("Hero_ArcWarden.SparkWraith.Appear", self:GetParent())
        StartSoundEvent("Hero_ArcWarden.SparkWraith.Loop", self:GetParent())
    end
end

function modifier_dormammu_static_storm_thinker:OnIntervalThink()
    if pcall(function () 
        local thinker = self:GetParent()
        local thinker_pos = thinker:GetAbsOrigin()
        local nearby_targets = FindUnitsInRadius(thinker:GetTeam(), thinker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        self.bonus = 0
	    if self:GetCaster():HasTalent("special_bonus_unique_dormammu_3") then
		    self.bonus = self:GetCaster():FindTalentValue("special_bonus_unique_dormammu_3")	
        end	
        for i, target in ipairs(nearby_targets) do
            local damage = self.damage + self.bonus
            ApplyDamage({victim = target, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = self:GetAbility():GetAbilityDamageType()})
        end 
    end) then end
end

function modifier_dormammu_static_storm_thinker:OnDestroy()
    if IsServer() then
        StopSoundEvent("Hero_ArcWarden.SparkWraith.Loop", self:GetParent())      
    end
end

function modifier_dormammu_static_storm_thinker:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end

function modifier_dormammu_static_storm_thinker:IsAura()
    return true
end

function modifier_dormammu_static_storm_thinker:GetAuraRadius()
    return self.radius
end

function modifier_dormammu_static_storm_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_dormammu_static_storm_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_dormammu_static_storm_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_dormammu_static_storm_thinker:GetModifierAura()
    return "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf"
end

modifier_dormammu_static_storm_thinker_modifier = class ( {})

function modifier_dormammu_static_storm_thinker_modifier:IsDebuff ()
    return true
end

function modifier_dormammu_static_storm_thinker_modifier:OnCreated (event)
    self.miss = 0
    if IsServer() then 
        if self:GetCaster():HasTalent("special_bonus_unique_dormammu_4") then 
            self.miss = self:GetCaster():FindTalentValue("special_bonus_unique_dormammu_4")
        end
        EmitSoundOn("Hero_ArcWarden.SparkWraith.Activate", self:GetParent())
        EmitSoundOn("Hero_ArcWarden.SparkWraith.Damage", self:GetParent())
    end
end

function modifier_dormammu_static_storm_thinker_modifier:DeclareFunctions ()
    return { MODIFIER_PROPERTY_MISS_PERCENTAGE }
end

function modifier_dormammu_static_storm_thinker_modifier:GetModifierMiss_Percentage()
    return self.miss
end

function modifier_dormammu_static_storm_thinker_modifier:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end

function modifier_dormammu_static_storm_thinker_modifier:GetEffectAttachType ()
    return PATTACH_POINT_FOLLOW
end
