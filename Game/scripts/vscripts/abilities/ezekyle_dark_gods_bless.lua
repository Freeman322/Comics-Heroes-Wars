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

function modifier_ezekyle_dark_gods_bless:DeclareFunctions () return { MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE } end
function modifier_ezekyle_dark_gods_bless:IsHidden() return false end
function modifier_ezekyle_dark_gods_bless:IsPurgable() return false end
function modifier_ezekyle_dark_gods_bless:RemoveOnDeath() return false end

function modifier_ezekyle_dark_gods_bless:OnCreated(params)
    if IsServer() then
        self:SetStackCount(0)

        local heroes = HeroList:GetAllHeroes()
        for _, hero in pairs(heroes) do
            if hero:GetTeamNumber() == self:GetParent():GetTeamNumber() and hero:IsRealHero() then 
                if hero:GetUnitName() == "npc_dota_hero_queenofpain" or hero:GetUnitName() == "npc_dota_hero_leshrac" or hero:GetUnitName() == "npc_dota_hero_abaddon" or hero:GetUnitName() == "npc_dota_hero_disruptor" then 
                    self:IncrementStackCount()
                end 
            end 
        end

        self:StartIntervalThink(1)
    end
end

function modifier_ezekyle_dark_gods_bless:OnIntervalThink()
    if IsServer() then
        self:OnCreated(params)
    end
end

function modifier_ezekyle_dark_gods_bless:OnRefresh(params)
    if IsServer() then
        self:OnCreated(params)
    end
end

function modifier_ezekyle_dark_gods_bless:GetModifierSpellAmplify_Percentage()
    return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("spell_per_min") * (GameRules:GetGameTime() / 60)
end
  
