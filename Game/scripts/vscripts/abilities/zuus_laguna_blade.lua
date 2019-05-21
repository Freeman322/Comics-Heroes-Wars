zuus_laguna_blade = class({})

function zuus_laguna_blade:CastFilterResultTarget( hTarget )
  	if IsServer() then
  		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
  		return nResult
  	end

  	return UF_SUCCESS
end

function zuus_laguna_blade:GetCastRange( vLocation, hTarget )
    return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function zuus_laguna_blade:OnSpellStart()
  	local hTarget = self:GetCursorTarget()
  	if hTarget ~= nil then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
        ParticleManager:ReleaseParticleIndex( nFXIndex );
        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), self:GetCaster(), 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _,target in pairs(units) do
                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                EmitSoundOn( "Ability.LagunaBladeImpact", self:GetCaster() )

                ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("damage_side"), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
            end
        end
  	end
end

function zuus_laguna_blade:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

