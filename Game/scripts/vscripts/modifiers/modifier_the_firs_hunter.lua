if modifier_the_firs_hunter == nil then modifier_the_firs_hunter = class({}) end


function modifier_the_firs_hunter:IsHidden()
	return true
end

function modifier_the_firs_hunter:IsPurgable()
	return false
end

function modifier_the_firs_hunter:RemoveOnDeath()
	return false
end
