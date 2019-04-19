doomsday_speed = class({})
LinkLuaModifier( "modifier_doomsday_speed", "abilities/doomsday_speed.lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function doomsday_speed:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )
	
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_doomsday_speed", { duration = duration }  )

	EmitSoundOn( "Hero_LifeStealer.Rage", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_4 );
end

if modifier_doomsday_speed == nil then modifier_doomsday_speed = class({}) end

function modifier_doomsday_speed:IsHidden()
	return false
end

function modifier_doomsday_speed:IsPurgable()
	return false
end

function modifier_doomsday_speed:CheckState()
	local state = {
  		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
	return state
end

function modifier_doomsday_speed:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_timewalk.vpcf"
end

function modifier_doomsday_speed:StatusEffectPriority()
	return 1000
end

function modifier_doomsday_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
	return funcs
end

function modifier_doomsday_speed:GetModifierMoveSpeed_Absolute( params )
	return self:GetAbility():GetSpecialValueFor("speed_bonus")
end

function doomsday_speed:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

