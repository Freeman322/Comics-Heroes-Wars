LinkLuaModifier( "modifier_zatana_resistance", "abilities/zatana_eclipse.lua", LUA_MODIFIER_MOTION_NONE)

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
		local duration = self:GetSpecialValueFor("duration")
		if self:GetCaster():HasScepter() then
			duration = self:GetSpecialValueFor("duration_scepter")
		end
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_oracle_false_promise", { duration = duration } )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_oracle_false_promise_timer", { duration = duration } )
		if self:GetCaster():HasScepter() then
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_zatana_resistance", {duration = duration} )
		end
		EmitSoundOn( "Hero_Antimage.ManaVoidCast", hTarget )
		EmitSoundOn( "Hero_Oracle.PurifyingFlames.Damage", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_silencer/silencer_global_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pur_immortal_cast.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex );
	end
end

modifier_zatana_resistance = class ({})

function modifier_zatana_resistance:IsHidden()
	return true
end

function modifier_zatana_resistance:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
    return funcs
end

function modifier_zatana_resistance:GetModifierIncomingDamage_Percentage()
	return 50
end

