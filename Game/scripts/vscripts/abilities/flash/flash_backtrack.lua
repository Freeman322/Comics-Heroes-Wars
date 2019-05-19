LinkLuaModifier("modifier_flash_backtrack", "abilities/flash/flash_backtrack.lua", 0)
LinkLuaModifier("modifier_flash_double_attack", "abilities/flash/flash_backtrack.lua", 0)

flash_backtrack = class({
    GetIntrinsicModifierName = function() return "modifier_flash_backtrack" end
})

modifier_flash_backtrack = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    IsDebuff = function() return false end
})

function modifier_flash_backtrack:OnCreated()
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_faceless_void_backtrack", {dodge_chance_pct = self:GetAbility():GetSpecialValueFor("dodge_chance_pct")})
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_flash_double_attack", nil)
end

modifier_flash_double_attack = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
})

function modifier_flash_double_attack:OnAttackLanded(params)
    if params.attacker == self:GetParent() and params.attacker:PassivesDisabled() == false and params.target:IsMagicImmune() == false and RollPercentage(self:GetAbility():GetSpecialValueFor("double_attack_chance")) then
        self:GetCaster():PerformAttack(params.target, true, false, false, false, false, false, false)
        EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", params.target)
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)
    end
end
