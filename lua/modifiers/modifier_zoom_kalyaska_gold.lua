if modifier_zoom_kalyaska_gold == nil then modifier_zoom_kalyaska_gold = class({}) end 

function modifier_zoom_kalyaska_gold:IsPurgable()
	return false
end

function modifier_zoom_kalyaska_gold:RemoveOnDeath()
	return false
end

function modifier_zoom_kalyaska_gold:IsHidden()
	return true
end

function modifier_zoom_kalyaska_gold:GetEffectName()
	return "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_gold.vpcf"
end

function modifier_zoom_kalyaska_gold:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
