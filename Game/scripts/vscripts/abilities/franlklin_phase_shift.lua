if franlklin_phase_shift == nil then franlklin_phase_shift = class({}) end

LinkLuaModifier( "modifier_franlklin_phase_shift", "abilities/franlklin_phase_shift.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function franlklin_phase_shift:CastFilterResultTarget( hTarget )
	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function franlklin_phase_shift:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function franlklin_phase_shift:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget ~= nil then
		if ( not hTarget:TriggerSpellAbsorb( self ) ) then
			local duration = self:GetSpecialValueFor( "duration" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_franlklin_phase_shift", { duration = duration } )
			EmitSoundOn( "Hero_Spectre.Reality", hTarget )
		end
	end
end

if modifier_franlklin_phase_shift == nil then modifier_franlklin_phase_shift = class({}) end

function modifier_franlklin_phase_shift:IsPurgable()
	return false
end

function modifier_franlklin_phase_shift:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_franlklin_phase_shift:StatusEffectPriority()
	return 2000
end

function modifier_franlklin_phase_shift:GetEffectName()
	return "particles/items_fx/ghost.vpcf"
end

function modifier_franlklin_phase_shift:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_franlklin_phase_shift:CheckState()
	local state = {
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

function modifier_franlklin_phase_shift:DeclareFunctions()
	local funcs = {
    	MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_franlklin_phase_shift:GetModifierMoveSpeed_Limit()
    if self:GetCaster():HasScepter() then
        return 550
    end
    return 100
end

function franlklin_phase_shift:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

