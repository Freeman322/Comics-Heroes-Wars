if modifier_glyph == nil then
    modifier_glyph = class({})
end

function modifier_glyph:IsPurgable()
    return false
end

function modifier_glyph:IsHidden()
    return false
end

function modifier_glyph:GetEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_glyph:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_glyph:CheckState()
	local state = {
	[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end