tracer_blink = class({})

function tracer_blink:OnSpellStart()
	self:GetCaster():StartGesture(ACT_DOTA_CAST_TORNADO)
	ProjectileManager:ProjectileDodge(self:GetCaster())
	ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_sparkles_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	EmitSoundOn("Hero_Tinker.Laser", self:GetCaster())
	self:GetCaster():SetAbsOrigin(self:GetCursorPosition())
	FindClearSpaceForUnit(self:GetCaster(), self:GetCursorPosition(), false)
	EmitSoundOn("Hero_Tinker.LaserImpact", self:GetCaster())
	ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_sparkles_end_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
end
