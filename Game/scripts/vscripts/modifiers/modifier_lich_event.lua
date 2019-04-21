if modifier_lich_event == nil then modifier_lich_event = class({}) end

function modifier_lich_event:IsPurgable()
	return false;
end

function modifier_lich_event:IsHidden()
	return true;
end

function modifier_lich_event:RemoveOnDeath()
	return false;
end

function modifier_lich_event:FindUnits()
  local count = 0;
  if IsServer() then
  	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
    count = #units
  end
  return count;
end

function modifier_lich_event:GetUnitForCast()
  local unit;
  if IsServer() then
    local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
    if #units > 0 then
      unit = units[1]
    end
  end
  return unit;
end

function modifier_lich_event:OnCreated( kv )
  if IsServer() then
    self.heroes = HeroList:GetAllHeroes()
    self.Ability1 = self:GetParent():FindAbilityByName("lich_paralyzing_cask")
    self.Ability2 = self:GetParent():FindAbilityByName("lich_slam")
		---self.Ability3 = self:GetParent():FindAbilityByName("lich_zombie_spawn")
    for i=0, 15, 1 do
  		local current_ability = self:GetParent():GetAbilityByIndex(i)
  		if current_ability ~= nil then
  			current_ability:SetLevel(1)
  		end
  	end
		self:StartIntervalThink( 1.0 )
	end
end

function modifier_lich_event:OnIntervalThink()
  if IsServer() then
    if self:FindUnits() > 3 and self.Ability2:IsCooldownReady() then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.Ability2:entindex()
			})
    end
	--[[	if self:FindUnits() > 0 and self.Ability3:IsCooldownReady() then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.Ability3:entindex()
			})
		end]]
    if self.Ability1:IsCooldownReady() then
      local unit = self:GetUnitForCast()
      if unit then
				ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = self.Ability1:entindex(),
				TargetIndex = unit:entindex()})
      end
    end
  end
end

function modifier_lich_event:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_lich_event:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_lich_event:GetAbsoluteNoDamagePure(params)
	return 1
end
