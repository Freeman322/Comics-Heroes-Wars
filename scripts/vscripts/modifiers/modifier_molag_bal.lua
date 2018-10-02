if modifier_molag_bal == nil then modifier_molag_bal = class({}) end

function modifier_molag_bal:IsPurgable()
	return false;
end

function modifier_molag_bal:IsHidden()
	return true;
end

function modifier_molag_bal:RemoveOnDeath()
	return false;
end

function modifier_molag_bal:FindUnits(radius)
  if IsServer() then
    local count = 0;    
  	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
    count = #units
    return count;
  end
end

function modifier_molag_bal:GetUnitForCast()
  if IsServer() then
    local unit;
    local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 99999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
    if #units > 0 then
      unit = units[1]
    end
    return unit;  
  end
end

function modifier_molag_bal:OnCreated( kv )
  if IsServer() then
        self.heroes = HeroList:GetAllHeroes()
        self.Ability1 = self:GetParent():FindAbilityByName("molag_bal_chronosphere")
        self.Ability2 = self:GetParent():FindAbilityByName("molag_bal_wall_of_replica")
        self.Ability3 = self:GetParent():FindAbilityByName("molag_bal_vacuum")
        for i=0, 15, 1 do
            local current_ability = self:GetParent():GetAbilityByIndex(i)
            if current_ability ~= nil then
                current_ability:SetLevel(1)
            end
        end

        self:StartIntervalThink( 1.0 )
        
        Timers:CreateTimer(14, function ()
          if self:GetParent():IsAlive() then 
            local random = RandomInt(1, 16)
            print("Molag.Sound" .. random)
            EmitAnnouncerSound("Molag.Sound" .. random)
          else
            return nil
          end
          return 7
        end)
	end
end

function modifier_molag_bal:OnIntervalThink()
    if IsServer() then
      if self:FindUnits(500) > 1 and self.Ability3:IsCooldownReady() then
        local unit = self:GetUnitForCast()
        ExecuteOrderFromTable({
          UnitIndex = self:GetParent():entindex(),
          OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
          Position = unit:GetOrigin(),
          AbilityIndex = self.Ability3:entindex()
        })
      end

      if self:FindUnits(500) > 3 and self.Ability1:IsCooldownReady() then
        local unit = self:GetUnitForCast()
        ExecuteOrderFromTable({
          UnitIndex = self:GetParent():entindex(),
          OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
          Position = unit:GetOrigin(),
          AbilityIndex = self.Ability1:entindex()
        })
      end

      if self:FindUnits(300) > 4 and self.Abilit2:IsCooldownReady() then
        local unit = self:GetUnitForCast()
        ExecuteOrderFromTable({
          UnitIndex = self:GetParent():entindex(),
          OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
          Position = unit:GetOrigin(),
          AbilityIndex = self.Ability2:entindex()
        })
      end
    end
  end

function modifier_molag_bal:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_molag_bal:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_molag_bal:GetAbsoluteNoDamagePure(params)
	return 1
end


function modifier_molag_bal:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
  }

  return funcs
end


function modifier_molag_bal:GetModifierBaseAttack_BonusDamage( params )
  return GameRules:GetGameTime() * 15
end

function modifier_molag_bal:GetAbsoluteNoDamagePure( params )
  return 1
end