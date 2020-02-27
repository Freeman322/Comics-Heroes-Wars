LinkLuaModifier("modifier_charges", "modifiers/modifier_charges.lua", 0)

tracer_blink = class({})

function tracer_blink:GetManaCost(iLevel)
    return IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_tracer_blink") and 0 or self.BaseClass.GetManaCost(self, iLevel)
end

function tracer_blink:OnSpellStart()
	if IsServer() then
		ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_sparkles_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		EmitSoundOn("Hero_Tinker.Laser", self:GetCaster())
		local hTarget = self:GetCursorPosition()

		if (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D() > self:GetSpecialValueFor("cast_range") then
			hTarget = self:GetCaster():GetAbsOrigin() + (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("cast_range")
		end

		self:GetCaster():SetAbsOrigin(hTarget)
		FindClearSpaceForUnit(self:GetCaster(), hTarget, false)
		ProjectileManager:ProjectileDodge(self:GetCaster())

		EmitSoundOn("Hero_Tinker.LaserImpact", self:GetCaster())
		ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_sparkles_end_nexon_hero_cp_2014.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	end
end
