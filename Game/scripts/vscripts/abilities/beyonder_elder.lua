LinkLuaModifier ("modifier_beyonder_maker_aura", "abilities/beyonder_elder.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_beyonder_maker_aura_passive", "abilities/beyonder_elder.lua", LUA_MODIFIER_MOTION_NONE)
 
 
if beyonder_elder == nil then beyonder_elder = class({}) end
 
function beyonder_elder:GetIntrinsicModifierName()
    return "modifier_beyonder_maker_aura"
end
 
if modifier_beyonder_maker_aura == nil then modifier_beyonder_maker_aura = class({}) end
 
function modifier_beyonder_maker_aura:IsAura()
    return true
end
 
function modifier_beyonder_maker_aura:IsHidden()
    return true
end
 
function modifier_beyonder_maker_aura:IsPurgable()
    return true
end
 
function modifier_beyonder_maker_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end
 
function modifier_beyonder_maker_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end
 
function modifier_beyonder_maker_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end
 
function modifier_beyonder_maker_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
 
function modifier_beyonder_maker_aura:GetModifierAura()
    return "modifier_beyonder_maker_aura_passive"
end
 
function modifier_beyonder_maker_aura:DeclareFunctions()
    return { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                         MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
                         MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE }
end
 
function modifier_beyonder_maker_aura:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_int") end
function modifier_beyonder_maker_aura:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_beyonder_maker_aura:GetModifierPercentageCooldown() return self:GetAbility():GetSpecialValueFor("bonus_cooldown") end
 
 
if modifier_beyonder_maker_aura_passive == nil then modifier_beyonder_maker_aura_passive = class({}) end
 
function modifier_beyonder_maker_aura_passive:IsDebuff()
    return self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber()
end
 
function modifier_beyonder_maker_aura_passive:IsPurgable(  )
    return false
end
 
function modifier_beyonder_maker_aura_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
 
    return funcs
end
 
function modifier_beyonder_maker_aura_passive:GetModifierMoveSpeedBonus_Percentage (params)
    if self:IsDebuff() then
        return self:GetAbility():GetSpecialValueFor ("bonus_movespeed") * (-1)
    end
    return self:GetAbility():GetSpecialValueFor ("bonus_movespeed")
end
 
function modifier_beyonder_maker_aura_passive:GetModifierConstantHealthRegen (params)
    if self:IsDebuff() then
        return self:GetAbility():GetSpecialValueFor ("bonus_hp_regen") * (-1)
    end
    return self:GetAbility():GetSpecialValueFor ("bonus_hp_regen")
end
 
function modifier_beyonder_maker_aura_passive:GetModifierHealthRegenPercentage(params)
    if self:IsDebuff() then
        return self:GetAbility():GetSpecialValueFor ("bonus_hp_regen_pct") * (-1)
    end
    return self:GetAbility():GetSpecialValueFor ("bonus_hp_regen_pct")
end