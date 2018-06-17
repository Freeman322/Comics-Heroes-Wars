LinkLuaModifier("modifier_murlock_pounce",          "abilities/murlock_pounce.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_murlock_pounce_tinker",   "abilities/murlock_pounce.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_murlock_pounce_modifier", "abilities/murlock_pounce.lua", LUA_MODIFIER_MOTION_NONE)

murlock_pounce = class({})

function murlock_pounce:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 5
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end


function murlock_pounce:OnSpellStart()
    local hero = self:GetCaster()
    EmitSoundOn("Hero_Slark.Pounce.Cast", hero)
    hero:AddNewModifier(hero, self, "modifier_slark_pounce", nil)
end

function murlock_pounce:GetPlaybackRateOverride()
    return 2
end

--[[[modifier_murlock_pounce = class({})

function modifier_murlock_pounce:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true
    }

    return state
end

function modifier_murlock_pounce:IsHidden()
    return true
end

function modifier_murlock_pounce:RemoveOnDeath()
    return false
end

function modifier_murlock_pounce:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
    }

    return funcs
end

function modifier_murlock_pounce:GetOverrideAnimation(params)
    return ACT_DOTA_FLAIL
end

function modifier_murlock_pounce:GetOverrideAnimationRate(params)
    return 2
end

function modifier_murlock_pounce:OnCreated( kv )
    if IsServer() then
        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
        abil = {}
        abil.leap_direction = self:GetParent():caster:GetForwardVector()
        abil.leap_distance = self:GetAbility():GetSpecialValueFor("pounce_distance")
        abil.leap_speed = self:GetAbility():GetSpecialValueFor("pounce_speed")/30
        abil.leap_traveled = 0
        abil.leap_z = 0
        self:StartIntervalThink(0.03)
        self:ApplyVerticalMotionController()
        self:ApplyHorizontalMotionController()
    end
end

function modifier_murlock_pounce:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("pounce_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        if units > 0 then
            for i = 1, #units do
                local target = units[1]
                if not vic:HasModifier("modifier_supernova_burn_datadriven") then
                    ability:ApplyDataDrivenModifier(caster, vic, "modifier_supernova_burn_datadriven", {duration = 0.5})
                end
                ApplyDamage({victim = vic, attacker = caster, damage = 1.5, damage_type = DAMAGE_TYPE_PURE})
            end
        end
    end
end

function modifier_murlock_pounce:UpdateHorizontalMotion( me, dt )
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()

        if abil.leap_traveled < abil.leap_distance then
            caster:SetAbsOrigin(caster:GetAbsOrigin() + abil.leap_direction * abil.leap_speed)
            abil.leap_traveled = abil.leap_traveled + abil.leap_speed
        else
            caster:InterruptMotionControllers(true)
        end
    end
end

function modifier_murlock_pounce:UpdateVerticalMotion( me, dt )
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()

        -- For the first half of the distance the unit goes up and for the second half it goes down
        if abil.leap_traveled < abil.leap_distance/2 then
            -- Go up
            -- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
            abil.leap_z = abil.leap_z + abil.leap_speed/2
            -- Set the new location to the current ground location + the memorized z point
            caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,abil.leap_z))
        else
            -- Go down
            abil.leap_z = abil.leap_z - abil.leap_speed/2
            caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,abil.leap_z))
        end
    end
end


--------------------------------------------------------------------------------
function modifier_murlock_pounce:OnHorizontalMotionInterrupted()
    if IsServer() then
        local caster = self:GetParent()
        self:Destroy()
    end
end]]

function murlock_pounce:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

