gorr_lightspeed_dash = class({})

LinkLuaModifier ("modifier_gorr_lightspeed_dash", "abilities/gorr_lightspeed_dash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_gorr_lightspeed_dash_buff", "abilities/gorr_lightspeed_dash.lua", LUA_MODIFIER_MOTION_NONE)

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
    local invis_dur = self:GetSpecialValueFor( "invis_dur" )

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

    caster:AddNewModifier(caster, self, "modifier_gorr_lightspeed_dash_buff", {duration = invis_dur})

    -- Create Sound
    EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
    EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

--------------------------------------------------------------------------------
modifier_gorr_lightspeed_dash = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gorr_lightspeed_dash:IsHidden() return false end
function modifier_gorr_lightspeed_dash:IsDebuff() return true end
function modifier_gorr_lightspeed_dash:IsStunDebuff() return false end
function modifier_gorr_lightspeed_dash:IsPurgable() return true end
function modifier_gorr_lightspeed_dash:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------
-- Initializations
function modifier_gorr_lightspeed_dash:OnCreated( kv )
    -- references
    self.damage = self:GetAbility():GetSpecialValueFor( "pop_damage" )
    self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end

function modifier_gorr_lightspeed_dash:OnRefresh( kv ) end
function modifier_gorr_lightspeed_dash:OnRemoved() end

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
function modifier_gorr_lightspeed_dash:DeclareFunctions() return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, } end
function modifier_gorr_lightspeed_dash:GetModifierMoveSpeedBonus_Percentage() return self.slow end
-------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_gorr_lightspeed_dash:GetEffectName() return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf" end
function modifier_gorr_lightspeed_dash:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_gorr_lightspeed_dash:GetStatusEffectName() return "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf" end
function modifier_gorr_lightspeed_dash:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end

modifier_gorr_lightspeed_dash_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gorr_lightspeed_dash_buff:IsHidden() return false end
function modifier_gorr_lightspeed_dash_buff:IsDebuff() return false end
function modifier_gorr_lightspeed_dash_buff:IsPurgable() return false end

function modifier_gorr_lightspeed_dash_buff:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_gorr_lightspeed_dash_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_gorr_lightspeed_dash_buff:GetModifierInvisibilityLevel() return 1 end
function modifier_gorr_lightspeed_dash_buff:OnAbilityExecuted( params )
    if IsServer() then
        if params.unit~=self:GetParent() then return end

        self:Destroy()
    end
end

function modifier_gorr_lightspeed_dash_buff:OnAttackLanded( params )
    if IsServer() then
        if params.attacker ~= self:GetParent() then return end

        self:DoRebuke(params.target)
        self:Destroy()
    end
end

function modifier_gorr_lightspeed_dash_buff:DoRebuke( target )
    if IsServer() then
        local caster = self:GetCaster()
        local point = target:GetAbsOrigin()

        local total_damage = 0

        local radius = self:GetAbility():GetSpecialValueFor("radius_rebuke")
        local damage = self:GetAbility():GetSpecialValueFor("rebuke_damage")
        local angle = self:GetAbility():GetSpecialValueFor("angle") / 2
        local duration = 0.35
        local distance = 95

        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

        local origin = caster:GetOrigin()
        local cast_direction = (point-origin):Normalized()

        for _,enemy in pairs(enemies) do
            local enemy_direction = (enemy:GetOrigin() - origin):Normalized()

            ApplyDamage({
                victim = enemy,
                attacker = caster,
                ability = self:GetAbility(),
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL
            })

            total_damage = total_damage + damage

            enemy:AddNewModifier(
                caster,
                self,
                "modifier_knockback",
                {
                    duration = duration,
                    distance = distance,
                    height = 30,
                    direction_x = enemy_direction.x,
                    direction_y = enemy_direction.y,
                }
            )

            self:PlayEffectsTarget( enemy, origin, cast_direction )
        end

        self:PlayEffectsSpellGeneric( caught, (point - origin):Normalized() )

        caster:Heal(total_damage, caster)
    end
end

--------------------------------------------------------------------------------
-- Play Effects
function modifier_gorr_lightspeed_dash_buff:PlayEffectsSpellGeneric( caught, direction )
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"
    local sound_cast = "Hero_Mars.Shield.Cast"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
    ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_gorr_lightspeed_dash_buff:PlayEffectsTarget( target, origin, direction )
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"
    local sound_cast = "Hero_Mars.Shield.Crit"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
    ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
    ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_gorr_lightspeed_dash_buff:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
    }

    return state
end