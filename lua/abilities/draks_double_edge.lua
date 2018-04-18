if draks_double_edge == nil then draks_double_edge = class({}) end

function draks_double_edge:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function draks_double_edge:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function draks_double_edge:OnSpellStart()
  	local hTarget = self:GetCursorTarget()
  	if hTarget ~= nil then
    		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
      			EmitSoundOn( "Hero_Centaur.DoubleEdge", hTarget )
            local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/centaur/dc_centaur_double_edge/_dc_centaur_double_edge.vpcf", PATTACH_CUSTOMORIGIN, nil );
        		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
        		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 4, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
            ParticleManager:SetParticleControlEnt( nFXIndex, 5, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
        		ParticleManager:ReleaseParticleIndex( nFXIndex );

        		EmitSoundOn( "Hero_Centaur.DoubleEdge", self:GetCaster() )

            ApplyDamage({attacker = self:GetCaster(), victim = hTarget, damage = self:GetSpecialValueFor("edge_damage") + (self:GetCaster():GetHealthRegen()*self:GetSpecialValueFor("damage_per_strngth")), ability = self, damage_type = DAMAGE_TYPE_PHYSICAL})
    		end
  	end
end

function draks_double_edge:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

