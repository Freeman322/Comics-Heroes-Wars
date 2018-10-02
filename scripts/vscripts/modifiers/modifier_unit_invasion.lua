if modifier_unit_invasion == nil then modifier_unit_invasion = class({}) end

function modifier_unit_invasion:IsPurgable()
  return false
end

function modifier_unit_invasion:OnCreated(table)
	if IsServer() then
    self.dmg = GameRules:GetGameTime()
    self.hp = GameRules:GetGameTime()*10
    self.armor = GameRules:GetGameTime()/15
  end
end

function modifier_unit_invasion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_unit_invasion:GetModifierExtraHealthBonus( params )
	return self.hp
end

function modifier_unit_invasion:GetModifierPhysicalArmorBonus( params )
	return self.armor
end

function modifier_unit_invasion:GetModifierBaseAttack_BonusDamage( params )
	return self.dmg
end
