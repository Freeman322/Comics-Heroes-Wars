spawn_dissimilate = class({})
LinkLuaModifier ("modifier_spawn_dissimilate", "abilities/spawn_dissimilate.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Ability Start
function spawn_dissimilate:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()

    -- load data
    local duration = self:GetSpecialValueFor( "phase_duration" )

    -- add modifier
    caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_spawn_dissimilate", -- modifier name
            { duration = duration } -- kv
    )

    -- Play sound
    local sound_cast = "Hero_VoidSpirit.Dissimilate.Cast"
    EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
modifier_spawn_dissimilate = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spawn_dissimilate:IsHidden()
    return false
end

function modifier_spawn_dissimilate:IsDebuff()
    return false
end

function modifier_spawn_dissimilate:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spawn_dissimilate:OnCreated( kv )
    -- references
    self.portals = self:GetAbility():GetSpecialValueFor( "portals_per_ring" )
    self.angle = self:GetAbility():GetSpecialValueFor( "angle_per_ring_portal" )
    self.radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
    self.distance = self:GetAbility():GetSpecialValueFor( "first_ring_distance_offset" )
    self.target_radius = self:GetAbility():GetSpecialValueFor( "destination_fx_radius" )

    if not IsServer() then return end

    local origin = self:GetParent():GetOrigin()
    local direction = self:GetParent():GetForwardVector()
    local zero = Vector(0,0,0)
    self.selected = 1

    -- determine 6 points
    self.points = {}
    self.effects = {}
    table.insert( self.points, origin )
    table.insert( self.effects, self:PlayEffects1( origin, true ) )

    for i=1,self.portals do
        local new_direction = RotatePosition( zero, QAngle( 0, self.angle*i, 0 ), direction )
        local point = GetGroundPosition( origin + new_direction * self.distance, nil )

        table.insert( self.points, point )
        table.insert( self.effects, self:PlayEffects1( point, false ) )
    end

    -- precache damage
    self.damageTable = {
        -- victim = target,
        attacker = self:GetCaster(),
        damage = self:GetAbility():GetAbilityDamage(),
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self, --Optional.
    }

    -- nodraw
    self:GetParent():AddNoDraw()
end

function modifier_spawn_dissimilate:OnRefresh( kv )

end

function modifier_spawn_dissimilate:OnRemoved()
end

function modifier_spawn_dissimilate:OnDestroy()
    if not IsServer() then return end

    local point = self.points[self.selected]

    -- move parent
    FindClearSpaceForUnit( self:GetParent(), point, true )

    -- find enemies
    local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),	-- int, your team number
            point,	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            0,	-- int, flag filter
            0,	-- int, order filter
            false	-- bool, can grow cache
    )
    for _,enemy in pairs(enemies) do
        -- apply damage
        self.damageTable.victim = enemy
        ApplyDamage(self.damageTable)
    end

    -- nodraw
    self:GetParent():RemoveNoDraw()
    self:GetParent():Heal(self:GetParent():GetMaxHealth(), self:GetParent())
    self:GetParent():GiveMana(self:GetParent():GetMaxMana())
    self:GetParent():Purge(false, true, false, true, true)

        -- play effects
    self:PlayEffects2( point, #enemies )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_spawn_dissimilate:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ORDER,

        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_spawn_dissimilate:OnOrder( params )
    if params.unit~=self:GetParent() then return end

    -- right click, switch position
    if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
        self:SetValidTarget( params.new_pos )
    elseif
    params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
            params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
    then
        self:SetValidTarget( params.target:GetOrigin() )
    end
end

function modifier_spawn_dissimilate:GetModifierMoveSpeed_Limit()
    return 0.1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_spawn_dissimilate:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
    }

    return state
end

--------------------------------------------------------------------------------
-- Helper
function modifier_spawn_dissimilate:SetValidTarget( location )
    -- find max
    local max_dist = (location-self.points[1]):Length2D()
    local max_point = 1
    for i,point in ipairs(self.points) do
        local dist = (location-point):Length2D()
        if dist<max_dist then
            max_dist = dist
            max_point = i
        end
    end

    -- select
    local old_select = self.selected
    self.selected = max_point

    -- change effects
    self:ChangeEffects( old_select, self.selected )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_spawn_dissimilate:PlayEffects1( point, main )
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf"
    local sound_cast = "Hero_VoidSpirit.Dissimilate.Portals"

    -- adjustments
    local radius = self.radius + 25

    -- Create Particle for this team
    local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetParent(), self:GetParent():GetTeamNumber() )
    ParticleManager:SetParticleControl( effect_cast, 0, point )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 1 ) )
    if main then
        ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, 0, 0 ) )
    end

    -- Create Particle for enemy team
    local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetParent(), self:GetParent():GetOpposingTeamNumber() )
    ParticleManager:SetParticleControl( effect_cast2, 0, point )
    ParticleManager:SetParticleControl( effect_cast2, 1, Vector( radius, 0, 1 ) )

    -- buff particle
    self:AddParticle(
            effect_cast,
            false, -- bDestroyImmediately
            false, -- bStatusEffect
            -1, -- iPriority
            false, -- bHeroEffect
            false -- bOverheadEffect
    )
    self:AddParticle(
            effect_cast2,
            false, -- bDestroyImmediately
            false, -- bStatusEffect
            -1, -- iPriority
            false, -- bHeroEffect
            false -- bOverheadEffect
    )

    -- Play Sound
    EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )

    return effect_cast
end

function modifier_spawn_dissimilate:ChangeEffects( old, new )
    ParticleManager:SetParticleControl( self.effects[old], 2, Vector( 0, 0, 0 ) )
    ParticleManager:SetParticleControl( self.effects[new], 2, Vector( 1, 0, 0 ) )
end

function modifier_spawn_dissimilate:PlayEffects2( point, hit )
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf"
    local particle_cast2 = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf"
    local sound_cast = "Hero_VoidSpirit.Dissimilate.TeleportIn"
    local sound_hit = "Hero_VoidSpirit.Dissimilate.Stun"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
    ParticleManager:SetParticleControl( effect_cast, 0, point )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.target_radius, 0, 0 ) )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Create Sound
    EmitSoundOn( sound_cast, self:GetParent() )
    if hit>0 then
        EmitSoundOn( sound_hit, self:GetParent() )
    end
end