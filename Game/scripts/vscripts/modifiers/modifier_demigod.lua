if modifier_demigod == nil then
	modifier_demigod = class({})
end

function modifier_demigod:IsHidden()
	return true
end

function modifier_demigod:IsPurgable()
	return false
end

function modifier_demigod:GetEffectName()
    return "particles/hw_fx/cursed_rapier.vpcf"
end

function modifier_demigod:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_demigod:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS
    }
	return funcs
end

function modifier_demigod:GetModifierSpellAmplify_Percentage()
	return 100
end

function modifier_demigod:GetModifierPercentageCooldown()
	return -100
end

function modifier_demigod:GetModifierPercentageCasttime()
	return -100
end

function modifier_demigod:GetModifierPercentageManacost()
	return -100
end

function modifier_demigod:GetModifierAttackRangeBonus()
	return 99999
end

function modifier_demigod:GetModifierCastRangeBonus()
	return 15000
end




