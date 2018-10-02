if modifier_doomsday_clock == nil then modifier_doomsday_clock = class({}) end

function modifier_doomsday_clock:IsHidden()
	return false
end

function modifier_doomsday_clock:IsPurgable()
	return false
end

function modifier_doomsday_clock:RemoveOnDeath()
	return false
end
