if officer_fallback == nil then officer_fallback = class({}) end

function officer_fallback:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

 
local UNITS = {}

UNITS["npc_dota_officer_trooper"] = true
UNITS["npc_dota_officer_assault"] = true
UNITS["npc_dota_officer_assassin"] = true

--------------------------------------------------------------------------------

function officer_fallback:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function officer_fallback:OnAbilityPhaseStart()
	if IsServer() then
		
	end

	return true
end

function officer_fallback:OnSpellStart( )
     if IsServer() then
          Timers:CreateTimer(self:GetSpecialValueFor("duration"), function()
               local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), EF_GLOBAL, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
               if #units > 0 then
                    for _,unit in pairs(units) do
                         if UNITS[unit:GetUnitName()] then
                              unit:SetAbsOrigin(unit:GetBasePos())

                              FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
                         end 
                    end
               end
          end)
     end
end
