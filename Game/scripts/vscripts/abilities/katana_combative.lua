katana_combative = class({})

LinkLuaModifier( "modifier_katana_combative", "abilities/katana_combative.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function katana_combative:GetIntrinsicModifierName()
    return "modifier_katana_combative"
end

modifier_katana_combative = class({})

function modifier_katana_combative:IsHidden()
    return false
end

function modifier_katana_combative:IsPurgable()
    return false
end

function modifier_katana_combative:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end


function modifier_katana_combative:GetModifierMoveSpeedBonus_Percentage( params )
    return self:GetAbility():GetSpecialValueFor("bonus_attackspeed")
end

--------------------------------------------------------------------------------

function modifier_katana_combative:GetModifierAttackSpeedBonus_Constant( params )
    return self:GetAbility():GetSpecialValueFor("bonus_speed")
end

function katana_combative:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

