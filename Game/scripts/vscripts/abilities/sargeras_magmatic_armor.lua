LinkLuaModifier( "modifier_sargeras_magmatic_armor", "abilities/sargeras_magmatic_armor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sargeras_magmatic_armor_passive", "abilities/sargeras_magmatic_armor.lua", LUA_MODIFIER_MOTION_NONE )

local MAX_MODS_COUNT = 10

sargeras_magmatic_armor = class({})

function sargeras_magmatic_armor:GetIntrinsicModifierName() return "modifier_sargeras_magmatic_armor_passive" end

modifier_sargeras_magmatic_armor_passive = class({})

function modifier_sargeras_magmatic_armor_passive:IsHidden() return true end
function modifier_sargeras_magmatic_armor_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_sargeras_magmatic_armor_passive:OnTakeDamage(params)
	if self:GetParent() == params.unit and self:GetParent():IsRealHero() and params.attacker:IsBuilding() == false and params.attacker:IsMagicImmune() == false then
		local count = #(params.attacker:FindAllModifiersByName("modifier_sargeras_magmatic_armor"))

		if count < MAX_MODS_COUNT then
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sargeras_magmatic_armor", {duration = self:GetAbility():GetSpecialValueFor("duration_tooltip")})
		end
	end
end

modifier_sargeras_magmatic_armor = class({})

function modifier_sargeras_magmatic_armor:OnCreated() if IsServer() then self:StartIntervalThink(0.1) end end
function modifier_sargeras_magmatic_armor:IsHidden() return false end
function modifier_sargeras_magmatic_armor:IsPurgable() return true end

function modifier_sargeras_magmatic_armor:OnIntervalThink()
	if IsServer() then
		ApplyDamage({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = (self:GetAbility():GetSpecialValueFor("damage_interval") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_sargeras") or 0)) / 10,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility()
		})
	end
end

function modifier_sargeras_magmatic_armor:GetAttributes()	if IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_sargeras_1") then	return MODIFIER_ATTRIBUTE_MULTIPLE end end
function modifier_sargeras_magmatic_armor:GetEffectName()	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf" end
function modifier_sargeras_magmatic_armor:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
