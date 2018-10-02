if modifier_legacy_of_blast_gold == nil then modifier_legacy_of_blast_gold = class({}) end

function modifier_legacy_of_blast_gold:IsHidden()
	return true
end

function modifier_legacy_of_blast_gold:IsPurgable()
	return false
end

function modifier_legacy_of_blast_gold:RemoveOnDeath()
	return false
end

function modifier_legacy_of_blast_gold:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }

    return funcs
end

function modifier_legacy_of_blast_gold:GetAttackSound( params )
    return "Hero_Sven.GreatCleave.ti7"
end
