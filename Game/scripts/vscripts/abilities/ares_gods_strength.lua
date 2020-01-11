LinkLuaModifier ("modifier_ares_gods_strength", "abilities/ares_gods_strength.lua", LUA_MODIFIER_MOTION_NONE)

if ares_gods_strength == nil then ares_gods_strength = class({})  end

function ares_gods_strength:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_izanagi") then return "custom/ares_gods_strength_izanagi" end
    return self.BaseClass.GetAbilityTextureName(self)
end

function ares_gods_strength:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function ares_gods_strength:GetIntrinsicModifierName ()
    return "modifier_ares_gods_strength"
end

if modifier_ares_gods_strength == nil then modifier_ares_gods_strength = class({}) end

function modifier_ares_gods_strength:IsHidden()
    return true
end

function modifier_ares_gods_strength:IsPurgable()
	return false
end

function modifier_ares_gods_strength:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_ares_gods_strength:OnCreated(params)
    if IsServer() then
      self:StartIntervalThink(1)
    end
end

function modifier_ares_gods_strength:OnIntervalThink()
    if IsServer() then
      self:SetStackCount(math.floor(self:GetParent():GetHealthDeficit()*(self:GetAbility():GetSpecialValueFor("damage_bonus") / 100)))
    end
end

function modifier_ares_gods_strength:GetModifierPreAttack_BonusDamage (params)
    return self:GetStackCount()
end
