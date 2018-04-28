LinkLuaModifier("modifier_ursa_warrior_berserkers_blood", "abilities/ursa_warrior_berserkers_blood.lua", LUA_MODIFIER_MOTION_NONE)
if ursa_warrior_berserkers_blood == nil then ursa_warrior_berserkers_blood = class({}) end

function ursa_warrior_berserkers_blood:GetIntrinsicModifierName()
   return "modifier_ursa_warrior_berserkers_blood"
end

if modifier_ursa_warrior_berserkers_blood == nil then modifier_ursa_warrior_berserkers_blood = class({}) end

function modifier_ursa_warrior_berserkers_blood:IsHidden()
   return true
end

function modifier_ursa_warrior_berserkers_blood:IsPurgable()
   return false
end

function modifier_ursa_warrior_berserkers_blood:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}

	return funcs
end

function modifier_ursa_warrior_berserkers_blood:OnCreated(params)
	if IsServer() then 
		self.attackTime = self:GetAbility():GetSpecialValueFor("base_attack_time")
		if self:GetCaster():HasTalent("special_bonus_unique_ursa_warrior_3") then 
			self.attackTime = self.attackTime + self:GetCaster():FindTalentValue("special_bonus_unique_ursa_warrior_3")
		end
	end
end

function modifier_ursa_warrior_berserkers_blood:GetModifierAttackSpeedBonus_Constant( params )
	return (100 - self:GetParent():GetHealthPercent()) * self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_ursa_warrior_berserkers_blood:GetModifierBaseAttackTimeConstant( params )
	return self.attackTime 
end

