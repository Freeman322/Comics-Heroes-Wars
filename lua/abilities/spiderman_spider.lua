LinkLuaModifier ("modifier_spiderman_spider", "abilities/spiderman_spider.lua", LUA_MODIFIER_MOTION_NONE)

if spiderman_spider == nil then
    spiderman_spider = class ( {})
end

function spiderman_spider:GetIntrinsicModifierName ()
    return "modifier_spiderman_spider"
end

if modifier_spiderman_spider == nil then
    modifier_spiderman_spider = class({})
end

function modifier_spiderman_spider:IsHidden()
    return true
end

function modifier_spiderman_spider:IsPurgable()
    return true
end

function modifier_spiderman_spider:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_spiderman_spider:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_agility" )
end

function modifier_spiderman_spider:GetModifierMoveSpeedBonus_Percentage( params )
    return self:GetAbility():GetSpecialValueFor ("absorb_chance" )
end

function spiderman_spider:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

