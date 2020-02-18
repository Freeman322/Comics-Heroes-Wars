beyonder_astral_shield = class({})
LinkLuaModifier( "modifier_beyonder_astral_shield", "abilities/beyonder_astral_shield.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beyonder_astral_shield_debuff", "abilities/beyonder_astral_shield.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function beyonder_astral_shield:OnSpellStart()
    if IsServer() then
        -- unit identifier
        local caster = self:GetCaster()

        -- load data
        local duration = self:GetSpecialValueFor( "buff_duration" )

        if self:GetCaster():HasTalent("special_bonus_unique_beyonder_2") then
            duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_beyonder_2")
        end

        -- add modifier
        caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_beyonder_astral_shield", -- modifier name
            { duration = duration } -- kv
        )
    end
end

--------------------------------------------------------------------------------
modifier_beyonder_astral_shield = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_beyonder_astral_shield:IsHidden() return false end
function modifier_beyonder_astral_shield:IsDebuff() return false end
function modifier_beyonder_astral_shield:IsPurgable() return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_beyonder_astral_shield:OnCreated( kv )
    -- references
    self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
    self.base_absorb = self:GetAbility():GetSpecialValueFor( "base_absorb_amount" )
    self.unit_absorb = self:GetAbility():GetSpecialValueFor( "unit_absorb_damage_ptc" )
    self.return_speed = self:GetAbility():GetSpecialValueFor( "return_projectile_speed" )

    if not IsServer() then return end

    if self:GetCaster():HasTalent("special_bonus_unique_beyonder_1") then
        self.damage = self.damage + self:GetCaster():FindTalentValue("special_bonus_unique_beyonder_1")
    end

    local duration = self:GetAbility():GetSpecialValueFor( "buff_duration" )

    -- set up shield
    self.shield = self.base_absorb

    local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    if #units > 0 then
        for _,unit in pairs(units) do
            local income = unit:GetAttackDamage() * (self.unit_absorb / 100)

            unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_beyonder_astral_shield_debuff", { duration = duration } )

            self.shield = self.shield + income

            if not unit:IsFriendly(self:GetCaster()) then
                local DamageTable = {
                    attacker = self:GetCaster(),
                    victim = unit,
                    ability = self:GetAbility(),
                    damage = self.damage,
                    damage_type = DAMAGE_TYPE_MAGICAL
                }

                ApplyDamage(DamageTable)
            end
        end
    end

    -- Create Sound
    EmitSoundOn( "Hero_VoidSpirit.Pulse", self:GetParent() )

    -- Get Data
    local radius = 100

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle(  "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        self:GetParent(),
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )

    -- buff particle
    self:AddParticle(
        effect_cast,
        false, -- bDestroyImmediately
        false, -- bStatusEffect
        -1, -- iPriority
        false, -- bHeroEffect
        false -- bOverheadEffect
    )

    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( "Hero_VoidSpirit.Pulse.Cast", self:GetParent() )
end

function modifier_beyonder_astral_shield:OnDestroy()
    if not IsServer() then return end

    EmitSoundOn( "Hero_VoidSpirit.Pulse.Destroy", self:GetParent() )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_beyonder_astral_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
    }

    return funcs
end

function modifier_beyonder_astral_shield:GetModifierPhysical_ConstantBlock( params )
    if not IsServer() then return end
    -- Get Data
    local radius = 100

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield_deflect.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        self:GetParent(),
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )

    ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    if params.damage > self.shield then
        self:Destroy()

        return params.damage
    else
        self.shield = self.shield - params.damage
        return params.damage
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_beyonder_astral_shield:GetStatusEffectName()
    return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf"
end

function modifier_beyonder_astral_shield:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end


function modifier_beyonder_astral_shield:AbsorbEffect( target )
    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( "Hero_VoidSpirit.Pulse.Target", target )

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        target,
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        1,
        self:GetParent(),
        PATTACH_POINT_FOLLOW,
        "attach_hitloc",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )

    ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_beyonder_astral_shield_debuff = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    IsDebuff = function() return true end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE} end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_beyonder_astral_shield_debuff:GetModifierDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("unit_absorb_damage_ptc") * (-1) end
