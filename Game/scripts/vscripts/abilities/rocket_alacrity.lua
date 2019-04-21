LinkLuaModifier ("modifier_rocket_alacrity", "abilities/rocket_alacrity.lua", LUA_MODIFIER_MOTION_NONE)

rocket_alacrity = class ( {})

function rocket_alacrity:OnSpellStart ()
    if IsServer() then 
        EmitSoundOn ("Hero_Invoker.Alacrity", self:GetCaster())

        local duration = self:GetSpecialValueFor("duration")
        self:GetCaster():AddNewModifier (self:GetCaster(), self, "modifier_rocket_alacrity", { duration = duration })
    end 
end

modifier_rocket_alacrity = class({})

function modifier_rocket_alacrity:IsPurgable(  )
  return false
end

function modifier_rocket_alacrity:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE 
	}

	return funcs
end

function modifier_rocket_alacrity:GetStatusEffectName()
    return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

function modifier_rocket_alacrity:StatusEffectPriority()
    return 1000
end

function modifier_rocket_alacrity:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_rocket_alacrity:GetModifierPreAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
