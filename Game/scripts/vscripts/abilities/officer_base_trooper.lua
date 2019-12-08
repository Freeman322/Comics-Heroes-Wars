officer_base_trooper = class({})

local MAX_UNITS = 4

function officer_base_trooper:OnSpellStart( )
    if IsServer() then
        if self:GetCurrenUnits() < MAX_UNITS then
            PrecacheUnitByNameAsync("npc_dota_officer_trooper", function()
                local base = CreateUnitByName("npc_dota_officer_trooper", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
                base:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
                base:SetUnitCanRespawn(false)

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

function officer_base_trooper:GetParentAbilityLevel(base)
    return PlayerResource:GetSelectedHeroEntity(base:GetPlayerOwnerID()):FindAbilityByName("officer_base"):GetLevel()
end

function officer_base_trooper:GetCurrenUnits()
    return #Entities:FindAllByName("npc_dota_officer_trooper")
end