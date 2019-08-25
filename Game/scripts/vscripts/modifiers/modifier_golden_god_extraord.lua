if modifier_golden_god_extraord == nil then modifier_golden_god_extraord = class({}) end 

function modifier_golden_god_extraord:IsPurgable()
	return false
end

function modifier_golden_god_extraord:RemoveOnDeath()
	return false
end

function modifier_golden_god_extraord:IsHidden()
	return true
end

function modifier_golden_god_extraord:GetEffectName()
	return "particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard_shield.vpcf"
end

function modifier_golden_god_extraord:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
