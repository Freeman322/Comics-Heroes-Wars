LinkLuaModifier( "modifier_ghost_rider_punishing_gaze_lua", "abilities/ghost_rider_punishing_gaze_lua.lua",LUA_MODIFIER_MOTION_NONE )

ghost_rider_punishing_gaze_lua = class ({})

function ghost_rider_punishing_gaze_lua:GetAOERadius()
    if self:GetCaster():HasScepter() then
        return self:GetSpecialValueFor("aoe_scepter")
    end

    return 0
end

function ghost_rider_punishing_gaze_lua:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arcana") then
		return "custom/ghost_rider_pg_arcana"
	end
	return "custom/ghost_rider_spell"
end

function ghost_rider_punishing_gaze_lua:GetBehavior()
    if self:GetCaster():HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
    end
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function ghost_rider_punishing_gaze_lua:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function ghost_rider_punishing_gaze_lua:OnSpellStart()
    local hTarget = self:GetCursorTarget()
    if hTarget ~= nil then
        local particleStnd = "particles/death_eye.vpcf"
        local agh = "particles/hero_ghost_rider/ghost_rider_punishing_gaze_agh.vpcf"
        if self:GetCaster():HasModifier("modifier_arcana") then
          particleStnd = "particles/econ/events/ti7/dagon_ti7.vpcf"
          agh = "particles/hero_ghost_rider/ghost_rider_punishing_gaze_agh_arcana.vpcf"
        end
        if self:GetCaster():HasScepter() then
            local victim = hTarget
            local caster = self:GetCaster()
            local damage = _G.PunishingGazeTable[victim] or 0

            local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), self:GetCaster(), self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
            if #targets > 0 then
                for _,target in pairs(targets) do

                    target:ModifyHealth(target:GetHealth() - damage, self, true, 0)

                    local explosion = ParticleManager:CreateParticle(particleStnd, PATTACH_WORLDORIGIN, caster)
                    ParticleManager:SetParticleControl(explosion, 0, caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(explosion, 1, target:GetAbsOrigin())
                    ParticleManager:SetParticleControl(explosion, 3, caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(explosion, 5, caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(explosion, 9, caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(explosion, 13, Vector(1, 1, 1))
                    ParticleManager:ReleaseParticleIndex( explosion );

                    local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
                    local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, target )

                    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                    ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

                    -- Show the particle target-> caster
                    local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
                    local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )

                    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

                    target:AddNewModifier( self:GetCaster(), self, "modifier_ghost_rider_punishing_gaze_lua", { duration = 2 } )

                    EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Target", target )
                    EmitSoundOn("Hero_Terrorblade.Sunder.Cast", target)
                    EmitSoundOn("Hero_Terrorblade.Sunder.Target", target)

                    if _G.PunishingGazeTable[target] then
                        _G.PunishingGazeTable[target] = 0
                    end
                end
            end
            EmitGlobalSound("terrorblade_terr_kill_05")
            local nFXIndex = ParticleManager:CreateParticle( agh, PATTACH_WORLDORIGIN, self:GetCaster() )
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
            ParticleManager:SetParticleControl(nFXIndex, 1, Vector(400, 400, 0))
            ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetCursorPosition() )
            ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetCursorPosition() )
            ParticleManager:SetParticleControl( nFXIndex, 5, self:GetCaster():GetCursorPosition() )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
        else
            local victim = hTarget
            local caster = self:GetCaster()
            local damage = _G.PunishingGazeTable[victim] or 0

            victim:ModifyHealth(victim:GetHealth() - damage, self, true, 0)

            ScreenShake( caster:GetOrigin(), 600, 600, 2, 9999, 0, true)
            local explosion = ParticleManager:CreateParticle(particleStnd, PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(explosion, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(explosion, 1, victim:GetAbsOrigin())
            ParticleManager:SetParticleControl(explosion, 3, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(explosion, 5, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(explosion, 9, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(explosion, 13, Vector(1, 1, 1))

            local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
            local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, victim )

            ParticleManager:SetParticleControlEnt(particle, 0, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)

            -- Show the particle target-> caster
            local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
            local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )

            ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(particle, 1, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAbsOrigin(), true)
            EmitGlobalSound("terrorblade_terr_kill_05")
            victim:AddNewModifier( self:GetCaster(), self, "modifier_ghost_rider_punishing_gaze_lua", { duration = 2 } )
            EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Target", victim )
            EmitSoundOn("Hero_Terrorblade.Sunder.Cast", victim)
            EmitSoundOn("Hero_Terrorblade.Sunder.Target", victim)
            if _G.PunishingGazeTable[victim] then
                _G.PunishingGazeTable[victim] = 0
            end
        end
    end
end


modifier_ghost_rider_punishing_gaze_lua = class ({})

function modifier_ghost_rider_punishing_gaze_lua:GetStatusEffectName()
    return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end

function modifier_ghost_rider_punishing_gaze_lua:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

    return funcs
end

function modifier_ghost_rider_punishing_gaze_lua:GetModifierMoveSpeedBonus_Percentage( event )
    return -500
end

function modifier_ghost_rider_punishing_gaze_lua:IsHidden()
    return true
end

function modifier_ghost_rider_punishing_gaze_lua:IsDebuff()
    return true
end

function modifier_ghost_rider_punishing_gaze_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
