LinkLuaModifier ("modifier_genos_acceleration", "abilities/genos_acceleration.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

genos_acceleration = class ( {})

function genos_acceleration:GetAOERadius() return self:GetSpecialValueFor("radius") end
function genos_acceleration:GetBehavior ()  return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT end

function genos_acceleration:OnSpellStart ()
    if IsServer () then
        self:GetCaster():AddNewModifier (self:GetCaster(), self, "modifier_genos_acceleration", nil)
        EmitSoundOn ("Ability.Leap", self:GetCaster())
    end
end

modifier_genos_acceleration = class ( {})

function modifier_genos_acceleration:IsDebuff ()
    return false
end

function modifier_genos_acceleration:OnCreated ()
    if IsServer() then
        local caster = self:GetCaster ()
        ProjectileManager:ProjectileDodge (caster)
        self.target = caster:GetCursorPosition()
        -- Ability variables
        self.leap_direction = (self.target - caster:GetAbsOrigin()):Normalized()
        self.leap_distance = (self.target - caster:GetAbsOrigin()):Length2D()
        self.leap_speed = 1600/30
        self.leap_traveled = 0
        self.leap_z = 0
        
        self:StartIntervalThink(FrameTime())
    end
end


function modifier_genos_acceleration:RemoveOnDeath()
    return false
end

function modifier_genos_acceleration:GetEffectName()
    return "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_leap.vpcf"
end

function modifier_genos_acceleration:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_genos_acceleration:IsHidden()
    return true
end

function modifier_genos_acceleration:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end


function modifier_genos_acceleration:GetOverrideAnimation (params)
    return ACT_DOTA_CAST_ABILITY_1
end


function modifier_genos_acceleration:CheckState ()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }

    return state
end


function modifier_genos_acceleration:OnIntervalThink()
    if IsServer () then
        local caster = self:GetParent()
        local ability = self:GetAbility()

        if self.leap_traveled < self.leap_distance then
            caster:SetAbsOrigin (caster:GetAbsOrigin () + self.leap_direction * self.leap_speed)
            self.leap_traveled = self.leap_traveled + self.leap_speed
        else
            self:OnMotionInterrupted()
        end
    end
end

function modifier_genos_acceleration:OnMotionInterrupted()
    if IsServer () then
        local nearby_units = FindUnitsInRadius (self:GetCaster():GetTeam (), self:GetCaster():GetAbsOrigin (), nil, self:GetAbility():GetSpecialValueFor("radius"),  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, taget in ipairs (nearby_units) do  
            local duration = self:GetAbility():GetSpecialValueFor ("slow_duration")
            local damage = self:GetAbility():GetSpecialValueFor("damage")

            taget:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_huskar_burning_spear_debuff", { duration = duration })
            taget:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_huskar_life_break_slow", { duration = duration })

            ApplyDamage ({ attacker = self:GetAbility():GetCaster(), victim = taget, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
        end
       
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/fire/mk_arcana_fire_spring_cast_ringouterpnts.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.Totem", self:GetCaster() )
        FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

        self:Destroy()
    end
end

function modifier_genos_acceleration:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

