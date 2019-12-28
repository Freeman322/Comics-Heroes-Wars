officer_base_assault = class({})

local MAX_UNITS = 2

officer_base_assault.m_hUnits = {}

function officer_base_assault:OnSpellStart( )
    if IsServer() then
        if self:GetCurrenUnits() < MAX_UNITS then
            PrecacheUnitByNameAsync("npc_dota_officer_assault", function()
                local base = CreateUnitByName("npc_dota_officer_assault", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
                base:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
                base:SetUnitCanRespawn(false)

                SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/hero_officer/hero/weapon.vmdl"}):FollowEntity(base, true)

                local level = self:GetParentAbilityLevel(base)

                local bonus = 0

                if self:GetCaster().m_hOwner:HasTalent("special_bonus_unique_officer_2") then
                    bonus = base:GetMaxHealth() * 0.07
                end 

                table.insert( self.m_hUnits, base )

                base:CreatureLevelUp(level)
                base:SetBaseHealthRegen(level * 6 + bonus)
                base:SetBaseAttackTime(1.7 / level)
                
                FindClearSpaceForUnit(base, self:GetCaster():GetAbsOrigin(), false)
            end)
        end
     end
end

function officer_base_assault:GetParentAbilityLevel(base)
    return PlayerResource:GetSelectedHeroEntity(base:GetPlayerOwnerID()):FindAbilityByName("officer_base"):GetLevel()
end

function officer_base_assault:GetCurrenUnits()
    local i = 0

    for k,v in pairs(self.m_hUnits) do
        if v and not v:IsNull() and v:IsAlive() then
            i = i + 1
        end 
    end

    return i
end