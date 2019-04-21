LinkLuaModifier ("modifier_vader_force_storm_thinker", "abilities/vader_force_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_vader_force_storm", "abilities/vader_force_storm.lua", LUA_MODIFIER_MOTION_NONE)
vader_force_storm = class({})


function vader_force_storm:GetAOERadius ()
    return self:GetSpecialValueFor("radius")
end

function vader_force_storm:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end

function vader_force_storm:OnSpellStart ()
    local caster = self:GetCaster ()
    local point = self:GetCursorPosition ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor("duration")

    local thinker = CreateModifierThinker (caster, self, "modifier_vader_force_storm_thinker", {duration = duration }, point, team_id, false)
    AddFOWViewer (caster:GetTeam (), point, 450, duration, false)
    GridNav:DestroyTreesAroundPoint (point, 500, false)
end

modifier_vader_force_storm_thinker = class({})

function modifier_vader_force_storm_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_vader/vader_force_storm.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(450, self.radius, 4))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(10, 10, 10))
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetCursorPosition())
        ParticleManager:SetParticleControl( nFXIndex, 10, self:GetCaster():GetCursorPosition())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        StartSoundEvent("Hero_Disruptor.StaticStorm", thinker)
    end
end
function modifier_vader_force_storm_thinker:OnDestroy()
    if IsServer() then
        StopSoundEvent("Hero_Disruptor.StaticStorm", self:GetParent())
    end
end
function modifier_vader_force_storm_thinker:IsAura ()
    return true
end

function modifier_vader_force_storm_thinker:GetAuraRadius ()
    return self.radius
end

function modifier_vader_force_storm_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_vader_force_storm_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_vader_force_storm_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_vader_force_storm_thinker:GetModifierAura ()
    return "modifier_vader_force_storm"
end


modifier_vader_force_storm = class({})

function modifier_vader_force_storm:IsBuff ()
    return false
end

function modifier_vader_force_storm:OnCreated (event)
    local ability = self:GetAbility()
    self:StartIntervalThink( 1 )
    self:OnIntervalThink()
end

function modifier_vader_force_storm:GetEffectName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf"
end

function modifier_vader_force_storm:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_vader_force_storm:OnIntervalThink(  )
    if IsServer() then
        if self:GetCaster():HasModifier("modifier_vader") then
            local mod = self:GetCaster():FindModifierByName("modifier_vader")
            self.damage = mod:GetStackCount()*self:GetAbility():GetSpecialValueFor("counter_buff")
        else
            self.damage = 0
        end
        ApplyDamage( {attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage") + self.damage, damage_type = DAMAGE_TYPE_MAGICAL} )
    end
end

function modifier_vader_force_storm:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_vader_force_storm:CheckState()
    local state = {
    [MODIFIER_STATE_SILENCED] = true,
    }

    return state
end

function modifier_vader_force_storm:GetModifierMoveSpeedBonus_Percentage( params )
    return -250
end

function vader_force_storm:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

