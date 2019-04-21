if modifier_flash_custom == nil then modifier_flash_custom = class({}) end

function modifier_flash_custom:IsAura()
	return false
end

function modifier_flash_custom:IsHidden()
	return true
end

function modifier_flash_custom:IsPurgable()
	return false
end

function modifier_flash_custom:RemoveOnDeath()
	return false
end

