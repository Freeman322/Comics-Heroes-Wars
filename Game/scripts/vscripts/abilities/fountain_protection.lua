LinkLuaModifier("modifier_fountain_protection", "abilities/fountain_protection.lua", 0)
LinkLuaModifier("modifier_fountain_protection_aura", "abilities/fountain_protection.lua", 0)
LinkLuaModifier("modifier_fountain_death_delay", "abilities/fountain_protection.lua", 0)

local CONST_DAMAGE_OUTGOING_PTC = -100

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
function modifier_fountain_protection_aura:OnCreated() self:StartIntervalThink(FrameTime()) end
function modifier_fountain_protection_aura:OnIntervalThink() self:Check() end
function modifier_fountain_protection_aura:GetModifierTotalDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("damage_outgoing_pct") end

function modifier_fountain_protection_aura:Check()
    if IsServer() then
        if not self:GetParent():IsFriendly(self:GetCaster()) then
            if not self:GetParent():HasModifier("modifier_fountain_death_delay") then
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_fountain_death_delay", {duration = self:GetAbility():GetSpecialValueFor("death_delay") + 1.4})
            end
        end
    end
end


modifier_fountain_death_delay = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return true end,
    IsDebuff = function() return true end
})
function modifier_fountain_death_delay:OnCreated() self:StartIntervalThink(0.01) self.death = 0 self:OnIntervalThink() end
function modifier_fountain_death_delay:OnIntervalThink()
    if self:GetParent():HasModifier("modifier_fountain_protection_aura") == false then
        self:Destroy()
    end

    if IsServer() then
        if self:GetElapsedTime() > self:GetAbility():GetSpecialValueFor("death_delay") and self.death == 0 then
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = 1.4})
            local particle = ParticleManager:CreateParticle("particles/domino/domino_luck_attention_of_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 4, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 9, self:GetParent():GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(particle)
            self.death = 1

            EmitSoundOn("Hero_Necrolyte.ReapersScythe.Cast.ti7", self:GetParent())
            EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target", self:GetParent())
        end
    end
end
function modifier_fountain_death_delay:OnDestroy()
    if self.death == 1 then
        self:GetParent():ForceKill(false)
    end
    self.death = 0
end
