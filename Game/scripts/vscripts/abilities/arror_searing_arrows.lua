LinkLuaModifier("modifier_arror_searing_arrows_target", "abilities/arror_searing_arrows.lua", 0)
LinkLuaModifier("modifier_arror_searing_arrows", "abilities/arror_searing_arrows.lua", 0)

arror_searing_arrows = class({GetIntrinsicModifierName = function() return "modifier_arror_searing_arrows" end})

modifier_arror_searing_arrows = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ORDER} end
})
function modifier_arror_searing_arrows:OnCreated() self.arrow = false end
function modifier_arror_searing_arrows:OnAttackLanded (params)
    if not IsServer() then return end
    if params.attacker == self:GetParent() and self:GetParent():IsRealHero() and (self:GetAbility():GetAutoCastState() or self.arrow) and self:GetAbility():IsOwnersManaEnough() and not (params.target:IsBuilding() or params.target:IsMagicImmune() or params.target:IsOther()) then
        if not params.target:HasModifier("modifier_arror_searing_arrows_target") then
            params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_arror_searing_arrows_target", {duration = 10}):IncrementStackCount()
        end

        local mod = params.target:FindModifierByName("modifier_arror_searing_arrows_target")
        local stacks = mod:GetStackCount()

        if PlayerResource:GetSteamAccountID(self:GetCaster():GetPlayerOwnerID()) ~= 77291876 then stacks = 1 end

        ApplyDamage({
            victim = params.target,
            attacker = self:GetCaster(),
            ability = self:GetAbility(),
            damage = self:GetAbility():GetSpecialValueFor("damage_bonus") * stacks,
            damage_type = DAMAGE_TYPE_PHYSICAL
        })

        mod:IncrementStackCount()
        self:GetAbility():PayManaCost()

        EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", params.target)
        EmitSoundOn("Hero_DoomBringer.Attack.Impact", params.target)
        self.arrow = false
    end
end

function modifier_arror_searing_arrows:OnOrder(params)
    if params.unit == self:GetParent() then
        if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
            self.arrow = true
        else
            self.arrow = false
        end
    end
end
modifier_arror_searing_arrows_target = class({
    IsHidden = function() return false end,
    IsPurgable = function() return false end,
    RemoveOnDeath = function() return false end,
    DestroyOnExpire = function() return true end
})
