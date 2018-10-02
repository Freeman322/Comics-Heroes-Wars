if modifier_hellspont_infest == nil then modifier_hellspont_infest = class({}) end

function modifier_hellspont_infest:IsHidden()
	return true
end

function modifier_hellspont_infest:IsPurgable()
	return false
end

function modifier_hellspont_infest:OnCreated(table)
	if IsServer() then
		self.health = self:GetAbility():GetCaster():GetHealth()
	end
end

function modifier_hellspont_infest:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_hellspont_infest:GetModifierAttackSpeedBonus_Constant( params )
	return 300
end

function modifier_hellspont_infest:GetModifierExtraHealthBonus( params )
	return self.health
end

function modifier_hellspont_infest:GetModifierBaseAttack_BonusDamage( params )
	return self.health*0.1
end
