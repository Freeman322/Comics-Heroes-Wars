LinkLuaModifier( "savitar_quantum_tunnel_thinker", "abilities/savitar_quantum_tunnel.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "savitar_quantum_tunnel_modifier", "abilities/savitar_quantum_tunnel.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
local vTp1
local vTp2

savitar_quantum_tunnel = class ( {})

function savitar_quantum_tunnel:IsStealable()
    return false
end

function savitar_quantum_tunnel:IsRefreshable()
    return false
end

function savitar_quantum_tunnel:OnSpellStart()
    local caster = self:GetCaster()
    vTp1 = caster:GetCursorPosition()
    vTp2 = caster:GetAbsOrigin()

    local team_id = caster:GetTeamNumber()
    local thinker1 = CreateModifierThinker(caster, self, "savitar_quantum_tunnel_thinker", {duration = self:GetSpecialValueFor("duration")}, vTp1, team_id, false)
    local thinker2 = CreateModifierThinker(caster, self, "savitar_quantum_tunnel_thinker", {duration = self:GetSpecialValueFor("duration")}, vTp2, team_id, false)
end

savitar_quantum_tunnel_modifier = class ( {})

function savitar_quantum_tunnel_modifier:IsDebuff ()
    return true
end

function savitar_quantum_tunnel_modifier:IsHidden()
    return true
end

function savitar_quantum_tunnel_modifier:IsPurgable()
    return false
end

savitar_quantum_tunnel_thinker = class ({})

function savitar_quantum_tunnel_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()

        self.radius = ability:GetSpecialValueFor("radius")
        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_savitar/savitar_portal_b.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, thinker:GetAbsOrigin() + Vector(0, 0, 146))
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(170, 170, 0))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(170, 170, 0))
        ParticleManager:SetParticleControl( nFXIndex, 3, thinker:GetAbsOrigin() + Vector(0, 0, 96))
        ParticleManager:SetParticleControl( nFXIndex, 6, Vector(170, 170, 0))
        ParticleManager:SetParticleControl( nFXIndex, 15, Vector(170, 170, 0))
        ParticleManager:SetParticleControl( nFXIndex, 16, Vector(170, 170, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("Hero_Puck.Dream_Coil", thinker)
        EmitSoundOn("Hero_Puck.Dream_Coil", thinker)

        AddFOWViewer( thinker:GetTeam(), thinker:GetAbsOrigin(), 500, 5, false)
        GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 500, false)

        self:StartIntervalThink(0.1)
    end
end

function savitar_quantum_tunnel_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function savitar_quantum_tunnel_thinker:OnIntervalThink()
     if IsServer() then
        local distination
        if self:GetParent():GetAbsOrigin() == vTp1 then
            distination = vTp2
        else
            distination = vTp1
        end
        local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
        if units ~= nil then
            if #units > 0 then
                for _, unit in pairs(units) do
                    local target = unit
                    if not target:HasModifier("savitar_quantum_tunnel_modifier") then
                        EmitSoundOn("Hero_Puck.EtherealJaunt", target)
                        target:SetAbsOrigin(distination)
                        FindClearSpaceForUnit(target, distination, false)
                        PlayerResource:SetCameraTarget(target:GetPlayerOwnerID(), target)
                        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "savitar_quantum_tunnel_modifier", {duration = 2})
                        PlayerResource:SetCameraTarget(target:GetPlayerOwnerID(), nil)
                    end
                end
            end
        end
     end
end

function savitar_quantum_tunnel:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

