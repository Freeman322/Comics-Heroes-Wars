if beast_sanity == nil then beast_sanity = class({}) end

function beast_sanity:GetCastRange( vLocation, hTarget )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cast_range_scepter" )
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function beast_sanity:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_beast_arcana") then
		return "custom/beast_sanity_arcana"
	end
	return "custom/beast_etize"
end


function beast_sanity:OnSpellStart()
  local hTarget = self:GetCaster():GetCursorPosition()
  local nFXIndex = ParticleManager:CreateParticle( "particles/effects/antimage_manavoid_2.vpcf", PATTACH_CUSTOMORIGIN, nil );
  ParticleManager:SetParticleControl( nFXIndex, 0, hTarget );
  ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0) );
  ParticleManager:ReleaseParticleIndex( nFXIndex );

  EmitSoundOn( "Hero_Techies.Suicide", self:GetCaster() )
  EmitSoundOn( "Hero_Antimage.ManaVoid", self:GetCaster() )
  EmitSoundOn( "Hero_Techies.Suicide", self:GetCaster() )

  local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget, self:GetCaster(), self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if #units > 0 then
		for _,target in pairs(units) do
			target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 2 } )
			ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetSpecialValueFor("damage_multiplier") * #units, ability = self, damage_type = DAMAGE_TYPE_PURE})
			if self:GetCaster():HasModifier("modifier_beast_arcana") then
				local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", PATTACH_CUSTOMORIGIN, target );
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
				ParticleManager:ReleaseParticleIndex( nFXIndex );

				EmitSoundOn( "Hero_ObsidianDestroyer.AstralImprisonment.End", target)
			end
		end
	end
end
