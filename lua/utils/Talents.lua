--Class definition
if Talents == nil then
    Talents = {}
    Talents.__index = Talents
end

function Talents:OnTalentLearned(pID, talent)
    if IsServer() then
        self._hTalents = self._hTalents or {}

        local hero = PlayerResource:GetPlayer(pID):GetAssignedHero()
        if not hero then return end 

        self._hTalents[pID] = (self._hTalents[pID] or {}) self._hTalents[pID][talent] = hero:FindTalentValue(talent)

        CustomNetTables:SetTableValue("talents", "talents", self._hTalents)
    end 
end

function Talents:Init()
    if IsServer() then
        self._hTalents = self._hTalents or {}

        CustomNetTables:SetTableValue("talents", "talents", self._hTalents)
    end 
end

Talents:Init()