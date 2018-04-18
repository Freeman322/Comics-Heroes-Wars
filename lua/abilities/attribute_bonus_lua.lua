if attribute_bonus_lua == nil then attribute_bonus_lua = class({}) end

LinkLuaModifier("modifier_attribute_bonus_lua", "abilities/attribute_bonus_lua.lua", LUA_MODIFIER_MOTION_NONE) --- PATH WERY IMPORTANT

function attribute_bonus_lua:GetIntrinsicModifierName()
    return "modifier_attribute_bonus_lua"
end

function attribute_bonus_lua:OnUpgrade()
    if IsServer() then
        local level = self:GetLevel()
        if self:GetCaster():HasModifier("modifier_attribute_bonus_lua") then
            local modifier = self:GetCaster():FindModifierByName("modifier_attribute_bonus_lua")
            modifier:SetStackCount(level)
        end
    end
end
function attribute_bonus_lua:GetBehavior ()
    local behav = DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_HIDDEN
    return behav
end

if modifier_attribute_bonus_lua == nil then modifier_attribute_bonus_lua = class({}) end

function modifier_attribute_bonus_lua:IsHidden()
	return true
end

function modifier_attribute_bonus_lua:IsPurgable()
	return false
end

function modifier_attribute_bonus_lua:RemoveOnDeath()
	return false
end

function modifier_attribute_bonus_lua:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
	return funcs
end


function modifier_attribute_bonus_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_attribute_bonus_lua:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "attribute_bonus_all" )*self:GetStackCount()
end

function modifier_attribute_bonus_lua:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "attribute_bonus_all" )*self:GetStackCount()
end
function modifier_attribute_bonus_lua:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "attribute_bonus_all" )*self:GetStackCount()
end

function attribute_bonus_lua:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

