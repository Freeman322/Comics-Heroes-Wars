LinkLuaModifier( "modifier_wolverine_mastery", "abilities/wolverine_mastery.lua", LUA_MODIFIER_MOTION_NONE )

wolverine_mastery = class({})

function wolverine_mastery:GetIntrinsicModifierName() return "modifier_wolverine_mastery" end

modifier_wolverine_mastery = class ( {})

function modifier_wolverine_mastery:IsHidden() return true end
function modifier_wolverine_mastery:IsPurgable() return false end

function modifier_wolverine_mastery:DeclareFunctions()
    return    {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
               MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
               MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
               MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}
end

function modifier_wolverine_mastery:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("bonus_hp_regen") end
function modifier_wolverine_mastery:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_as") end
function modifier_wolverine_mastery:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_wolverine_mastery:GetModifierPreAttack_CriticalStrike(params)
    if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
        return self:GetAbility():GetSpecialValueFor("bonus_damage")
    end
    return
end