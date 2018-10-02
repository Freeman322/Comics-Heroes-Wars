if modifier_samurai_ancestors == nil then modifier_samurai_ancestors = class({}) end

function modifier_samurai_ancestors:IsHidden()
	return true
end

function modifier_samurai_ancestors:IsPurgable()
	return false
end

function modifier_samurai_ancestors:RemoveOnDeath()
	return false
end
