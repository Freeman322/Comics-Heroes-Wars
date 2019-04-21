if marvel_jinada == nil then marvel_jinada = class({}) end
LinkLuaModifier("modifier_marvel_jinada", "abilities/marvel_jinada.lua", LUA_MODIFIER_MOTION_NONE)

function marvel_jinada:GetIntrinsicModifierName()
	return "modifier_marvel_jinada"
end

if modifier_marvel_jinada == nil then modifier_marvel_jinada = class({}) end

function modifier_marvel_jinada:IsHidden()
	return true
end

function modifier_marvel_jinada:IsPurgable()
	return false
end


function modifier_marvel_jinada:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
    }

    return funcs
end

function modifier_marvel_jinada:GetModifierProcAttack_BonusDamage_Magical (params)
    return self:GetAbility():GetSpecialValueFor("damage")
end

function marvel_jinada:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

