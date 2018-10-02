if modifier_thor_sulfuras == nil then modifier_thor_sulfuras = class({}) end


function modifier_thor_sulfuras:IsHidden()
	return true
end

function modifier_thor_sulfuras:IsPurgable()
	return false
end

function modifier_thor_sulfuras:RemoveOnDeath()
	return false
end
