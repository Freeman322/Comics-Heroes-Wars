LinkLuaModifier("modifier_bane_venom", "abilities/bane_venom.lua", 0)
LinkLuaModifier("modifier_charges", "modifiers/modifier_charges.lua", 0)

bane_venom = class({IsStealable = function() return false end})

function bane_venom:OnUpgrade()
    if not self:GetCaster():HasModifier("modifier_charges") then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_charges", nil)
    end
end

function bane_venom:OnSpellStart()
    if IsServer() then
        local count = #(self:GetCaster():FindAllModifiersByName("modifier_bane_venom"))
        print(count)
        if count < self:GetSpecialValueFor("max_charges") then
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bane_venom", {duration = self:GetSpecialValueFor("duration")})
        end
    end
end

modifier_bane_venom = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_HEALTH_BONUS} end,
    GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_bane_venom:GetModifierIncomingDamage_Percentage() return self:GetAbility():GetSpecialValueFor("damage_reduction_per_stack") * -1 end
function modifier_bane_venom:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("strength_bonus_per_stack") end
function modifier_bane_venom:GetModifierMoveSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("movespeed_per_stack") end
function modifier_bane_venom:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("attack_speed_per_stack") end
function modifier_bane_venom:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("health_per_stack") end
