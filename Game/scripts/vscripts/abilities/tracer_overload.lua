LinkLuaModifier("modifier_tracer_overload", "abilities/tracer_overload.lua", 0)

tracer_overload = class ({})

function tracer_overload:OnSpellStart()
    if IsServer() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tracer_overload", nil)
    end
end

modifier_tracer_overload = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    IsDebuff = function() return false end,
    RemoveOnDeath = function() return true end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE, MODIFIER_EVENT_ON_ATTACK_LANDED} end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end
})

function modifier_tracer_overload:OnCreated()
    if IsServer() then
        self:SetStackCount(self:GetAbility():GetSpecialValueFor("attack_count"))
        EmitSoundOn("Hero_FacelessVoid.TimeWalk.Aeons", self:GetParent())
    end
end

function modifier_tracer_overload:GetModifierPreAttack_CriticalStrike(params)
    if params.target:IsAncient() or params.target:IsRealHero() then
        return self:GetAbility():GetSpecialValueFor("crit")
    end
end

function modifier_tracer_overload:OnAttackLanded(params)
    if params.attacker == self:GetParent() then
        if params.target:IsAncient() or params.target:IsRealHero() then
            self:DecrementStackCount()
            if self:GetStackCount() == 0 then self:Destroy() end
        end
    end
end

function modifier_tracer_overload:GetEffectName()
    if self:GetCaster():HasModifier("modifier_arcana") then return "particles/reverse_flash/reverse_flash_debuff.vpcf" end
    return "particles/hero_tracer/tracer_overload.vpcf"
end
