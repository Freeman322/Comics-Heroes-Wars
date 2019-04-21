if modifier_hero_selection == nil then modifier_hero_selection = class({}) end

function modifier_hero_selection:IsHidden()
	return true
end

function modifier_hero_selection:RemoveOnDeath()
	return false
end

function modifier_hero_selection:IsPurgable()
	return false
end

function modifier_hero_selection:GetStatusEffectName()
	return "particles/status_fx/status_effect_omnislash.vpcf"
end

function modifier_hero_selection:StatusEffectPriority()
	return 1000
end

function modifier_hero_selection:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_hero_selection:CheckState()
	local state = {
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_INVISIBLE] = true,
  [MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_hero_selection:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}

	return funcs
end

function modifier_hero_selection:GetVisualZDelta()
	return 5000
end
