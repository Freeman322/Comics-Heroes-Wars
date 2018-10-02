if cny_beast_ability == nil then cny_beast_ability = class({}) end

LinkLuaModifier ("modifier_cny_beast_ability", "abilities/cny_beast_ability.lua", LUA_MODIFIER_MOTION_NONE )

function cny_beast_ability:GetIntrinsicModifierName ()
    return "modifier_cny_beast_ability"
end

if modifier_cny_beast_ability == nil then modifier_cny_beast_ability = class({}) end

function modifier_cny_beast_ability:IsPurgable()
  return false
end

function modifier_cny_beast_ability:IsHidden()
  return true
end

function modifier_cny_beast_ability:OnCreated(table)
    if IsServer() then
        self:SetStackCount((GameRules:GetGameTime() / 60) * 1000)
    end
end

function modifier_cny_beast_ability:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function modifier_cny_beast_ability:GetModifierExtraHealthBonus( params )
    return self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_cny_beast_ability:GetModifierBaseAttack_BonusDamage( params )
    return self:GetStackCount() / 10
end