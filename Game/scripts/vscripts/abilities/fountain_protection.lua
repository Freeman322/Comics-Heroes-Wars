LinkLuaModifier("modifier_fountain_protection", "abilities/fountain_protection.lua", 0)
LinkLuaModifier("modifier_fountain_protection_aura", "abilities/fountain_protection.lua", 0)
LinkLuaModifier("modifier_fountain_death_delay", "abilities/fountain_protection.lua", 0)

local CONST_DAMAGE_OUTGOING_PTC = -100
local CONST_DELAY = 2.5
local CONST_DELAY_STOP = -1

fountain_protection = class({
    GetIntrinsicModifierName = function() return "modifier_fountain_protection" end
})

modifier_fountain_protection = class({
    IsHidden = function() return true end,
    IsAura = function() return true end,
    IsPurgable = function() return false end,
    GetAuraSearchTeam = function() return DOTA_UNIT_TARGET_TEAM_BOTH end,
    GetAuraSearchType = function() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
    GetAuraSearchFlags = function() return 16 + 64 + 262144 end,
    GetModifierAura = function() return "modifier_fountain_protection_aura" end
})

function modifier_fountain_protection:GetAuraRadius() if self:GetParent():GetTeam() == DOTA_TEAM_BADGUYS then return 1350 end return 1200 end

modifier_fountain_protection_aura = class({
    DeclareFunctions = function() return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE} end,
    GetEffectName = function() return "particles/econ/events/ti5/radiant_fountain_regen_lvl2_ti5.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end
})

function modifier_fountain_protection_aura:OnCreated() 
    if IsServer() and not self:GetParent():IsFriendly(self:GetCaster()) then
        self:StartIntervalThink(CONST_DELAY)
    end 
end

function modifier_fountain_protection_aura:GetModifierTotalDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("damage_outgoing_pct") end

function modifier_fountain_protection_aura:OnIntervalThink() 
    if IsServer() then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = 1.4})
            
        local particle = ParticleManager:CreateParticle("particles/domino/domino_luck_attention_of_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 4, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 9, self:GetParent():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)

        EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast.ti7", self:GetParent())
        EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target", self:GetParent())

        self:GetParent():Kill(self:GetAbility(), self:GetCaster())

        self:StartIntervalThink(CONST_DELAY_STOP)
    end
end

