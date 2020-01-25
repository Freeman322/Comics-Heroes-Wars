infinity_black_hole = class({})

LinkLuaModifier ("modifier_infinity_black_hole_thinker", "abilities/infinity_black_hole.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_infinity_black_hole_debuff", "abilities/infinity_black_hole.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius

infinity_black_hole.m_Ability = nil

function infinity_black_hole:GetAOERadius()
    return self:GetSpecialValueFor( "far_radius" )
end

function infinity_black_hole:OnUpgrade()
    if IsServer() then
        if self.m_Ability and not self.m_Ability:IsNull() then
            self.m_Ability:SetLevel(self:GetLevel())
        end
    end
end

function infinity_black_hole:Spawn()
    if IsServer() then
        self.m_Ability = self:GetCaster():FindAbilityByName("enigma_vacuum")
    end
end

--------------------------------------------------------------------------------
-- Ability Start
function infinity_black_hole:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    -- load data
    local duration = self:GetSpecialValueFor("duration")

    -- create thinker
    self.thinker = CreateModifierThinker(
            caster, -- player source
            self, -- ability source
            "modifier_infinity_black_hole_thinker", -- modifier name
            { duration = duration }, -- kv
            point,
            caster:GetTeamNumber(),
            false
    )
    self.thinker = self.thinker:FindModifierByName("modifier_infinity_black_hole_thinker")
end

--------------------------------------------------------------------------------
-- Ability Channeling
function infinity_black_hole:OnChannelFinish( bInterrupted )
    if self.thinker and not self.thinker:IsNull() then
        self.thinker:Destroy()
    end
end


--------------------------------------------------------------------------------
modifier_infinity_black_hole_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_infinity_black_hole_thinker:IsHidden() return false end
function modifier_infinity_black_hole_thinker:IsPurgable() return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_infinity_black_hole_thinker:OnCreated( kv )
    self.radius = self:GetAbility():GetSpecialValueFor( "far_radius" )
    self.interval = 1
    self.ticks = math.floor(self:GetDuration()/self.interval+0.5)
    self.tick = 0

    if IsServer() then
        local damage = self:GetAbility():GetSpecialValueFor( "damage" )

        self.damageTable = {
            -- victim = target,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility(),
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
            ptc_dmg = self:GetAbility():GetSpecialValueFor("damage_perc")
        }

        if self:GetCaster():HasScepter() then
            local midnight = self:GetCaster():FindAbilityByName("enigma_midnight_pulse_new")
            if midnight then
                self.damageTable.ptc_dmg = self.damageTable.ptc_dmg + midnight:GetSpecialValueFor("damage_per_tick")
            end
        end

        self:StartIntervalThink( self.interval )
        self:AddEffects()
    end
end

function modifier_infinity_black_hole_thinker:OnRefresh( kv )

end

function modifier_infinity_black_hole_thinker:OnRemoved()
    if IsServer() then
        -- ensure last tick damage happens
        if self:GetRemainingTime()<0.01 and self.tick<self.ticks then
            self:OnIntervalThink()
        end

        UTIL_Remove( self:GetParent() )
    end

    local sound_cast = "Hero_Enigma.BlackHole.Cast.Chasm"
    local sound_stop = "Hero_Enigma.Black_Hole.Stop"

    StopSoundOn( sound_cast, self:GetParent() )
    EmitSoundOn( sound_stop, self:GetParent() )
end

function modifier_infinity_black_hole_thinker:OnDestroy()
    if IsServer() then
    end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_infinity_black_hole_thinker:OnIntervalThink()
    -- aoe damage
    local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),	-- int, your team number
            self:GetParent():GetOrigin(),	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
            0,	-- int, order filter
            false	-- bool, can grow cache
    )

    for _,enemy in pairs(enemies) do
        self.damageTable.victim = enemy
        self.damageTable.damage = self.damageTable.damage + (enemy:GetMaxHealth() * (self.damageTable.ptc_dmg / 100))
        ApplyDamage( self.damageTable )
    end

    -- tick
    self.tick = self.tick+1
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_infinity_black_hole_thinker:IsAura() return true end
function modifier_infinity_black_hole_thinker:GetModifierAura() return "modifier_infinity_black_hole_debuff" end
function modifier_infinity_black_hole_thinker:GetAuraRadius() return self.radius end
function modifier_infinity_black_hole_thinker:GetAuraDuration() return 0.1 end
function modifier_infinity_black_hole_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_infinity_black_hole_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_infinity_black_hole_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_infinity_black_hole_thinker:AddEffects()
    -- Get Resources
    local particle_cast = "particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf"
    local sound_cast = "Hero_Enigma.BlackHole.Cast.Chasm"

    if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "enigma_singularity") == true then
        particle_cast = "particles/enigma/enigma_fundamental_of_gravity/enigma_black_hole_extr_hole.vpcf"
        sound_cast = "Enigma.Singularity_black_hole"
    end

    ScreenShake(self:GetParent():GetOrigin(), 100, 100, 6, 9999, 0, true)

    local effect_cast = ParticleManager:CreateParticle (particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() + Vector(0, 0, 64) )

    -- buff particle
    self:AddParticle(
            effect_cast,
            false,
            false,
            -1,
            false,
            false
    )

    -- Create Sound
    EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
modifier_infinity_black_hole_debuff = class({})

function modifier_infinity_black_hole_debuff:IsHidden() return false end
function modifier_infinity_black_hole_debuff:IsDebuff() return true end
function modifier_infinity_black_hole_debuff:IsStunDebuff() return true end
function modifier_infinity_black_hole_debuff:IsPurgable() return true end

function modifier_infinity_black_hole_debuff:OnCreated( kv )
    self.rate = 0.2
    self.rotate_speed = 0.25

    self.pull_speed = self:GetAbility():GetSpecialValueFor( "pull_speed" )

    if IsServer() then
        -- center
        self.center = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )

        -- apply motion controller
        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
    end
end

function modifier_infinity_black_hole_debuff:OnRefresh( kv )

end

function modifier_infinity_black_hole_debuff:OnRemoved()
end

function modifier_infinity_black_hole_debuff:OnDestroy()
    if IsServer() then
        -- motion compulsory interrupts
        self:GetParent():InterruptMotionControllers( true )
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_infinity_black_hole_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
    }

    return funcs
end

function modifier_infinity_black_hole_debuff:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

function modifier_infinity_black_hole_debuff:GetOverrideAnimationRate()
    return self.rate
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_infinity_black_hole_debuff:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_infinity_black_hole_debuff:UpdateHorizontalMotion( me, dt )
    -- get vector
    local target = self:GetParent():GetOrigin()-self.center
    target.z = 0

    -- reduce length by pull speed
    local targetL = target:Length2D()-self.pull_speed*dt


    -- rotate by rotate speed
    local targetN = target:Normalized()
    local deg = math.atan2( targetN.y, targetN.x )
    local targetN = Vector( math.cos(deg+self.rotate_speed*dt), math.sin(deg+self.rotate_speed*dt), 0 );

    self:GetParent():SetOrigin( self.center + targetN * targetL )
end

function modifier_infinity_black_hole_debuff:OnHorizontalMotionInterrupted()
    self:Destroy()
end


