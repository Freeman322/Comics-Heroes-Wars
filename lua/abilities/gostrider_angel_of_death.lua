LinkLuaModifier ("modifier_gostrider_angel_of_death_stun",          "abilities/gostrider_angel_of_death.lua", LUA_MODIFIER_MOTION_NONE)
if gostrider_angel_of_death == nil then gostrider_angel_of_death = class({}) end

--------------------------------------------------------------------------------

function gostrider_angel_of_death:OnSpellStart()
    if IsServer() then
        local info = {
                EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf",
                Ability = self,
                iMoveSpeed = self:GetSpecialValueFor( "arrow_speed" ),
                Source = self:GetCaster(),
                Target = self:GetCursorTarget(),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
            }

        ProjectileManager:CreateTrackingProjectile( info )
        EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
    end
end

--------------------------------------------------------------------------------

function gostrider_angel_of_death:OnProjectileHit( hTarget, vLocation )
    if IsServer() then 
        if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
            EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )
            
            local caster = self:GetCaster()
            local target = hTarget
            local ability = self
            local ability_level = ability:GetLevel()

            -- Ability variables
            local stun_duration_long = ability:GetSpecialValueFor("stun_duration")
            local stun_duration_fail = ability:GetSpecialValueFor("fail_stun_duration")
            local shackle_distance = ability:GetSpecialValueFor("shackle_distance")

            -- Calculate the valid positions
            local caster_location = caster:GetAbsOrigin()
            local target_point = target:GetAbsOrigin()

            local shackle_vector = (target_point - caster_location)
            local shackle_vector_range = Util:vector_unit(shackle_vector) * shackle_distance

            local cone_left = RotatePosition(Vector(0,0,0), QAngle(0, -13, 0), shackle_vector_range)
            local cone_right = RotatePosition(Vector(0,0,0), QAngle(0, 13, 0), shackle_vector_range)

            -- Find valid units
            local units = FindUnitsInRadius(caster:GetTeamNumber(),
                                    target:GetAbsOrigin(),
                                    nil,
                                    shackle_distance,
                                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                                    DOTA_UNIT_TARGET_ALL,
                                    DOTA_UNIT_TARGET_FLAG_NONE,
                                    FIND_ANY_ORDER,
                                    false)

            -- Choose a valid target if possible
            local latch_target = nil
            for k,unit in pairs(units) do
                local unit_vector = unit:GetAbsOrigin() - target_point

                if (not Util:vector_is_clockwise(cone_left, unit_vector)) and Util:vector_is_clockwise(cone_right, unit_vector) then
                    if latch_target == nil then
                        latch_target = unit
                        break
                    end
                end
            end

            -- If a valid target has been found then create the particle, apply the stun to both targets and fire the sound effect
            if latch_target ~= nil then
                latch = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, caster)

                ParticleManager:SetParticleControlEnt(latch, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(latch, 1, latch_target, PATTACH_POINT, "attach_hitloc", latch_target:GetAbsOrigin(), true)
                ParticleManager:SetParticleControl(latch, 2, Vector(stun_duration_long,0,0))

                target:AddNewModifier(caster, self, "modifier_gostrider_angel_of_death_stun", {duration = stun_duration_long})
                latch_target:AddNewModifier(caster, self, "modifier_gostrider_angel_of_death_stun", {duration = stun_duration_long})

                EmitSoundOn("Hero_Windrunner.ShackleshotBind", target)
            else
                -- Otherwise repeat the same steps and try to find a valid tree for latching
                local latch_tree = nil
                local trees = GridNav:GetAllTreesAroundPoint(target:GetAbsOrigin(), shackle_distance, false)

                for _,tree in pairs(trees) do
                    local tree_vector = tree:GetAbsOrigin() - target_point

                    if (not Util:vector_is_clockwise(cone_left, tree_vector)) and Util:vector_is_clockwise(cone_right, tree_vector) then

                        if latch_tree == nil then
                            latch_tree = tree
                            break
                        end
                    end
                end

                -- If a valid tree has been found then do the particle, stun and sound functions
                if latch_tree then
                    latch = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, caster)

                    ParticleManager:SetParticleControlEnt(latch, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
                    ParticleManager:SetParticleControl(latch, 1, latch_tree:GetAbsOrigin() + Vector(0,0,128))
                    ParticleManager:SetParticleControl(latch, 2, Vector(stun_duration_long,0,0))

                    target:AddNewModifier(caster, self, "modifier_gostrider_angel_of_death_stun", {duration = stun_duration_long})

                    EmitSoundOn("Hero_Windrunner.ShackleshotBind", target)
                else
                    -- If no valid tree nor unit was found for latching then apply the short stun duration and play the failure sound
                    target:AddNewModifier(caster, self, "modifier_gostrider_angel_of_death_stun", {duration = stun_duration_fail})

                    EmitSoundOn("Hero_Windrunner.ShackleshotStun", target)
                end
            end
        end
    end

	return true
end

if modifier_gostrider_angel_of_death_stun == nil then modifier_gostrider_angel_of_death_stun = class({}) end 

function modifier_gostrider_angel_of_death_stun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_gostrider_angel_of_death_stun:GetOverrideAnimation( params )
    return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_gostrider_angel_of_death_stun:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end
-----------------------------------------------------------------
function modifier_gostrider_angel_of_death_stun:GetEffectName()
    return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf"
end

function modifier_gostrider_angel_of_death_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
