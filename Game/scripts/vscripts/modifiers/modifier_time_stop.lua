modifier_time_stop = class({})

function modifier_time_stop:CheckState()
 return {
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_FROZEN] = true,
 }
end