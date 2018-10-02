if modifier_dante == nil then modifier_dante = class({}) end


function modifier_dante:IsHidden()
	return true
end

function modifier_dante:IsPurgable()
	return false
end

function modifier_dante:RemoveOnDeath()
	return false
end
