local MANA_PERCENT = 5
local MANA_PER_CAST = 10

modifier_storm_spirit = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    IsDebuff = function() return false end,
    RemoveOnDeath = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_MANA_BONUS} end,
    GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end
})

function modifier_storm_spirit:OnAbilityFullyCast(params)
    if params.unit == self:GetParent() then
       self:IncrementStackCount()
    end
end

function modifier_storm_spirit:OnAttackLanded(params)
    if params.attacker == self:GetParent() and self:GetParent():HasModifier("modifier_storm_spirit_overload") then
        local damage = self:GetParent():GetMana() * (MANA_PERCENT / 100)

        ApplyDamage({
            victim = params.target,
            attacker = self:GetParent(),
            ability = self:GetAbility(),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL
        })

        print(damage)
    end
end

function modifier_storm_spirit:GetModifierManaBonus(params)
    return self:GetStackCount() * MANA_PER_CAST
end
