LinkLuaModifier("modifier_bane_overdose", "abilities/bane_overdose.lua", 0)

bane_overdose = class({IsStealable = function() return false end})

function bane_overdose:OnSpellStart()
    if IsServer() then
        if self:GetCaster():FindModifierByName("modifier_charges"):GetStackCount() > 1 then
            for charges = 1, self:GetCaster():FindModifierByName("modifier_charges"):GetStackCount() - 1 do
                self:GetCaster():FindAbilityByName("bane_venom"):OnSpellStart()
            end
            self:GetCaster():CastAbilityNoTarget(self:GetCaster():FindAbilityByName("bane_venom"), -1)
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bane_overdose", {duration = self:GetCaster():FindAbilityByName("bane_venom"):GetSpecialValueFor("duration")})
            self:GetCaster():FindModifierByName("modifier_charges"):SetStackCount(0)
        end
    end
end

modifier_bane_overdose = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end,
    CheckState = function() return {[MODIFIER_STATE_SILENCED] = true} end
})

function modifier_bane_overdose:GetModifierIncomingDamage_Percentage() return self:GetAbility():GetSpecialValueFor("damage_reduction") * -1 end
function modifier_bane_overdose:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_bane_overdose:OnCreated() if IsServer() then self:StartIntervalThink(FrameTime()) end end
function modifier_bane_overdose:OnIntervalThink() self:GetCaster():Purge(false , true, false, true, true) end
