LinkLuaModifier("modifier_pudge_jab", "abilities/pudge_jab.lua", 0)

pudge_jab = class({GetIntrinsicModifierName = function() return "modifier_pudge_jab" end})

modifier_pudge_jab = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ORDER} end
})
function modifier_pudge_jab:OnCreated() self.jab = false end
function modifier_pudge_jab:OnAttackLanded(params)
    if not IsServer () then return end
    if params.attacker == self:GetParent() and self:GetParent():IsRealHero() and self:GetAbility():IsCooldownReady() and self:GetAbility():IsOwnersManaEnough() and (self:GetAbility():GetAutoCastState() or self.jab) and not (params.target:IsBuilding() or params.target:IsAncient()) then
        params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})

        self:GetAbility():UseResources(true, false, true)
        
        ApplyDamage ({ --Урон по Пуджу
                victim = self:GetParent(),
                attacker = self:GetParent(),
                ability = self:GetAbility(),
                damage = self:GetParent():GetHealth() * (self:GetAbility():GetSpecialValueFor("health_conversion") / 100),
                damage_type = self:GetAbility():GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL
            })
        ApplyDamage({ -- Урон по цели
            victim = params.target,
            attacker = self:GetParent(),
            ability = self:GetAbility(),
            damage = self:GetParent():GetHealth() * (self:GetAbility():GetSpecialValueFor("health_conversion") / 100),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
        })
        EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", self:GetParent())
        EmitSoundOn("Hero_DoomBringer.Attack.Impact", params.target)
        self.jab = false
    end
end

function modifier_pudge_jab:OnOrder(params)
    if params.unit == self:GetParent() then
        if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
            self.jab = true
        else
            self.jab = false
        end
    end
end
