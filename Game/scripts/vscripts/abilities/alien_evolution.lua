LinkLuaModifier("modifier_alien_evolution", "abilities/alien_evolution.lua", 0)

alien_evolution = class({GetIntrinsicModifierName = function() return "modifier_alien_evolution" end})

function alien_evolution:GetCooldown(nLevel) return self.BaseClass.GetCooldown(self, nLevel) - (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_alien_evolution_cd_red") or 0) end
modifier_alien_evolution = class({IsHidden = function() return true end, IsPurgable = function() return false end, GetAttributes = function() return MODIFIER_ATTRIBUTE_PERMANENT end})

function modifier_alien_evolution:OnCreated() if not IsServer() then return end self:StartIntervalThink(FrameTime()) end
function modifier_alien_evolution:OnIntervalThink()
    if not IsServer() then return end
    if self:GetParent():IsRealHero() and self:GetAbility():IsCooldownReady() then
        self:GetCaster():ModifyStrength(self:GetAbility():GetSpecialValueFor("bonus_stats"))
        self:GetCaster():ModifyAgility(self:GetAbility():GetSpecialValueFor("bonus_stats"))
        self:GetCaster():ModifyIntellect(self:GetAbility():GetSpecialValueFor("bonus_stats"))

        EmitSoundOn("", self:GetCaster())

        self:GetAbility():EndCooldown()
        self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
    end
end
