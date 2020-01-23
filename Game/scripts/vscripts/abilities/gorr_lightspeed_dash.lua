gorr_lightspeed_dash = class({})

LinkLuaModifier( "modifier_generic_charges", "modifiers/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier ("modifier_gorr_lightspeed_dash", "abilities/gorr_lightspeed_dash.lua", LUA_MODIFIER_MOTION_NONE)

function gorr_lightspeed_dash:GetIntrinsicModifierName()
    return "modifier_generic_charges"
end

function gorr_lightspeed_dash:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local origin = caster:GetOrigin()

    -- load data
    local min_dist = self:GetSpecialValueFor( "min_travel_distance" )
    local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
    local radius = self:GetSpecialValueFor( "radius" )
    local delay = self:GetSpecialValueFor( "pop_damage_delay" )

    -- find destination
    local direction = (point-origin)
    local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
    direction.z = 0
    direction = direction:Normalized()

    local target = GetGroundPosition( origin + direction*dist, nil )

    -- teleport
    FindClearSpaceForUnit( caster, target, true )

    -- find units in line
    local enemies = FindUnitsInLine(
            self:GetCaster():GetTeamNumber(),	-- int, your team number
            origin,	-- point, start point
            target,	-- point, end point
            nil,	-- handle, cacheUnit. (not known)
            radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	-- int, flag filter
    )

    for _,enemy in pairs(enemies) do
        -- perform attack
        caster:PerformAttack( enemy, true, true, true, false, true, false, true )

        -- add modifier
        enemy:AddNewModifier(
                caster, -- player source
                self, -- ability source
                "modifier_gorr_lightspeed_dash", -- modifier name
                { duration = delay } -- kv
        )

        -- play effects
        -- Get Resources
        local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf"

        -- Create Particle
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy )
        ParticleManager:ReleaseParticleIndex( effect_cast )
    end

    -- play effects
    local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"
    local sound_start = "Hero_VoidSpirit.AstralStep.Start"
    local sound_end = "Hero_VoidSpirit.AstralStep.End"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( effect_cast, 0, origin )
    ParticleManager:SetParticleControl( effect_cast, 1, target )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
    EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

--------------------------------------------------------------------------------
modifier_gorr_lightspeed_dash = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gorr_lightspeed_dash:IsHidden()
    return false
end

function modifier_gorr_lightspeed_dash:IsDebuff()
    return true
end

function modifier_gorr_lightspeed_dash:IsStunDebuff()
    return false
end

function modifier_gorr_lightspeed_dash:IsPurgable()
    return true
end

function modifier_gorr_lightspeed_dash:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_gorr_lightspeed_dash:OnCreated( kv )
    -- references
    self.damage = self:GetAbility():GetSpecialValueFor( "pop_damage" )
    self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end

function modifier_gorr_lightspeed_dash:OnRefresh( kv )

end

function modifier_gorr_lightspeed_dash:OnRemoved()
end

function modifier_gorr_lightspeed_dash:OnDestroy()
    if not IsServer() then return end

    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf"
    local sound_target = "Hero_VoidSpirit.AstralStep.MarkExplosion"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( sound_target, self:GetParent() )

    -- Apply damage
    local damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility(),
    }

    ApplyDamage(damageTable)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_gorr_lightspeed_dash:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_gorr_lightspeed_dash:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_gorr_lightspeed_dash:GetEffectName()
    return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"
end

function modifier_gorr_lightspeed_dash:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_gorr_lightspeed_dash:GetStatusEffectName()
    return "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf"
end

function modifier_gorr_lightspeed_dash:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end
