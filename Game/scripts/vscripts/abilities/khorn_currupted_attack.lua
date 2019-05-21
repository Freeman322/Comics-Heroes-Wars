LinkLuaModifier ("modifier_khorn_currupted_attack", "abilities/khorn_currupted_attack.lua", 0)

khorn_currupted_attack = class({
    GetIntrinsicModifierName = function() return "modifier_khorn_currupted_attack" end
})

modifier_khorn_currupted_attack = class({
    IsHidden = function() return true end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end
})

function modifier_khorn_currupted_attack:GetModifierPreAttack_CriticalStrike(params)
	if RollPercentage(self:GetAbility():GetSpecialValueFor("chance")) then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
	return
end
function modifier_khorn_currupted_attack:GetModifierTotalDamageOutgoing_Percentage(params)
	return self:GetAbility():GetSpecialValueFor("bonus_magical_damage")
end
