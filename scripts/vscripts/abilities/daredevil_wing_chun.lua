if daredevil_wing_chun == nil then daredevil_wing_chun = class({}) end
LinkLuaModifier("modifier_daredevil_wing_chun", 			 "abilities/daredevil_wing_chun.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_daredevil_wing_chun_damage", "abilities/daredevil_wing_chun.lua", LUA_MODIFIER_MOTION_NONE)

function daredevil_wing_chun:GetIntrinsicModifierName()
	return "modifier_daredevil_wing_chun"
end

if modifier_daredevil_wing_chun == nil then modifier_daredevil_wing_chun = class({}) end

function modifier_daredevil_wing_chun:IsHidden()
	return true
end

function modifier_daredevil_wing_chun:IsPurgable()
	return false
end

function modifier_daredevil_wing_chun:RemoveOnDeath()
	return true
end


function modifier_daredevil_wing_chun:OnCreated(htable)
	if IsServer() then
		self.counter = 0
	end
end

function modifier_daredevil_wing_chun:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_daredevil_wing_chun:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		if self.counter ~= nil then
			self.counter = self.counter + 1
			if self.counter >= self:GetAbility():GetSpecialValueFor("required_hits") then
				if not self:GetParent():HasModifier("pszScriptName") then
					self.counter = 0
					self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_daredevil_wing_chun_damage", {duration = self:GetAbility():GetSpecialValueFor("counter_duration")})
				end
			end
			if self:GetParent():HasModifier("modifier_daredevil_wing_chun_damage") then
				self.counter = 0
			end
		else
			self.counter = 0
		end
	end
end

if modifier_daredevil_wing_chun_damage == nil then modifier_daredevil_wing_chun_damage = class({}) end

function modifier_daredevil_wing_chun_damage:IsHidden()
	return false
end

function modifier_daredevil_wing_chun_damage:GetEffectName()
	return "particles/hero_daredevil/daredevil_wing_chun.vpcf"
end

function modifier_daredevil_wing_chun_damage:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_daredevil_wing_chun_damage:IsPurgable()
	return false
end

function modifier_daredevil_wing_chun_damage:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
    }

    return funcs
end

function modifier_daredevil_wing_chun_damage:GetModifierProcAttack_BonusDamage_Magical (params)
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function daredevil_wing_chun:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

