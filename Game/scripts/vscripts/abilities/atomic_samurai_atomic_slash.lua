atomic_samurai_atomic_slash = class({})

LinkLuaModifier ("modifier_atomic_samurai_atomic_slash", "abilities/atomic_samurai_atomic_slash.lua", LUA_MODIFIER_MOTION_NONE)

function atomic_samurai_atomic_slash:OnSpellStart()
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
        -- add modifier
        enemy:AddNewModifier(
                caster, -- player source
                self, -- ability source
                "modifier_atomic_samurai_atomic_slash", -- modifier name
                { duration = delay } -- kv
        )

        -- play effects
        -- Get Resources
        local particle_cast = "particles/stygian/atomic_samurai_atomic_slash_impact.vpcf"

        -- Create Particle
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy )
        ParticleManager:ReleaseParticleIndex( effect_cast )
    end

    -- play effects
    local particle_cast = "particles/stygian/atomic_samurai_atomic_slash.vpcf"
    local sound_start = "Hero_StormSpirit.StaticRemnantPlant"
    local sound_end = "Hero_StormSpirit.PreAttack"

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
modifier_atomic_samurai_atomic_slash = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_atomic_samurai_atomic_slash:IsHidden() return false end
function modifier_atomic_samurai_atomic_slash:IsDebuff() return true end
function modifier_atomic_samurai_atomic_slash:IsStunDebuff() return false end
function modifier_atomic_samurai_atomic_slash:IsPurgable() return true end
function modifier_atomic_samurai_atomic_slash:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------
-- Initializations
function modifier_atomic_samurai_atomic_slash:OnCreated( kv )
    if IsServer() then
    self.damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetParent()) * self:GetAbility():GetSpecialValueFor ("attack_count") end
    self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end

function modifier_atomic_samurai_atomic_slash:OnRefresh( kv ) end
function modifier_atomic_samurai_atomic_slash:OnRemoved() end

function modifier_atomic_samurai_atomic_slash:OnDestroy()
    if not IsServer() then return end

    -- Get Resources
    local particle_cast = "particles/stygian/atomic_samurai_atomic_slash_damage.vpcf"
    local sound_target = "Hero_StormSpirit.Overload"

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
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability = self:GetAbility(),
    }

    ApplyDamage(damageTable)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_atomic_samurai_atomic_slash:DeclareFunctions() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, } end
function modifier_atomic_samurai_atomic_slash:GetModifierMoveSpeedBonus_Percentage() return self.slow end

