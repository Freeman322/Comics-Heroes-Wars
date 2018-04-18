if modifier_zoom_arcana == nil then modifier_zoom_arcana = class({}) end 

function modifier_zoom_arcana:IsPurgable()
	return false
end

function modifier_zoom_arcana:RemoveOnDeath()
	return false
end

function modifier_zoom_arcana:IsHidden()
	return true
end

function modifier_zoom_arcana:GetEffectName()
	return "particles/hero_zoom/blackflash/blackflash_ambient_darkness.vpcf"
end

function modifier_zoom_arcana:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
