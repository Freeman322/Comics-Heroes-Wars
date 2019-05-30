LinkLuaModifier( "modifier_ragnaros_shine_soul", "abilities/ragnaros_shine_soul.lua", 0)
LinkLuaModifier ("modifier_ragnaros_shine_soul_passive", "abilities/ragnaros_shine_soul.lua", 0)

ragnaros_shine_soul = class({GetIntrinsicModifierName = function() return "modifier_ragnaros_shine_soul" end})

modifier_ragnaros_shine_soul = class({
    IsHidden = function() return true end,
    IsAura = function() return true end,
    IsPurgable = function() return false end,
    GetModifierAura = function() return "modifier_ragnaros_shine_soul_passive" end
})

function modifier_ragnaros_shine_soul:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_ragnaros_shine_soul:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function modifier_ragnaros_shine_soul:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function modifier_ragnaros_shine_soul:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end

modifier_ragnaros_shine_soul_passive = class({
    IsPurgable = function() return true end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
    GetEffectName = function() return "particles/items2_fx/radiance.vpcf" end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end
})

function modifier_ragnaros_shine_soul_passive:OnCreated() if IsServer() then self:StartIntervalThink(1) end end
function modifier_ragnaros_shine_soul_passive:OnIntervalThink()
    if self:GetCaster():IsRealHero() then
        local damage = self:GetAbility():GetSpecialValueFor("aura_damage") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_ragnaros") or 0)

        self:GetCaster():Heal(damage * (self:GetAbility():GetSpecialValueFor("bonus_vampirism") / 100), self:GetAbility())

        local lifesteal_fx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(lifesteal_fx)

        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility()
        })
    end
end

function modifier_ragnaros_shine_soul_passive:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("aura_slowing") end
