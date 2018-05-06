black_panther_adamantium_armor = class ( {})

LinkLuaModifier ("modifier_black_panther_adamantium_armor", "abilities/black_panther_adamantium_armor.lua", LUA_MODIFIER_MOTION_NONE)

function black_panther_adamantium_armor:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE
    return behav
end

function black_panther_adamantium_armor:GetIntrinsicModifierName ()
    return "modifier_black_panther_adamantium_armor"
end

modifier_black_panther_adamantium_armor = class ( {})

function modifier_black_panther_adamantium_armor:IsBuff ()
    return true
end

function modifier_black_panther_adamantium_armor:IsHidden()
    return true
end

function modifier_black_panther_adamantium_armor:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
    }

    return funcs
end

function modifier_black_panther_adamantium_armor:GetModifierPhysical_ConstantBlock (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_block") + (self:GetParent():GetAgility()/3)
end


function modifier_black_panther_adamantium_armor:GetModifierPhysicalArmorBonus (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_armor")
end

function black_panther_adamantium_armor:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

