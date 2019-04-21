if antman_size_modifier == nil then antman_size_modifier = class({}) end

function antman_size_modifier:IsHidden()
	return false
end

function antman_size_modifier:IsPurgable()
	return false
end

function antman_size_modifier:RemoveOnDeath()
	return false
end

function antman_size_modifier:OnCreated(params)
	self._iStackCount = 100

	if IsServer() then if self:GetParent():FindAbilityByName("antman_size_up") then self:GetParent():FindAbilityByName("antman_size_up"):ToggleAbility() end end 
end

function antman_size_modifier:OnStackCountChanged(iStackCount)
	if iStackCount > 200 then 
		self:SetStackCount(200)
	end
    self._iStackCount = iStackCount - 100
end

function antman_size_modifier:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT
	}

	return funcs
end

function antman_size_modifier:GetModifierAttackSpeedBonus_Constant(params)
	return self:GetAbility():GetSpecialValueFor("attack_speed") * ( (-1) * self._iStackCount)
end

function antman_size_modifier:GetModifierPreAttack_BonusDamage(params)
	return self:GetAbility():GetSpecialValueFor("attack_damage") *  self._iStackCount
end

function antman_size_modifier:GetModifierMoveSpeedBonus_Constant(params)
	return self:GetAbility():GetSpecialValueFor("move_speed") * self._iStackCount
end

function antman_size_modifier:GetModifierModelScale(params)
	return self._iStackCount + 5
end

function antman_size_modifier:GetModifierEvasion_Constant(params)
	return self._iStackCount * (-1)
end

function antman_size_modifier:GetModifierPhysicalArmorBonus(params)
	return self:GetAbility():GetSpecialValueFor("bonus_armor") * ( (-1) * self._iStackCount)
end
