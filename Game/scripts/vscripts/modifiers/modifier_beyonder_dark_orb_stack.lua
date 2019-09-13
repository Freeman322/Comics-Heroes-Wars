modifier_beyonder_dark_orb_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_beyonder_dark_orb_stack:IsHidden()
	return true
end

function modifier_beyonder_dark_orb_stack:IsPurgable()
	return false
end

function modifier_beyonder_dark_orb_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_beyonder_dark_orb_stack:OnCreated( kv )
	if not IsServer() then return end
	self.stack = kv.stack
end

function modifier_beyonder_dark_orb_stack:OnRemoved()
end

function modifier_beyonder_dark_orb_stack:OnDestroy()
	if not IsServer() then return end

	if self.modifier then
		self.modifier:RemoveStack( self.stack )
	end
end