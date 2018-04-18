function travel(keys)
	local caster = keys.caster
    local ability = keys.ability
    local point2 = caster:GetCursorPosition()
    caster:SetAbsOrigin (point2)
    FindClearSpaceForUnit (caster, point2, true)
end
