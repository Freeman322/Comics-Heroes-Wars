modifier_beyonder_dark_orb = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_beyonder_dark_orb:IsHidden()
	return false
end

function modifier_beyonder_dark_orb:IsDebuff()
	return self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber()
end

function modifier_beyonder_dark_orb:IsStunDebuff()
	return false
end

function modifier_beyonder_dark_orb:IsPurgable()
	return false
end

function modifier_beyonder_dark_orb:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_beyonder_dark_orb:OnCreated( kv )
	-- reduce intel if debuff, add if buff
	self.debuff = self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber()
	self.mult = 1
	if self.debuff then
		self.mult = -1
	end

	if not IsServer() then return end

	self:AddStack( kv.steal, kv.duration )
end

function modifier_beyonder_dark_orb:OnRefresh( kv )
	if not IsServer() then return end

	self:AddStack( kv.steal, kv.duration )
end

function modifier_beyonder_dark_orb:OnRemoved()
end

function modifier_beyonder_dark_orb:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_beyonder_dark_orb:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_beyonder_dark_orb:GetModifierBonusStats_Intellect()
	return self.mult * self:GetStackCount()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_beyonder_dark_orb:AddStack( value, duration )
	-- set stack
	self:SetStackCount( self:GetStackCount() + value )

	-- add stack modifier
	local modifier = self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_beyonder_dark_orb_stack", -- modifier name
		{
			duration = duration,
			stack = value,
		} -- kv
	)

	-- set stack parent modifier as this
	modifier.modifier = self

	-- reduce some mana because of stat loss
	if self.debuff then
		self:GetParent():ReduceMana( value * 12 )
	end
end

function modifier_beyonder_dark_orb:RemoveStack( value )
	-- set stack
	self:SetStackCount( self:GetStackCount() - value )

	-- restore some mana because of stat gain
	if self.debuff then
		self:GetParent():GiveMana( value * 12 )
	end

	-- if reach zero, destroy
	if self:GetStackCount()<=0 then
		self:Destroy()
	end
end