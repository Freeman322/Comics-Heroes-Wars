sauron_ancient_flame = class ( {})

LinkLuaModifier ("modifier_sauron_ancient_flame", "abilities/sauron_ancient_flame.lua", LUA_MODIFIER_MOTION_NONE)

function sauron_ancient_flame:GetIntrinsicModifierName ()
    return "modifier_sauron_ancient_flame"
end

modifier_sauron_ancient_flame = class ( {})

function modifier_sauron_ancient_flame:IsPurgable ()
    return false
end

function modifier_sauron_ancient_flame:IsHidden ()
    return true
end

function modifier_sauron_ancient_flame:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }

    return funcs
end


function modifier_sauron_ancient_flame:GetModifierEvasion_Constant (params)
    return self:GetAbility ():GetSpecialValueFor ("bonus_evasion")
end

function sauron_ancient_flame:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

