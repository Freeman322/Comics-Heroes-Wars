officer_base_asassin = class({})

function officer_base_asassin:OnSpellStart( )
     if IsServer() then
          PrecacheUnitByNameAsync("npc_dota_officer_assassin", function()
               local base = CreateUnitByName("npc_dota_officer_assassin", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
               base:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
               base:SetUnitCanRespawn(false)

               SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_officer/hero/weapon.vmdl"}):FollowEntity(base, true)

               FindClearSpaceForUnit(base, self:GetCaster():GetAbsOrigin(), false)
          end)
     end
end
