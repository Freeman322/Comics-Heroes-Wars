if not modifier_batman_nightmaster then modifier_batman_nightmaster = class({}) end 

function modifier_batman_nightmaster:IsHidden()
	return true
end

function modifier_batman_nightmaster:IsPurgable()
	return false
end

function modifier_batman_nightmaster:RemoveOnDeath()
	return false
end

function modifier_batman_nightmaster:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_batman_nightmaster:GetEffectName()
	return "particles/hero_batman/batman_immortal_ambient.vpcf"
end