savitar_speedforce = class({})
LinkLuaModifier( "modifier_savitar_speedforce", "abilities/savitar_speedforce.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_savitar_speedforce_aura", "abilities/savitar_speedforce.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function savitar_speedforce:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function savitar_speedforce:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

--------------------------------------------------------------------------------

function savitar_speedforce:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_savitar_speedforce_aura", { duration = self:GetSpecialValueFor("duration") } )

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_magical.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetOrigin() );
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetSpecialValueFor("aura_aoe"), self:GetSpecialValueFor("aura_aoe"), 0) );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "Hero_Terrorblade.ConjureImage", self:GetCaster() )
	end
end

if modifier_savitar_speedforce_aura == nil then modifier_savitar_speedforce_aura = class({}) end

function modifier_savitar_speedforce_aura:IsAura()
	return true
end

function modifier_savitar_speedforce_aura:IsHidden()
	return true
end

function modifier_savitar_speedforce_aura:IsPurgable()
	return false
end

function modifier_savitar_speedforce_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_aoe")
end

function modifier_savitar_speedforce_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_savitar_speedforce_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_savitar_speedforce_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_savitar_speedforce_aura:GetModifierAura()
	return "modifier_savitar_speedforce"
end

if modifier_savitar_speedforce == nil then modifier_savitar_speedforce = class({}) end

function modifier_savitar_speedforce:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN
    }

    return funcs
end

function modifier_savitar_speedforce:GetModifierMoveSpeed_AbsoluteMin()
	return self:GetAbility():GetSpecialValueFor("speed_bonus")
end

function modifier_savitar_speedforce:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end



function modifier_savitar_speedforce:IsHidden()
	return true
end

function modifier_savitar_speedforce:IsPurgable()
	return false
end