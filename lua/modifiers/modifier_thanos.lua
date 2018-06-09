if modifier_thanos == nil then modifier_thanos = class({}) end

function modifier_thanos:IsPurgable()
	return false;
end

function modifier_thanos:IsHidden()
	return true;
end

function modifier_thanos:RemoveOnDeath()
	return false;
end

function modifier_thanos:FindUnits()
  local count = 0;
  if IsServer() then
  	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
    count = #units
  end
  return count;
end

function modifier_thanos:GetUnitForCast()
  local unit;
  if IsServer() then
    local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
    if #units > 0 then
      unit = units[1]
    end
  end
  return unit;
end

function modifier_thanos:OnCreated( kv )
  if IsServer() then
    self.heroes = HeroList:GetAllHeroes()
    self.Ability1 = self:GetParent():FindAbilityByName("tanos_chronosphere")
    self.Ability2 = self:GetParent():FindAbilityByName("thanos_dying_star")
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

function modifier_thanos:OnIntervalThink()
	if IsServer() then
		if self:GetHealthPercent() < 16 then 
			pcall(function()
				local item = self:GetParent():FindItemInInventory("item_glove_of_the_creator")
				if item then
					item:OnSpellStart() 
				end
			end)
		end
    if self:FindUnits() > 3 and self.Ability2:IsCooldownReady() then
      local unit = self:GetUnitForCast()
      if not unit then
        unit = self:GetParent():GetAbsOrigin()
      end
			ExecuteOrderFromTable({
        UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = unit,
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
  				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
  				Position = unit:GetAbsOrigin(),
  				AbilityIndex = self.Ability1:entindex()
					})
      end
    end
  end
end

function modifier_thanos:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_thanos:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = false,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_thanos:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function modifier_thanos:GetAbsoluteNoDamagePure(params)
	return 1
end

function modifier_thanos:GetModifierMoveSpeed_Absolute(params)
	return 460
end
