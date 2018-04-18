LinkLuaModifier("modifier_savitar_speedforce", "abilities/savitar_speedforce.lua", LUA_MODIFIER_MOTION_NONE)

if savitar_speedforce == nil then
    savitar_speedforce = class ( {})
end

function savitar_speedforce:GetIntrinsicModifierName()
    return "modifier_savitar_speedforce"
end

if modifier_savitar_speedforce == nil then
    modifier_savitar_speedforce = class ( {})
end

function modifier_savitar_speedforce:IsHidden ()
    return true
end

function modifier_savitar_speedforce:IsPurgable()
    return false
end

function modifier_savitar_speedforce:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }

    return funcs
end

function modifier_savitar_speedforce:GetModifierEvasion_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_evasion")
end
function modifier_savitar_speedforce:GetModifierMoveSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_speed")
end

function modifier_savitar_speedforce:GetModifierMoveSpeed_Limit (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("speed_border")
end

function modifier_savitar_speedforce:GetModifierMoveSpeed_Max (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("speed_border")
end

function savitar_speedforce:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

