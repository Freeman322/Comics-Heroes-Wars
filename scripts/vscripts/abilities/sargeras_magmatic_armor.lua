sargeras_magmatic_armor = class({})
LinkLuaModifier( "modifier_sargeras_magmatic_armor",				 "abilities/sargeras_magmatic_armor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sargeras_magmatic_armor_passive", "abilities/sargeras_magmatic_armor.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sargeras_magmatic_armor:GetIntrinsicModifierName()
	return "modifier_sargeras_magmatic_armor_passive"
end

if modifier_sargeras_magmatic_armor_passive == nil then modifier_sargeras_magmatic_armor_passive = class({}) end

function modifier_sargeras_magmatic_armor_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_sargeras_magmatic_armor_passive:OnTakeDamage( params )
	if self:GetParent() == params.unit then
		params.attacker:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_sargeras_magmatic_armor", {duration = self:GetAbility():GetSpecialValueFor("duration_tooltip")})
	end
	return 0
end

if modifier_sargeras_magmatic_armor == nil then modifier_sargeras_magmatic_armor = class({}) end

function modifier_sargeras_magmatic_armor:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_sargeras_magmatic_armor:IsHidden()
	return false
end

function modifier_sargeras_magmatic_armor:IsPurgable()
	return false
end

function modifier_sargeras_magmatic_armor:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local iDamage = hAbility:GetSpecialValueFor( "damage_interval" )

		if self:GetCaster():HasTalent("special_bonus_unique_sargeras") then
	     iDamage = self:GetCaster():FindTalentValue("special_bonus_unique_sargeras") + hAbility:GetSpecialValueFor( "damage_interval" )
		end

		local damage = {
			victim = self:GetParent(),
			attacker = hAbility:GetCaster(),
			damage = iDamage/10,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = hAbility
		}
		
		if not self:GetParent():IsTower() and not self:GetParent():IsMagicImmune() then 
			ApplyDamage( damage )
		end
	end
end

function modifier_sargeras_magmatic_armor:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_sargeras_magmatic_armor:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_sargeras_magmatic_armor:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }

    return funcs
end

function modifier_sargeras_magmatic_armor:GetModifierPhysicalArmorBonus (params)
    return self:GetAbility():GetSpecialValueFor("armor_bonus")
end

function sargeras_magmatic_armor:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

