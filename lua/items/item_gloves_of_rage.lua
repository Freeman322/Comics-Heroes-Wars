LinkLuaModifier("modifier_item_gloves_of_rage", "items/item_gloves_of_rage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_gloves_of_rage_active", "items/item_gloves_of_rage.lua", LUA_MODIFIER_MOTION_NONE)
if item_gloves_of_rage == nil then
	item_gloves_of_rage = class({})
end

function item_gloves_of_rage:GetIntrinsicModifierName()
	return "modifier_item_gloves_of_rage"
end

function item_gloves_of_rage:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("berserk_duration")
	caster:AddNewModifier(caster, self, "modifier_item_gloves_of_rage_active", {duration = duration})
	EmitSoundOn("DOTA_Item.MaskOfMadness.Activate", caster)
end

if modifier_item_gloves_of_rage == nil then
	modifier_item_gloves_of_rage = class({})
end

function modifier_item_gloves_of_rage:IsHidden()
	return true
end

function modifier_item_gloves_of_rage:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
      }

    return funcs
end

function modifier_item_gloves_of_rage:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_gloves_of_rage:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_gloves_of_rage:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_gloves_of_rage:GetModifierMoveSpeedBonus_Constant( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("berserk_bonus_movement_speed" )
end

if modifier_item_gloves_of_rage_active == nil then
	modifier_item_gloves_of_rage_active = class({})
end

function modifier_item_gloves_of_rage_active:GetEffectName()
	return "particles/items2_fx/mask_of_madness.vpcf"
end

function modifier_item_gloves_of_rage_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_gloves_of_rage_active:IsBuff()
	return true
end

function modifier_item_gloves_of_rage_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function modifier_item_gloves_of_rage_active:GetModifierAttackSpeedBonus_Constant( params )
	local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("berserk_bonus_attack_speed" )
end

function modifier_item_gloves_of_rage_active:GetModifierIncomingDamage_Percentage( params )
	local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("berserk_extra_damage" )
end

function modifier_item_gloves_of_rage_active:GetModifierBaseDamageOutgoing_Percentage( params )
	local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("berserk_bonus_damage" )
end

function item_gloves_of_rage:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

