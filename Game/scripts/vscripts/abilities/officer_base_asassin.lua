officer_base_asassin = class({})

local MAX_UNITS = 2

function officer_base_asassin:OnSpellStart( )
    if IsServer() then
        print(self:GetCurrenUnits())
        if self:GetCurrenUnits() < MAX_UNITS then
            PrecacheUnitByNameAsync("npc_dota_officer_assassin", function()
                local base = CreateUnitByName("npc_dota_officer_assassin", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
                base:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
                base:SetUnitCanRespawn(false)

                SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_officer/hero/weapon.vmdl"}):FollowEntity(base, true)

                local level = self:GetParentAbilityLevel(base)

                local bonus = 0

                if self:GetCaster().m_hOwner:HasTalent("special_bonus_unique_officer_2") then
                    bonus = base:GetMaxHealth() * 0.07
                end 

                base:CreatureLevelUp(level)
                base:SetBaseHealthRegen(level * 6 + bonus)
                base:SetBaseAttackTime(1.7 / level)
                
                FindClearSpaceForUnit(base, self:GetCaster():GetAbsOrigin(), false)
            end)
        end
     end
end


function officer_base_asassin:GetParentAbilityLevel(base)
    return PlayerResource:GetSelectedHeroEntity(base:GetPlayerOwnerID()):FindAbilityByName("officer_base"):GetLevel()
end

function officer_base_asassin:GetCurrenUnits()
    return #Entities:FindAllByName("npc_dota_officer_assassin")
end