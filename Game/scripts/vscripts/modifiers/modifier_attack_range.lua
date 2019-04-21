if modifier_attack_range == nil then
	modifier_attack_range = class({})
end

function modifier_attack_range:IsHidden()
	return true
end

function modifier_attack_range:IsPurgable()
	return false
end

function modifier_attack_range:GetEffectName()
    return "particles/hw_fx/cursed_rapier.vpcf"
end

function modifier_attack_range:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_attack_range:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
	return funcs
end

function modifier_attack_range:GetModifierAttackRangeBonus()
	return 500
end




