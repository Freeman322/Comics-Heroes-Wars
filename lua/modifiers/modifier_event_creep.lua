if not modifier_event_creep then modifier_event_creep = class({}) end

function modifier_event_creep:IsPurgable()
  return  false
end

function modifier_event_creep:CheckState()
	local state = {
	[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end
