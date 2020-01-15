if zatana_eclipse == nil then zatana_eclipse = class({}) end

function zatana_eclipse:CastFilterResultTarget( hTarget )
	if IsServer() then

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end


function zatana_eclipse:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		local duration = self:GetSpecialValueFor( "duration" )
		
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_oracle_false_promise", { duration = duration } )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_oracle_false_promise_timer", { duration = duration } )

		EmitSoundOn( "Hero_Antimage.ManaVoidCast", hTarget )
		EmitSoundOn( "Hero_Oracle.PurifyingFlames.Damage", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pur_immortal_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sailor") then EmitSoundOn( "Sailor.Cast4", self:GetCaster() ) end
		if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "rat") then EmitSoundOn("Rat.Cast", self:GetCaster()) end
	end
end
