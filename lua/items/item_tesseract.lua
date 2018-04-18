LinkLuaModifier("modifier_tpdelay", "modifiers/modifier_tpdelay.lua",LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_item_tesseract", "items/item_tesseract.lua", LUA_MODIFIER_MOTION_NONE) 
if item_tesseract == nil then
    item_tesseract = class ( {})
end

function item_tesseract:GetIntrinsicModifierName()
    return "modifier_item_tesseract"
end

function item_tesseract:GetAOERadius()
    return 175
end
function item_tesseract:GetChannelTime()
    return 1.88
end

function item_tesseract:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

--------------------------------------------------------------------------------

function item_tesseract:CastFilterResultLocation (vLocation)
    if IsServer () then
        if self:GetCaster ():HasModifier ("modifier_fountain_aura_buff") then
            return UF_FAIL_CUSTOM
        else
            return UF_SUCCESS
        end
    end
end

--------------------------------------------------------------------------------

function item_tesseract:GetCustomCastErrorLocation (vLocation)
    if IsServer () then
        if self:GetCaster ():HasModifier ("modifier_fountain_aura_buff") then
            return "#dota_hud_error_cant_teleport_from_fountain"
        end
        return ""
    end
end
function item_tesseract:OnSpellStart ()
    EmitSoundOn ("Hero_Nevermore.ROS.Arcana.Cast", self:GetCaster ())
end
function item_tesseract:OnChannelFinish (bInterrupted)
    if not bInterrupted then
        local caster = self:GetCaster ()
        local ability = self
        local point1 = caster:GetAbsOrigin ()
        local point2 = caster:GetCursorPosition ()
        local id = caster:GetPlayerID ()
        EmitSoundOn ("Hero_Magnataur.ReversePolarity.Cast", self:GetCaster ())

        local tpparticlefrom1 = ParticleManager:CreateParticle ("particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl (tpparticlefrom1, 0, point1)
        local tpparticlefrom2 = ParticleManager:CreateParticle ("particles/units/heroes/hero_enigma/enigma_blackhole_n.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl (tpparticlefrom2, 0, point1)
        ParticleManager:SetParticleControl (tpparticlefrom2, 1, point1)
        local tpparticlefrom3 = ParticleManager:CreateParticle ("particles/econ/events/nexon_hero_compendium_2014/teleport_start_counter_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl (tpparticlefrom3, 0, point1)
        ParticleManager:SetParticleControl (tpparticlefrom3, 2, point1)
        ParticleManager:SetParticleControl (tpparticlefrom3, 3, point1)
        ParticleManager:SetParticleControl (tpparticlefrom3, 4, point1)
        ParticleManager:SetParticleControl (tpparticlefrom3, 5, point1)
        ParticleManager:SetParticleControl (tpparticlefrom3, 6, point1)


        local tpparticleto1 = ParticleManager:CreateParticle ("particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl (tpparticleto1, 0, point2)
        local tpparticleto2 = ParticleManager:CreateParticle ("particles/units/heroes/hero_enigma/enigma_blackhole_n.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl (tpparticleto2, 0, point2)
        ParticleManager:SetParticleControl (tpparticleto2, 1, point2)
        local tpparticleto3 = ParticleManager:CreateParticle ("particles/econ/events/nexon_hero_compendium_2014/teleport_start_counter_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl (tpparticleto3, 0, point2)
        ParticleManager:SetParticleControl (tpparticleto3, 2, point2)
        ParticleManager:SetParticleControl (tpparticleto3, 3, point2)
        ParticleManager:SetParticleControl (tpparticleto3, 4, point2)
        ParticleManager:SetParticleControl (tpparticleto3, 5, point2)
        ParticleManager:SetParticleControl (tpparticleto3, 6, point2)

        local duration = 0
        Timers:CreateTimer (function ()
            local passengers1to2 = FindUnitsInRadius (caster:GetTeamNumber (), point1, nil, 175, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for i=1, #passengers1to2 do
                if not passengers1to2[i]:HasModifier ("modifier_tpdelay") then
                    passengers1to2[i]:StartGesture (ACT_DOTA_TELEPORT_END)
                    passengers1to2[i]:AddNewModifier (nil, ability, "modifier_tpdelay", { duration = 3 })
                    ParticleManager:CreateParticle ("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_POINT_FOLLOW, passengers1to2[i])
                    passengers1to2[i]:SetAbsOrigin (point2)
                    FindClearSpaceForUnit (passengers1to2[i], point2, true)
                    passengers1to2[i]:Stop ()

                    PlayerResource:SetCameraTarget (passengers1to2[i]:GetPlayerOwnerID (), passengers1to2[i])
                    Timers:CreateTimer (0.1, function ()
                        PlayerResource:SetCameraTarget (passengers1to2[i]:GetPlayerOwnerID (), nil)
                    end)
                end
            end

            local passengers2to1 = FindUnitsInRadius (caster:GetTeamNumber (), point2, nil, 175, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for i=1, #passengers2to1 do
                if not passengers2to1[i]:HasModifier ("modifier_tpdelay") then
                    passengers2to1[i]:StartGesture (ACT_DOTA_TELEPORT_END)
                    passengers2to1[i]:AddNewModifier (nil, ability, "modifier_tpdelay", { duration = 3 })
                    ParticleManager:CreateParticle ("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_POINT_FOLLOW, passengers2to1[i])
                    passengers2to1[i]:SetAbsOrigin (point1)
                    FindClearSpaceForUnit (passengers2to1[i], point1, true)
                    passengers2to1[i]:Stop ()

                    PlayerResource:SetCameraTarget (passengers2to1[i]:GetPlayerOwnerID (), passengers2to1[i])
                    Timers:CreateTimer (0.1, function ()
                        PlayerResource:SetCameraTarget (passengers2to1[i]:GetPlayerOwnerID (), nil)
                    end)
                end
            end

            duration = duration + 0.1
            if duration < 10 then
                return 0.1
            else
                ParticleManager:DestroyParticle (tpparticlefrom1, false)
                ParticleManager:DestroyParticle (tpparticlefrom2, false)
                ParticleManager:DestroyParticle (tpparticlefrom3, false)
                ParticleManager:DestroyParticle (tpparticleto1, false)
                ParticleManager:DestroyParticle (tpparticleto2, false)
                ParticleManager:DestroyParticle (tpparticleto3, false)
                return nil
            end
        end)
    end
end

if modifier_item_tesseract == nil then
    modifier_item_tesseract = class ( {})
end
function modifier_item_tesseract:IsHidden ()
    return true 
end

function modifier_item_tesseract:DeclareFunctions () 
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

function modifier_item_tesseract:GetModifierConstantManaRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen_cons")
end

function modifier_item_tesseract:GetModifierHealthBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health")
end
function modifier_item_tesseract:GetModifierManaBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_mana")
end

function item_tesseract:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

