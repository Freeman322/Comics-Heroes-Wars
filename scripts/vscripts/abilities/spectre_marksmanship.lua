if spectre_marksmanship == nil then spectre_marksmanship = class({}) end

LinkLuaModifier ("modifier_spectre_marksmanship", "abilities/spectre_marksmanship.lua", LUA_MODIFIER_MOTION_NONE )

function spectre_marksmanship:GetIntrinsicModifierName ()
    return "modifier_spectre_marksmanship"
end

if modifier_spectre_marksmanship == nil then
    modifier_spectre_marksmanship = class ( {})
end

function modifier_spectre_marksmanship:IsHidden ()
    return true
end

function modifier_spectre_marksmanship:IsPurgable()
    return false
end

function modifier_spectre_marksmanship:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS
    }

    return funcs
end

function modifier_spectre_marksmanship:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_spectre_marksmanship:GetModifierBonusStats_Agility(params)
    return self:GetAbility():GetSpecialValueFor("marksmanship_agility_bonus")
end
