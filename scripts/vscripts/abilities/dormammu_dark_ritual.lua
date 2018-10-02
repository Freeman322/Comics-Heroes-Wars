dormammu_dark_ritual = class({})

function dormammu_dark_ritual:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/battlecup/battle_cup_fall_destroy_a.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 5, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "Hero_ArcWarden.SparkWraith.Damage", self:GetCaster() )

		self:GetCaster():Heal((self:GetSpecialValueFor("health_conversion") / 100) * hTarget:GetHealth(), hInflictor)
		ApplyDamage({victim = hTarget, attacker = self:GetCaster(), ability = self, damage = ((self:GetSpecialValueFor("health_conversion") / 100) * hTarget:GetHealth()), damage_type = DAMAGE_TYPE_PURE})
	end
end
