LinkLuaModifier("modifier_ragnaros_essence_strike", "abilities/ragnaros_essence_strike.lua", 0)
LinkLuaModifier("modifier_ragnaros_essence_strike_target", "abilities/ragnaros_essence_strike.lua", 0)

ragnaros_essence_strike = class({GetIntrinsicModifierName = function() return "modifier_ragnaros_essence_strike" end})
modifier_ragnaros_essence_strike = class({
	IsHidden = function() return true end,
	IsPurgable = function() return false end,
	DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ORDER} end
})
function modifier_ragnaros_essence_strike:OnCreated() self.strike = false end
function modifier_ragnaros_essence_strike:OnAttackLanded (params)
	if self:GetParent () == params.attacker and self:GetAbility():IsCooldownReady() and self:GetParent():IsRealHero() and (self:GetAbility():GetAutoCastState() or self.strike) and self:GetAbility():IsOwnersManaEnough() and not params.target:IsBuilding() then
		EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", params.target)
		EmitSoundOn("Hero_DoomBringer.InfernalBlade.Target", params.target)

		params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("ministun_duration")})
		params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ragnaros_essence_strike_target", {duration = self:GetAbility():GetSpecialValueFor("burn_duration")})

		self:GetAbility():UseResources(true, false, true)

		self.strike = false
	end
end
function modifier_ragnaros_essence_strike:OnOrder(params)
	if params.unit == self:GetParent() then
		if params.order_type == DOTA_UNIT_ORDER_CAST_TARGET and params.ability:GetName() == self:GetAbility():GetName() then
			self.strike = true
		else
			self.strike = false
		end
	end
end

modifier_ragnaros_essence_strike_target = class({IsHidden = function() return false end, IsPurgable = function() return true end})
function modifier_ragnaros_essence_strike_target:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(1)
    self:OnIntervalThink()
end

function modifier_ragnaros_essence_strike_target:OnIntervalThink()
    if not IsServer() then return end
	ApplyDamage({
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		ability = self:GetAbility(),
		damage = self:GetAbility():GetSpecialValueFor("burn_damage") + (0.01 * self:GetParent():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("burn_damage_pct")),
		damage_type = self:GetAbility():GetAbilityDamageType()
	})
end
