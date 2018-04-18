LinkLuaModifier("modifier_hulk_blood", "abilities/hulk_blood.lua", LUA_MODIFIER_MOTION_NONE)
if hulk_blood == nil then hulk_blood = class({}) end

function hulk_blood:GetIntrinsicModifierName()
   return "modifier_hulk_blood"
end

if modifier_hulk_blood == nil then modifier_hulk_blood = class({}) end

function modifier_hulk_blood:IsHidden()
   return false
end

function modifier_hulk_blood:IsPurgable()
   return false
end

function modifier_hulk_blood:OnCreated( kv )
  	if IsServer() then
  		  self:StartIntervalThink( 0.5 )
  	end
end

function modifier_hulk_blood:OnIntervalThink()
    if IsServer() then
        self.model_scale = self:GetCaster():GetModelScale() + (self:GetCaster():GetHealthPercent() / 40)
        self:SetStackCount( (100 - self:GetCaster():GetHealthPercent()) / 10 )
    end
end

function modifier_hulk_blood:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function modifier_hulk_blood:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("armor")
end
function modifier_hulk_blood:GetModifierPreAttack_BonusDamage( params )
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage")
end
function modifier_hulk_blood:GetModifierModelScale( params )
	return self.model_scale
end
function modifier_hulk_blood:GetModifierHealAmplify_Percentage( params )
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("heal_amplyfy")
end

function hulk_blood:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

