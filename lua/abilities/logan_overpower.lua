logan_overpower = class({})
LinkLuaModifier( "modifier_logan_overpower", "abilities/logan_overpower.lua", LUA_MODIFIER_MOTION_NONE )

function logan_overpower:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_wolverine_claws") then
		return "custom/wolverine_ult_immortal"
	end
	return "custom/wolverine_ult"
end

function logan_overpower:OnSpellStart()
	local duration = self:GetSpecialValueFor(  "duration_tooltip" )

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_logan_overpower", { duration = duration } )

  self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
end

if modifier_logan_overpower == nil then modifier_logan_overpower = class({}) end

function modifier_logan_overpower:IsHidden()
	return false
end

function modifier_logan_overpower:IsPurgable()
	return false
end

function modifier_logan_overpower:RemoveOnDeath()
	return true
end

function modifier_logan_overpower:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf"
end

function modifier_logan_overpower:StatusEffectPriority()
	return 1000
end

function modifier_logan_overpower:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_logan_overpower:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_logan_overpower:OnCreated(htable)
	if IsServer() then
		self.counter = self:GetAbility():GetSpecialValueFor("max_attacks")

    if self:GetCaster():HasModifier("modifier_wolverine_claws") then
      EmitSoundOn("Hero_Spirit_Breaker.NetherStrike.Begin", self:GetCaster())
      EmitSoundOn("Hero_Spirit_Breaker.NetherStrike.End", self:GetCaster())
  	else
      EmitSoundOn("Hero_Ursa.Enrage", self:GetCaster())
    end
	end
end

function modifier_logan_overpower:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_logan_overpower:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
    if not self.counter or self.counter <= 0 then
      self:Destroy()
      return nil
    end
		self.counter = self.counter - 1
	end
end


function modifier_logan_overpower:GetModifierBaseAttackTimeConstant(params)
    return 0.07
end

function modifier_logan_overpower:GetModifierAttackSpeedBonus_Constant(params)
    return 10000
end

function logan_overpower:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

