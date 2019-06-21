LinkLuaModifier ("nightcrawler_sonic_sphere_thinker", "abilities/nightcrawler_sonic_sphere.lua", LUA_MODIFIER_MOTION_NONE)

nightcrawler_sonic_sphere = class ( {})

function nightcrawler_sonic_sphere:OnSpellStart ()
    local point = self:GetCursorPosition ()
    local caster = self:GetCaster ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor ("duration")
    local thinker = CreateModifierThinker (caster, self, "nightcrawler_sonic_sphere_thinker", {duration = duration }, point, team_id, false)
end

function nightcrawler_sonic_sphere:GetAOERadius ()
    return self:GetSpecialValueFor("radius")
end

nightcrawler_sonic_sphere_thinker = class ( {})

function nightcrawler_sonic_sphere_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    local thinker_pos = thinker:GetAbsOrigin()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")

    if IsServer() then 
        local particle1 = "particles/hero_nightcrawler/nightcrawler_sonic_sphere.vpcf"
        local sound = "Hero_MonkeyKing.Spring.Channel"

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "octavia") then
            particle1 = "particles/octavia_skin/octavia_skin.vpcf"

           sound = "OctaviaSkin.Sphere"
        end

        local particle = ParticleManager:CreateParticle (particle1, PATTACH_WORLDORIGIN, thinker)
        ParticleManager:SetParticleControl(particle, 0, thinker_pos)
        ParticleManager:SetParticleControl(particle, 1, Vector (self.radius, self.radius, 0))
        ParticleManager:SetParticleControl(particle, 2, Vector (self:GetAbility():GetSpecialValueFor("duration"), 1, 0))
        ParticleManager:SetParticleControl(particle, 4, thinker_pos)
        ParticleManager:SetParticleControl(particle, 5, thinker_pos)
        self:AddParticle( particle, false, false, -1, false, true )

        EmitSoundOn(sound, thinker)
    end  
end

function nightcrawler_sonic_sphere_thinker:IsAura ()
    return true
end

function nightcrawler_sonic_sphere_thinker:GetAuraRadius ()
    return self.radius
end

function nightcrawler_sonic_sphere_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function nightcrawler_sonic_sphere_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function nightcrawler_sonic_sphere_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function nightcrawler_sonic_sphere_thinker:GetModifierAura ()
    return "modifier_faceless_void_backtrack"
end

function nightcrawler_sonic_sphere:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

