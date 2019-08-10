LinkLuaModifier("modifier_alien_bite", "abilities/alien_bite.lua", 0)
LinkLuaModifier("modifier_alien_bite_debuff", "abilities/alien_bite.lua", 0)

alien_bite = class({GetIntrinsicModifierName = function() return "modifier_alien_bite" end})
modifier_alien_bite = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE, MODIFIER_EVENT_ON_ORDER} end
})

function modifier_alien_bite:OnCreated() self.bite = false end

function modifier_alien_bite:OnAttackLanded(params)
    if not IsServer() then return end
    if (self:GetAbility():GetAutoCastState() or self.bite) and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and params.attacker == self:GetParent() and self:GetParent():IsRealHero() and (params.target:IsBuilding() or params.target:IsMagicImmune() or params.target:IsOther()) == false then
        EmitSoundOn("", self:GetCaster())

        self:GetCaster():Heal(params.damage, self:GetParent())
        params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alien_bite_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
        self:GetAbility():PayManaCost()
        self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
        self.bite = false
    end
end

function modifier_alien_bite:GetModifierPreAttack_CriticalStrike()
    if (self:GetAbility():GetAutoCastState() or self.bite) and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and params.attacker == self:GetParent() and self:GetParent():IsRealHero() and (params.target:IsBuilding() or params.target:IsMagicImmune() or params.target:IsOther()) == false then
        return self:GetAbility():GetSpecialValueFor("crit_damage") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_alien_bite_crit_damage") or 0)
    end
end

function modifier_alien_bite:OnOrder(params)
    if params.unit == self:GetParent() then
        if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
            self.bite = true
        else
            self.bite = false
        end
    end
end

modifier_alien_bite_debuff = class({
    IsHidden = function() return false end,
    IsPurgable = function() return true end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
})
function modifier_alien_bite_debuff:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor("ms_slow_pct") * -1 end
function modifier_alien_bite_debuff:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("as_slow") * -1 end
