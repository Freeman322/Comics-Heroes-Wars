LinkLuaModifier("modifier_flash_speedforce_regeneration", "abilities/flash_speedforce_regeneration.lua", 0)
LinkLuaModifier("modifier_flash_speedforce_regeneration_regen", "abilities/flash_speedforce_regeneration.lua", 0)

flash_speedforce_regeneration = class({
    GetIntrinsicModifierName = function() return "modifier_flash_speedforce_regeneration" end
})

modifier_flash_speedforce_regeneration = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    IsDebuff = function() return false end,
    RemoveOnDeath = function() return false end
})

function modifier_flash_speedforce_regeneration:OnCreated() self:StartIntervalThink(FrameTime()) end
function modifier_flash_speedforce_regeneration:OnIntervalThink()
    if IsServer() then
        if self:GetAbility():IsCooldownReady() and self:GetCaster():GetHealthPercent() < self:GetAbility():GetSpecialValueFor("min_health_pct") and self:GetCaster():PassivesDisabled() == false and self:GetParent():IsRealHero() then
            self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_flash_speedforce_regeneration_regen", {duration = self:GetAbility():GetSpecialValueFor("duration")})
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
        end
    end
end

modifier_flash_speedforce_regeneration_regen = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    IsDebuff = function() return false end
})

function modifier_flash_speedforce_regeneration_regen:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE} end
function modifier_flash_speedforce_regeneration_regen:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("health_regen") end
function modifier_flash_speedforce_regeneration_regen:GetModifierHealthRegenPercentage() return self:GetAbility():GetSpecialValueFor("health_regen_pct") end
