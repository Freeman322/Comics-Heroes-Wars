if modifier_neo_noir == nil then modifier_neo_noir = class({}) end

function modifier_neo_noir:IsHidden()
	return true
end

function modifier_neo_noir:IsPurgable()
	return false
end

function modifier_neo_noir:RemoveOnDeath()
	return false
end

function modifier_neo_noir:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

    return funcs
end

function modifier_neo_noir:GetAttackSound( params )
    return "Hero_Juggernaut.Attack"
end

function modifier_neo_noir:GetModifierAttackRangeBonus( params )
    return -250
end

