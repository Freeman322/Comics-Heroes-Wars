officer_base_trooper = class({})

function officer_base_trooper:OnSpellStart( )
     if IsServer() then
          PrecacheUnitByNameAsync("npc_dota_officer_trooper", function()
               local base = CreateUnitByName("npc_dota_officer_trooper", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
               base:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
               base:SetUnitCanRespawn(false)

               FindClearSpaceForUnit(base, self:GetCaster():GetAbsOrigin(), false)
          end)
     end
end
