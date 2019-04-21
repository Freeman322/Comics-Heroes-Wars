if modifier_melee_attack == nil then modifier_melee_attack = class({}) end

function modifier_melee_attack:IsPurgable()
    return false
end

function modifier_melee_attack:RemoveOnDeath()
    return false
end

function modifier_melee_attack:IsHidden()
    return true
end


function modifier_melee_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_melee_attack:GetModifierAttackRangeBonus()
	return -650
end

function modifier_melee_attack:GetAttackSound()
    return "Hero_Slark.Attack"
end