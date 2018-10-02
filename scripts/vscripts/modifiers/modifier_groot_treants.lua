if modifier_groot_treants == nil then modifier_groot_treants = class({}) end

function modifier_groot_treants:IsHidden()
	return true
	-- body
end

function modifier_groot_treants:IsPurgable()
	return false
	-- body
end

function modifier_groot_treants:OnCreated(table)
	if IsServer() then
		self.strength = self:GetCaster():GetStrength()
	end
end

function modifier_groot_treants:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_groot_treants:GetModifierExtraHealthBonus( params )
	return self.strength*5
end

--------------------------------------------------------------------------------

function modifier_groot_treants:GetModifierBaseAttack_BonusDamage( params )
	return self.strength*0.5
end