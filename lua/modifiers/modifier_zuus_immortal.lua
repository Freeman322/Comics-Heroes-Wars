if modifier_zuus_immortal == nil then modifier_zuus_immortal = class({}) end

function modifier_zuus_immortal:IsHidden()
	return true
end

function modifier_zuus_immortal:IsPurgable()
	return false
end

function modifier_zuus_immortal:RemoveOnDeath()
	return false
end
