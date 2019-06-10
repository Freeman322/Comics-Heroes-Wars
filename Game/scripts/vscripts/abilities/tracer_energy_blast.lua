if tracer_energy_blast == nil then tracer_energy_blast = class({}) end

function tracer_energy_blast:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget ~= nil and hTarget:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end


function tracer_energy_blast:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end



function tracer_energy_blast:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			local damage = self:GetSpecialValueFor( "damage" )
			if self:GetCaster():HasTalent("special_bonus_unique_tracer") then
		        damage = self:GetCaster():FindTalentValue("special_bonus_unique_tracer") + self:GetSpecialValueFor( "damage" )
			end
		
			local nFXIndex = ParticleManager:CreateParticle( "particles/hero_tracer/tracer_energy_blast.vpcf", PATTACH_CUSTOMORIGIN, nil );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControl(nFXIndex, 3, self:GetCaster():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex( nFXIndex );

			EmitSoundOn( "Hero_Lina.LagunaBlade.Immortal", hTarget )

			ApplyDamage({attacker = self:GetCaster(), victim = hTarget, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self})	
		end

		EmitSoundOn( "Hero_Lina.LagunaBladeImpact.Immortal", self:GetCaster() )
	end
end
function tracer_energy_blast:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

