if modifier_daredevil_arcana == nil then modifier_daredevil_arcana = class({}) end

function modifier_daredevil_arcana:IsHidden()
	return true
end

function modifier_daredevil_arcana:IsPurgable()
	return false
end

function modifier_daredevil_arcana:RemoveOnDeath()
	return false
end