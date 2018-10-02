if not modifier_backdoor_tower then modifier_backdoor_tower = class({}) end

function modifier_backdoor_tower:OnCreated()
  self.regen = 0
  if IsServer() then
    self:StartIntervalThink(0.1)
  end
end

function modifier_backdoor_tower:OnIntervalThink()
  local creeps = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false )
	if not creeps or #creeps <= 0 then
    self.regen = 200
  else
    self.regen = 0
  end
end

function modifier_backdoor_tower:IsHidden()
  return true
end

function modifier_backdoor_tower:IsPurgable()
  return false
end

function modifier_backdoor_tower:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_backdoor_tower:GetModifierConstantHealthRegen( params )
	return self.regen
end
