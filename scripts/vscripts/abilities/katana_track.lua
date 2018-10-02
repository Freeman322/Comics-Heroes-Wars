katana_track = class({})

LinkLuaModifier( "modifier_katana_track", "abilities/katana_track.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function katana_track:CastFilterResultTarget( hTarget )
	if IsServer() then

		if hTarget ~= nil and hTarget:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end


function katana_track:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			local duration = self:GetSpecialValueFor( "duration" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_katana_track", { duration = duration } )
			EmitSoundOn( "Hero_BountyHunter.Target", hTarget )
		end
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );
	end
end

modifier_katana_track = class({})

function modifier_katana_track:CheckState()
	return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_katana_track:IsHidden()
	return false
end

function modifier_katana_track:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_katana_track:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("bonus_move_speed_pct")
end

function katana_track:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

