oblivion_creatures = class({})

function oblivion_creatures:OnSpellStart()
    for count = 1, self:GetSpecialValueFor("count") do
        local unit = CreateUnitByName("npc_dota_warlock_golem_2", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeam())
        unit:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
        unit:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self:GetSpecialValueFor("life_time")})
        FindClearSpaceForUnit(unit, self:GetCursorPosition(), true)

        for ability_id = 0, 15 do
            local ability = unit:GetAbilityByIndex(ability_id)
            if ability then
                ability:SetLevel(self:GetLevel() - 1)
            end
        end
    end
    EmitSoundOn("Hero_Enigma.Malefice", self:GetCaster())
end
