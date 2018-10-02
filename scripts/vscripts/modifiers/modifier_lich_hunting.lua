if modifier_lich_hunting == nil then modifier_lich_hunting = class({}) end

killed_targets = {}
current_target = -1

function modifier_lich_hunting:IsPurgable()
	return false;
end

function modifier_lich_hunting:IsHidden()
	return true;
end

function modifier_lich_hunting:OnCreated( kv )
  if IsServer() then
    self.heroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 999999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
		self.desired_units = 0
		self.flAccumDamage = 0
		self.nBagsDropped = 0
    self.time_limit = 300
    for _, target in pairs(self.heroes) do
      if killed_targets[target] == nil and target:IsRealHero() then
        self:SelectTarget(target)
        break
      end
    end
		self.flExpireTime = GameRules:GetGameTime() + self.time_limit
		self:StartIntervalThink( 1.0 )
	end
end

function modifier_lich_hunting:SelectTarget(target)
  current_target = target;
  killed_targets[target] = true;
  if IsServer() then
    Notifications:BottomToAll({text="Lich King is to take away the soul of ", duration=5, style={color="red", ["font-size"]="34px", border="0px solid blue"}})
    Notifications:BottomToAll({hero=target:GetUnitName(),continue=true, imagestyle="landscape", duration=5})
    EmitSoundOn("Event.Lich_king.Find_Target", current_target)
    ExecuteOrderFromTable({
      UnitIndex = self:GetParent():entindex(),
  		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
  		TargetIndex = current_target:entindex()
			})
  end
end

function modifier_lich_hunting:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
		MODIFIER_EVENT_ON_HERO_KILLED
	}

	return funcs
end

function modifier_lich_hunting:OnHeroKilled(params)
	if params.attacker == self:GetParent() then
		 ---self:FindNextTarget()
	end
end

function modifier_lich_hunting:OnIntervalThink()
	if IsServer() then
		if current_target:IsAlive() == false then
			self.desired_units = self.desired_units + 1
      self:FindNextTarget()
    else
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = current_target:entindex()
				})
		end
		if GameRules:GetGameTime() > self.flExpireTime then
			self:OnHuntingEnd()
		end
		if self.desired_units == #self.heroes then
			self:OnHuntingEnd()
		end
	end
end

function modifier_lich_hunting:FindNextTarget()
 if IsServer() then
   for _, target in pairs(self.heroes) do
     if killed_targets[target] == nil and target:IsRealHero() then
       self:SelectTarget(target)
       break
     end
   end
 end
end

function modifier_lich_hunting:OnHuntingEnd()
	if IsServer() then
		local rad_spawn = Vector(-64, -5312, 256)
    local dire_spawn = Vector(771.864, -3497.28, 256)
    local heroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 999999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
    for _, hero in pairs(heroes) do
      if hero:GetTeamNumber() == 2 then
        hero:SetAbsOrigin(rad_spawn)
        hero:RefreshUnit()
      else
        hero:SetAbsOrigin(dire_spawn)
        hero:RefreshUnit()
      end
      FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
    end
    Notifications:BottomToAll({text="Kill The Lich King!", duration=5, style={color="red", ["font-size"]="42px", border="0px solid blue"}})
	end
  self:Destroy()
end

function modifier_lich_hunting:OnDestroy()
  if IsServer() then
    local vPos = Vector(378.02, -4706.17, 256)
    self:GetParent():SetAbsOrigin(vPos)
    self:GetParent():AddNewModifier(nil, nil, "modifier_lich_event", {duration = 300})
  end
end

function modifier_lich_hunting:GetModifierMoveSpeed_Absolute( params )
	return 480
end

function modifier_lich_hunting:GetMinHealth( params )
	return self:GetParent():GetMaxHealth()
end

function modifier_lich_hunting:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[MODIFIER_STATE_STUNNED] = false,
			[MODIFIER_STATE_ROOTED] = false,
      [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		}
		if GameRules:GetGameTime() > self.flExpireTime then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end

	return state
end

function modifier_lich_hunting:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
