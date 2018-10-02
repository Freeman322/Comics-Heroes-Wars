if flash_time_dilation == nil then flash_time_dilation = class({}) end

LinkLuaModifier( "modifier_flash_time_dilation", "abilities/flash_time_dilation.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function flash_time_dilation:OnSpellStart()
	local duration = self:GetSpecialValueFor( "duration" )

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_flash_time_dilation", { duration = duration }  )

	EmitSoundOn( "Hero_Sven.GodsStrength", self:GetCaster() )
end

if modifier_flash_time_dilation == nil then modifier_flash_time_dilation = class({}) end

function modifier_flash_time_dilation:IsHidden()
   return false
end

function modifier_flash_time_dilation:IsPurgable()
   return false
end

function modifier_flash_time_dilation:GetStatusEffectName()
	return "particles/status_fx/status_effect_techies_stasis.vpcf"
end

function modifier_flash_time_dilation:StatusEffectPriority()
	return 1000
end

function modifier_flash_time_dilation:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf"
end

function modifier_flash_time_dilation:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_flash_time_dilation:OnCreated( kv )
	self.distance = 0
end

function modifier_flash_time_dilation:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_UNIT_MOVED,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_flash_time_dilation:OnUnitMoved(params)
	if self:GetCaster() == params.unit then
			self.distance = self.distance + params.gain
			self:GetParent():Heal(params.gain, self:GetAbility())
  end
end

function modifier_flash_time_dilation:GetModifierAttackSpeedBonus_Constant()
	return self.distance*0.03
end

function flash_time_dilation:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

