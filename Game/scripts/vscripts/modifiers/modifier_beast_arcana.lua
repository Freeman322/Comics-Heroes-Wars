if modifier_beast_arcana == nil then modifier_beast_arcana = class({}) end

function modifier_beast_arcana:IsHidden()
	return true
end

function modifier_beast_arcana:IsPurgable()
	return false
end

function modifier_beast_arcana:RemoveOnDeath()
	return false
end
