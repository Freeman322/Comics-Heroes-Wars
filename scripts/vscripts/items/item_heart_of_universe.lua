LinkLuaModifier( "item_heart_of_universe_modifier", "items/item_heart_of_universe.lua", LUA_MODIFIER_MOTION_NONE )
if item_heart_of_universe == nil then
	item_heart_of_universe = class({})
end
function item_heart_of_universe:GetIntrinsicModifierName()
	return "item_heart_of_universe_modifier"
end

function item_heart_of_universe:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_NO_TARGET
	return behav
end

function item_heart_of_universe:OnSpellStart()
	if IsServer() then
        local caster = self:GetCaster()
        EmitSoundOn("Hero_Oracle.FalsePromise.Cast", caster)
        EmitSoundOn("Hero_Oracle.FalsePromise.Target", caster)
        local duration = self:GetSpecialValueFor("duration")
        caster:AddNewModifier( self:GetCaster(), self, "modifier_oracle_false_promise", { duration = duration } )
        caster:AddNewModifier( self:GetCaster(), self, "modifier_oracle_false_promise_timer", { duration = duration } )
    end
end
--------------------------------------------------------------------------------
if item_heart_of_universe_modifier == nil then
    item_heart_of_universe_modifier = class({})
end

function item_heart_of_universe_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_heart_of_universe_modifier:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}

return funcs
end

function item_heart_of_universe_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_heart_of_universe_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_heart_of_universe_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_heart_of_universe_modifier:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_armor" )
end

function item_heart_of_universe_modifier:GetModifierAttackSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_attack_speed" )
end

function item_heart_of_universe_modifier:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function item_heart_of_universe:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

