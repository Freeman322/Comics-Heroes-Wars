darkseid_omega_effect = class({})
LinkLuaModifier("modifier_darkseid_omega_effect", "abilities/darkseid_omega_effect.lua", LUA_MODIFIER_MOTION_NONE)

function darkseid_omega_effect:GetIntrinsicModifierName()
    return "modifier_darkseid_omega_effect"
end

if modifier_darkseid_omega_effect == nil then modifier_darkseid_omega_effect = class({}) end 

function modifier_darkseid_omega_effect:IsPurgable()
	return false
end

function modifier_darkseid_omega_effect:IsHidden()
    return true 
end

function modifier_darkseid_omega_effect:GetStatusEffectName()
	return "particles/units/heroes/hero_visage/status_effect_visage_chill_slow.vpcf"
end


function modifier_darkseid_omega_effect:StatusEffectPriority()
	return 1000
end


function modifier_darkseid_omega_effect:GetHeroEffectName()
	return "particles/units/heroes/hero_chaos_knight/chaos_knight_cast_hero_effect.vpcf"
end


function modifier_darkseid_omega_effect:HeroEffectPriority()
	return 100
end


function modifier_darkseid_omega_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end


function modifier_darkseid_omega_effect:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_resist")
end

function modifier_darkseid_omega_effect:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_move_speed_pct")
end
function darkseid_omega_effect:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

