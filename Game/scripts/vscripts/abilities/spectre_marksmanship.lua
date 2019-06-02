LinkLuaModifier("modifier_spectre_marksmanship", "abilities/spectre_marksmanship.lua", 0)
spectre_marksmanship = class({
    GetIntrinsicModifierName = function() return "modifier_spectre_marksmanship" end
})

modifier_spectre_marksmanship = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end
})

function modifier_spectre_marksmanship:OnTakeDamage(params)
    if params.unit == self:GetParent() and self:GetParent():PassivesDisabled() == false and self:GetParent():IsRealHero() and self:GetAbility():IsCooldownReady() then
        if RollPercentage(self:GetAbility():GetSpecialValueFor("dodge_chance")) then
            if params.attacker:IsRealHero() then
                self:GetParent():ModifyAgility(self:GetAbility():GetSpecialValueFor("bonus_agility"))
            end
            self:GetParent():ModifyHealth(self:GetParent():GetHealth() + params.damage, self:GetAbility(), false, 0)

            self:GetAbility():UseResources(false, false, true)
        end
    end
    self:GetParent():CalculateStatBonus()
end
