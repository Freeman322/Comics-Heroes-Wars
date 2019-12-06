LinkLuaModifier("modifier_galactus_echo_jump", "abilities/galactus_echo_jump.lua", LUA_MODIFIER_MOTION_NONE)

galactus_echo_jump = class({})

function galactus_echo_jump:GetCastRange( vLocation, hTarget )
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor( "cast_range_scepter" )
    end

    return self:GetSpecialValueFor( "cast_range_tooltip" )
end

function galactus_echo_jump:GetAOERadius()
    return self:GetSpecialValueFor( "aoe_radius" )
end

function galactus_echo_jump:OnSpellStart()
    local hero = self:GetCaster()
    local target = self:GetCursorPosition()
    hero:EmitSound("Hero_EarthShaker.EchoSlamSmall")
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
    --ParticleManager:SetParticleControl( nFXIndex, 1, Vector( hAbility:GetSpecialValueFor( "aftershock_range" ), 1, 1 ) )
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 500, 1, 1 ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    hero:AddNewModifier(hero, self, "modifier_galactus_echo_jump", nil)
end

function galactus_echo_jump:GetPlaybackRateOverride()
    return 2
end

modifier_galactus_echo_jump = class({})

function modifier_galactus_echo_jump:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true
    }

    return state
end

function modifier_galactus_echo_jump:IsHidden()
    return true
end

function modifier_galactus_echo_jump:RemoveOnDeath()
    return false
end

function modifier_galactus_echo_jump:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
    }

    return funcs
end

function modifier_galactus_echo_jump:GetOverrideAnimation(params)
    return ACT_DOTA_FLAIL
end

function modifier_galactus_echo_jump:GetOverrideAnimationRate(params)
    return 2
end

function modifier_galactus_echo_jump:OnCreated( kv )
    if IsServer() then
        abil = {}
        abil.leap_direction = (self:GetParent():GetCursorPosition() - self:GetParent():GetAbsOrigin()):Normalized()
        abil.leap_distance = (self:GetParent():GetCursorPosition() - self:GetParent():GetAbsOrigin()):Length2D()
        abil.leap_speed = 1900/30
        abil.leap_traveled = 0
        abil.leap_z = 0
    
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_galactus_echo_jump:OnIntervalThink()
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

        if abil.leap_traveled < abil.leap_distance then
            caster:SetAbsOrigin(caster:GetAbsOrigin() + abil.leap_direction * abil.leap_speed)
            abil.leap_traveled = abil.leap_traveled + abil.leap_speed
        else
            self:OnMotionInterrupted()
        end
    end
end


--------------------------------------------------------------------------------
function modifier_galactus_echo_jump:OnMotionInterrupted()
    if IsServer() then
        local caster = self:GetParent()
        if caster:HasScepter() then
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", PATTACH_WORLDORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
            local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("aoe_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
            caster:EmitSound("PudgeWarsClassic.echo_slam")
            if #enemies > 0 then
                EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.EchoSlam", self:GetCaster() )
                ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 2*#enemies, 1, 1 ) )
                for _,hTarget in pairs(enemies) do
                    if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
                        hTarget:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
                       
                        local damage = {
                            victim = hTarget,
                            attacker = self:GetCaster(),
                            damage = self:GetAbility():GetAbilityDamage() + (#enemies*self:GetAbility():GetSpecialValueFor("damage_per_unit_scepter")),
                            damage_type = self:GetAbility():GetAbilityDamageType(),
                            ability = self
                        }
                        ApplyDamage( damage )
                    end
                end
            else
                EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.EchoSlamSmall", self:GetCaster() )
                ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 1, 1 ) )
            end
            ParticleManager:ReleaseParticleIndex( nFXIndex )
        else
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", PATTACH_WORLDORIGIN, nil )
            local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("aoe_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
            EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.EchoSlam", self:GetCaster() )
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 2*#enemies, 1, 1 ) )
            
            for _,hTarget in pairs(enemies) do
                if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
                    hTarget:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
                    
                    local damage = {
                        victim = hTarget,
                        attacker = self:GetCaster(),
                        damage = self:GetAbility():GetAbilityDamage(),
                        damage_type = self:GetAbility():GetAbilityDamageType(),
                        ability = self
                    }

                    ApplyDamage( damage )
                end
            end
        end

        FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
        
        self:Destroy()
    end
end


function galactus_echo_jump:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

