LinkLuaModifier( "modifier_black_flash_tahion_field",  "abilities/black_flash_tahion_field.lua",LUA_MODIFIER_MOTION_NONE )

black_flash_tahion_field = class({})

function black_flash_tahion_field:GetIntrinsicModifierName()
   return "modifier_black_flash_tahion_field"
end


modifier_black_flash_tahion_field = class({})

function modifier_black_flash_tahion_field:IsHidden()
    return true
end

function modifier_black_flash_tahion_field:IsPurgable()
    return false
end

function modifier_black_flash_tahion_field:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS
    }

    return funcs
end

function modifier_black_flash_tahion_field:GetModifierCastRangeBonus(htable)
	return self:GetAbility():GetSpecialValueFor("bonus_range")
end

function black_flash_tahion_field:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

