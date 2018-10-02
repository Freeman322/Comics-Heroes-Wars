if not modifier_batman_infinity_gauntlet then modifier_batman_infinity_gauntlet = class({}) end 

function modifier_batman_infinity_gauntlet:IsHidden()
	return true
end

function modifier_batman_infinity_gauntlet:IsPurgable()
	return false
end

function modifier_batman_infinity_gauntlet:RemoveOnDeath()
	return false
end
