if modifier_galactus_seed_of_ambition == nil then modifier_galactus_seed_of_ambition = class({}) end

function modifier_galactus_seed_of_ambition:IsHidden()
	return true
end

function modifier_galactus_seed_of_ambition:IsPurgable()
	return false
end

function modifier_galactus_seed_of_ambition:RemoveOnDeath()
	return false
end
