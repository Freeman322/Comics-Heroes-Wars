if monkey_king_dragon_strike == nil then monkey_king_dragon_strike = class({}) end
LinkLuaModifier("modifier_monkey_king_dragon_strike", 			"abilities/monkey_king_dragon_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_dragon_strike_charges", "abilities/monkey_king_dragon_strike.lua", LUA_MODIFIER_MOTION_NONE)

function monkey_king_dragon_strike:GetIntrinsicModifierName()
	return "modifier_monkey_king_dragon_strike"
end

if modifier_monkey_king_dragon_strike == nil then modifier_monkey_king_dragon_strike = class({}) end

function modifier_monkey_king_dragon_strike:IsHidden()
	return true
end

function modifier_monkey_king_dragon_strike:IsPurgable()
	return false
end

function modifier_monkey_king_dragon_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_monkey_king_dragon_strike:OnCreated(params)
	if IsServer() then
		self.counter = 0
	end
end

function modifier_monkey_king_dragon_strike:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		if not self:GetParent():HasModifier("modifier_monkey_king_dragon_strike_charges") then
			self.counter = self.counter + 1
			if self.counter >= self:GetAbility():GetSpecialValueFor("required_hits") then
				self.counter = 0
				if not self:GetParent():IsIllusion() then
					local modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_dragon_strike_charges", {duration = 35})
					modifier:SetStackCount(self:GetAbility():GetSpecialValueFor("charges"))
				end
			end
		end
	end
end

if modifier_monkey_king_dragon_strike_charges == nil then modifier_monkey_king_dragon_strike_charges = class({}) end

function modifier_monkey_king_dragon_strike_charges:IsHidden()
	return false
end

function modifier_monkey_king_dragon_strike_charges:GetStatusEffectName()
	return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf"
end

function modifier_monkey_king_dragon_strike_charges:StatusEffectPriority()
	return 1000
end

function modifier_monkey_king_dragon_strike_charges:GetEffectName()
	return "particles/econ/items/monkey_king/arcana/monkey_king_arcana_fire.vpcf"
end

function modifier_monkey_king_dragon_strike_charges:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_monkey_king_dragon_strike_charges:IsPurgable()
	return false
end

function modifier_monkey_king_dragon_strike_charges:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_monkey_king_dragon_strike_charges:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		self:SetStackCount(self:GetStackCount() - 1)

		if self:GetStackCount() <= 0 then
			self:Destroy()
		end


		----params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
		self:GetParent():Heal((params.damage * (self:GetAbility():GetSpecialValueFor("lifesteal") / 100) ), self:GetAbility())
		local lifesteal_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent ())
		ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent ():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_fx)

		EmitSoundOn("Hero_MonkeyKing.IronCudgel", params.target)
		EmitSoundOn("DOTA_Item.MKB.Minibash", params.target)
	end
end

function modifier_monkey_king_dragon_strike_charges:GetModifierPreAttack_BonusDamage (params)
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function monkey_king_dragon_strike:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

