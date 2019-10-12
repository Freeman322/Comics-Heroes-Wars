pennywise_ballon_jump = class ( {})

function pennywise_ballon_jump:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end 
end

function pennywise_ballon_jump:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local point = self:GetCursorPosition()
       

        local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
        if #allies > 0 then
            for _,ally in pairs(allies) do
                if ally:GetUnitLabel() == "baloon_creature" then
                    self:GetCaster():SetAbsOrigin(ally:GetAbsOrigin())        
                    FindClearSpaceForUnit(self:GetCaster(), ally:GetAbsOrigin(), false)

                    EmitSoundOn("Hero_Visage.GraveChill.Cast", self:GetCaster())

                    break
                end
            end
        end
    end
end
