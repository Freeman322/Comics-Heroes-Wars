--Class definition
if Think == nil then
    Think = {}
    Think.__index = Think
end

function Think:OnInit()
    GameRules:GetGameModeEntity():SetThink("OnIntervalThink", Think, 0.1)
end


function Think:OnIntervalThink()
    local heroes = HeroList:GetAllHeroes()
    for _, hero in pairs(heroes) do
        for i = 0, 7, 1 do
            local current_ability = self:GetCaster():GetAbilityByIndex(i)
            if current_ability ~= nil then
                print(current_ability:GetAbilityName())
                pcall(current_ability:Think())
            end
        end
    end
end