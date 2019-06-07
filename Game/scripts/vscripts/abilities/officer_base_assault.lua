officer_base_assault = class({})

function officer_base_assault:OnSpellStart( )
     if IsServer() then
          PrecacheUnitByNameAsync("npc_dota_officer_assault", function()
               local base = CreateUnitByName("npc_dota_officer_assault", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
               base:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
               base:SetUnitCanRespawn(false)

               SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_officer/hero/weapon.vmdl"}):FollowEntity(base, true)

               FindClearSpaceForUnit(base, self:GetCaster():GetAbsOrigin(), false)
          end)
     end
end
