if not item_ice_pearl then item_ice_pearl = class({}) end 

LinkLuaModifier ("modifier_item_ice_pearl", "items/item_ice_pearl.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ice_pearl_reduction", "items/item_ice_pearl.lua", LUA_MODIFIER_MOTION_NONE)

function item_ice_pearl:GetIntrinsicModifierName()
    return "modifier_item_ice_pearl"
end

if modifier_item_ice_pearl == nil then
    modifier_item_ice_pearl = class({})
end

function modifier_item_ice_pearl:IsHidden()
    return true
end

function modifier_item_ice_pearl:IsPurgable()
    return false
end

function modifier_item_ice_pearl:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_item_ice_pearl:GetModifierPhysicalArmorBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_armor" )
end

function modifier_item_ice_pearl:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intellect" )
end

function modifier_item_ice_pearl:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            local damage = params.damage
            if self:GetParent() == target then 
                return
            end
            if target:IsBuilding() then
                return
            end 
            local amp = self:GetAbility():GetSpecialValueFor("damage_return") / 100
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_ice_pearl_reduction", {duration = self:GetAbility():GetSpecialValueFor("debuff_duration")})
            if self:GetAbility():IsCooldownReady() then 
            	EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Cast", target)
            	EmitSoundOn("Hero_Winter_Wyvern.ColdEmbrace.Cast", target)
            	local result = damage * amp

            	target:ModifyHealth(target:GetHealth() - damage, self:GetAbility(), true, 0)
            	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
            end
        end
    end
end

if modifier_item_ice_pearl_reduction == nil then
    modifier_item_ice_pearl_reduction = class ( {})
end

function modifier_item_ice_pearl_reduction:IsBuff ()
    return false
end

function modifier_item_ice_pearl_reduction:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }

    return funcs
end

function modifier_item_ice_pearl_reduction:GetStatusEffectName ()
    return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_item_ice_pearl_reduction:StatusEffectPriority ()
    return 1000
end

function modifier_item_ice_pearl_reduction:GetEffectName()
	return "particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_ice_pearl_reduction:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_item_ice_pearl_reduction:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("attack_speed_reduction")
end

function modifier_item_ice_pearl_reduction:GetModifierMoveSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("move_speed_reduction")
end

function item_ice_pearl:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

