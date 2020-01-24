if savitar_gods_speed == nil then savitar_gods_speed = class({}) end
LinkLuaModifier( "modifier_savitar_gods_speed",	"abilities/savitar_gods_speed.lua", LUA_MODIFIER_MOTION_NONE )

function savitar_gods_speed:GetIntrinsicModifierName()
	return "modifier_savitar_gods_speed"
end

if modifier_savitar_gods_speed == nil then
	modifier_savitar_gods_speed = class ( {})
end

function modifier_savitar_gods_speed:IsHidden ()
	return true
end

function modifier_savitar_gods_speed:IsPurgable()
	return false
end

function modifier_savitar_gods_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_savitar_gods_speed:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local target = params.attacker

			if target == self:GetParent() then return	end
			if target:GetClassname() == "ent_dota_fountain" then return end
			if not RollPercentage(self:GetAbility():GetSpecialValueFor("chance_dodge")) then return end
			if not self:GetAbility():IsCooldownReady() then return end

			EmitSoundOn("Savitar.Jump", target)

			local ptc = self:GetAbility():GetSpecialValueFor("hp_threshold")

			if self:GetCaster():HasTalent("special_bonus_savitar_2") then ptc = ptc + self:GetCaster():FindTalentValue("special_bonus_savitar_2") end

			self:GetParent():Heal(self:GetParent():GetMaxHealth() * (ptc / 100), target)

			self:GetAbility():UseResources(true, true, true)

			local lifesteal_fx = ParticleManager:CreateParticle("particles/hero_savitar/savitar_godspeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_fx)
		end
	end
end
