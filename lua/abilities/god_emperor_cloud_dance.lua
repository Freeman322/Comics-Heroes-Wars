LinkLuaModifier ("god_emperor_cloud_dance_thinker", "abilities/god_emperor_cloud_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_god_emperor_cloud_dance", "abilities/god_emperor_cloud_dance.lua", LUA_MODIFIER_MOTION_NONE)

god_emperor_cloud_dance = class ({})

function god_emperor_cloud_dance:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

function god_emperor_cloud_dance:GetChannelTime()
    return self:GetSpecialValueFor("channel_time")
end

function god_emperor_cloud_dance:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = caster:GetAbsOrigin()
    local team_id = caster:GetTeamNumber ()

    self.thinker = CreateModifierThinker (caster, self, "god_emperor_cloud_dance_thinker", {duration = self:GetSpecialValueFor("channel_time")}, point, team_id, false)
    AddFOWViewer (caster:GetTeam (), point, 450, 4, false)
    GridNav:DestroyTreesAroundPoint(point, 500, false)
    self.point = point
end

function god_emperor_cloud_dance:GetAbilityCenter()
    return self.point
end


function god_emperor_cloud_dance:OnChannelFinish( bInterrupted )
    if bInterrupted then
        self.thinker:Destroy()
    end
end

if god_emperor_cloud_dance_thinker == nil then god_emperor_cloud_dance_thinker = class({}) end

function god_emperor_cloud_dance_thinker:OnCreated(event)
    local thinker = self:GetParent()
    local ability = self:GetAbility()
    self.radius = ability:GetSpecialValueFor("range")
    local thinker_pos = thinker:GetAbsOrigin()

    local Parct = ParticleManager:CreateParticle ("particles/units/heroes/hero_riki/riki_tricks.vpcf", PATTACH_WORLDORIGIN, thinker)
    ParticleManager:SetParticleControl(Parct, 0, thinker_pos )
    ParticleManager:SetParticleControl(Parct, 1, Vector (self.radius, self.radius, 1))
    ParticleManager:SetParticleControl(Parct, 2, Vector (self:GetAbility():GetChannelTime(), 0, 0))
    ParticleManager:SetParticleControl(Parct, 3, thinker_pos)
    ParticleManager:SetParticleControl(Parct, 6, thinker_pos)
    ParticleManager:SetParticleControl(Parct, 9, thinker_pos)
    self:AddParticle( Parct, false, false, -1, false, true )

    EmitSoundOn("Hero_Riki.Blink_Strike.Immortal", thinker)
end

function god_emperor_cloud_dance_thinker:IsAura()
    return true
end

function god_emperor_cloud_dance_thinker:GetAuraRadius()
    return self.radius
end

function god_emperor_cloud_dance_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function god_emperor_cloud_dance_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function god_emperor_cloud_dance_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function god_emperor_cloud_dance_thinker:GetModifierAura()
    return "modifier_god_emperor_cloud_dance"
end

if modifier_god_emperor_cloud_dance == nil then modifier_god_emperor_cloud_dance = class({}) end

function modifier_god_emperor_cloud_dance:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_god_emperor_cloud_dance:GetStatusEffectName()
    return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

--------------------------------------------------------------------------------

function modifier_god_emperor_cloud_dance:StatusEffectPriority()
    return 1000
end

function modifier_god_emperor_cloud_dance:OnCreated( kv )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/murlock/murlock_primal_eject.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeR" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeL" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 15, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 16, self:GetParent():GetOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        self:OnIntervalThink(  )
        -- Runs when the think interval occurs.
        self:StartIntervalThink(self:GetAbility():GetChannelTime()/self:GetAbility():GetSpecialValueFor("attack_count"))
    end
end

function modifier_god_emperor_cloud_dance:OnIntervalThink()
    local caster = self:GetParent()
    local pos = self:GetAbility():GetCaster():GetAbsOrigin()
    local radius = self:GetAbility():GetSpecialValueFor("range")
    local nearby_units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

    for _, target in pairs(nearby_units) do
        if target then
            caster:PerformAttack(target, true, true, true, true, false, false, true)
        end
    end
end

function modifier_god_emperor_cloud_dance:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY,
    }

    return funcs
end
function modifier_god_emperor_cloud_dance:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }

    return state
end

function modifier_god_emperor_cloud_dance:GetModifierPersistentInvisibility()
    return 1
end

function modifier_god_emperor_cloud_dance:IsHidden()
    return false
end

function modifier_god_emperor_cloud_dance:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function god_emperor_cloud_dance:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

