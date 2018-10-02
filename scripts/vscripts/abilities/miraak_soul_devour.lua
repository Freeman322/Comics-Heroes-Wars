miraak_soul_devour = class({})


function miraak_soul_devour:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget ~= nil and hTarget:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function miraak_soul_devour:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end


function miraak_soul_devour:OnAbilityPhaseStart()
    if IsServer() then 
        EmitSoundOn("Miraak.SoulDevour.Cast", self:GetCaster())
    end 
	return true
end

--------------------------------------------------------------------------------

function miraak_soul_devour:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			hTarget:SetMana(hTarget:GetMana() - self:GetSpecialValueFor("mana_burn"))

            if hTarget:GetManaPercent() <= self:GetSpecialValueFor("mana_threshold_ptc") then 
                self:GetCaster():Heal(hTarget:GetHealth(), self)
                self:GetCaster():SetMana(self:GetCaster():GetMana() + hTarget:GetMana())

                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/doom/doom_ti8_immortal_arms/doom_ti8_immortal_devour.vpcf", PATTACH_CUSTOMORIGIN,  hTarget);
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
                ParticleManager:ReleaseParticleIndex( nFXIndex );

                hTarget:Kill(self, self:GetCaster())
            end 
		end

        local nFXIndex = ParticleManager:CreateParticle( "particles/miraak/soul_devour.vpcf", PATTACH_CUSTOMORIGIN, hTarget );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "Hero_DeathProphet.CarrionSwarm.Damage.Mortis", self:GetCaster() )
	end
end