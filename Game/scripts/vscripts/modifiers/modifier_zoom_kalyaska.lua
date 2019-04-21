if modifier_zoom_kalyaska == nil then modifier_zoom_kalyaska = class({}) end 

function modifier_zoom_kalyaska:IsPurgable()
	return false
end

function modifier_zoom_kalyaska:RemoveOnDeath()
	return false
end

function modifier_zoom_kalyaska:IsHidden()
	return true
end

function modifier_zoom_kalyaska:GetEffectName()
	return "particles/hero_zoom/blackflash/blackflash_ambient_darkness.vpcf"
end

function modifier_zoom_kalyaska:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
