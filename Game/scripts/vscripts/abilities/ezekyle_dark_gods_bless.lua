ezekyle_dark_gods_bless = class ( {})

LinkLuaModifier ("modifier_ezekyle_dark_gods_bless", "abilities/ezekyle_dark_gods_bless.lua", LUA_MODIFIER_MOTION_NONE)

function ezekyle_dark_gods_bless:GetIntrinsicModifierName ()
    return "modifier_ezekyle_dark_gods_bless"
end


function ezekyle_dark_gods_bless:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end


modifier_ezekyle_dark_gods_bless = class ( {})

function modifier_ezekyle_dark_gods_bless:DeclareFunctions () return { MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS } end
function modifier_ezekyle_dark_gods_bless:IsHidden() return false end
function modifier_ezekyle_dark_gods_bless:IsPurgable() return false end

function modifier_ezekyle_dark_gods_bless:OnCreated(params)
    if IsServer() then
        self:SetStackCount(1)

        local heroes = HeroList:GetAllHeroes()
        for _, hero in pairs(heroes) do
            if hero:GetTeamNumber() == self:GetParent():GetTeamNumber() then 
                if hero:GetUnitName() == "npc_dota_hero_queenofpain" or hero:GetUnitName() == "npc_dota_hero_leshrac" or hero:GetUnitName() == "npc_dota_hero_abaddon" or hero:GetUnitName() == "npc_dota_hero_disruptor" then 
                    self:IncrementStackCount()
                end 
            end 
        end

        if self:GetStackCount() == 1 then self:SetStackCount(0) end 
    end
end

function modifier_ezekyle_dark_gods_bless:GetModifierPhysicalArmorBonus()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("armor_per_min") * (math.floor( (GameRules:GetGameTime() / 60) ) or 1)
end
  
function modifier_ezekyle_dark_gods_bless:GetModifierBaseAttack_BonusDamage()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage_per_min") * (math.floor( (GameRules:GetGameTime() / 60) ) or 1)
end
  
