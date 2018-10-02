if modifier_ragnaros == nil then modifier_ragnaros = class({}) end

function modifier_ragnaros:IsPurgable()
	return false;
end

function modifier_ragnaros:IsHidden()
	return true;
end

function modifier_ragnaros:RemoveOnDeath()
	return false;
end

function modifier_ragnaros:FindUnits()
  local count = 0;
  if IsServer() then
  	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
    count = #units
  end
  return count;
end

function modifier_ragnaros:GetUnitForCast()
  local unit;
  if IsServer() then
    local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
    if #units > 0 then
      unit = units[1]
    end
  end
  return unit;
end

function modifier_ragnaros:OnCreated( kv )
  if IsServer() then
    self.heroes   = HeroList:GetAllHeroes()
    self.Ability1 = self:GetParent():FindAbilityByName("ragnaros_slam")
    self.Ability2 = self:GetParent():FindAbilityByName("ragnaros_scorched_earth")
    self.Ability3 = self:GetParent():FindAbilityByName("ragnaros_doom")
		---self.Ability3 = self:GetParent():FindAbilityByName("lich_zombie_spawn")
    --[[for i=0, 15, 1 do
  		local current_ability = self:GetParent():GetAbilityByIndex(i)
  		if current_ability ~= nil then
  			current_ability:SetLevel(1)
  		end
  	end]]
		self:StartIntervalThink( 1.0 )
	end
end

function modifier_ragnaros:OnIntervalThink()
  if IsServer() then
    if self:FindUnits() > 3 and self.Ability1:IsCooldownReady() then
      ExecuteOrderFromTable({
					UnitIndex = self:GetParent():entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = self.Ability1:entindex()
				})
    end
    if self:FindUnits() > 2 and self.Ability2:IsCooldownReady() then
      ExecuteOrderFromTable({
					UnitIndex = self:GetParent():entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = self.Ability2:entindex()
				})
    end
    if self.Ability3:IsCooldownReady() then
      local unit = self:GetUnitForCast()
      if unit then
				ExecuteOrderFromTable({
           UnitIndex = self:GetParent():entindex(),
           OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
           TargetIndex = unit:entindex(),
           AbilityIndex = self.Ability3:entindex()
					})
      end
    end
  end
end

function modifier_ragnaros:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_ragnaros:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_ragnaros:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_ragnaros:GetAbsoluteNoDamagePure(params)
	return 1
end

function modifier_ragnaros:GetModifierMoveSpeed_Absolute(params)
	return 522
end
