celebrimbor_overseer = class({})

LinkLuaModifier("modifier_celebrimbor_overseer", "abilities/celebrimbor_overseer.lua", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

function celebrimbor_overseer:GetAOERadius()
	return 1000
end

function celebrimbor_overseer:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function celebrimbor_overseer:OnInventoryContentsChanged()
    self:SetHidden(not self:GetCaster():HasScepter())
    self:SetLevel(1)
end

function celebrimbor_overseer:GetIntrinsicModifierName()
  return "modifier_celebrimbor_overseer_passive"
end

function celebrimbor_overseer:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	if hTarget:HasModifier("modifier_item_mind_gem_active") or hTarget:HasModifier("modifier_spawn_soul_trick") or hTarget:HasModifier("modifier_celebrimbor_overseer") then
		return UF_FAIL_DOMINATED
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function celebrimbor_overseer:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

--------------------------------------------------------------------------------

function celebrimbor_overseer:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

--------------------------------------------------------------------------------

function celebrimbor_overseer:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil or hTarget:TriggerSpellAbsorb( self ) then
		return
	end

	hTarget:AddNewModifier(hCaster, self, "modifier_celebrimbor_overseer", {duration = self:GetSpecialValueFor("duration")})
	
	hTarget:Interrupt()

	EmitSoundOn( "Hero_DarkWillow.WillOWisp.Damage", hCaster )
	EmitSoundOn( "Hero_DarkWillow.Fear.Cast", hTarget )
	EmitSoundOn( "Hero_DarkWillow.WispStrike.Cast", hTarget )

	hCaster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )
end

modifier_celebrimbor_overseer = class({})

function modifier_celebrimbor_overseer:IsPurgable()
    return false
end

function modifier_celebrimbor_overseer:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_statue_compendium_2014_radiant.vpcf"
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_overseer:StatusEffectPriority()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_overseer:GetHeroEffectName()
	return "particles/units/heroes/hero_night_stalker/nightstalker_darkness_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function modifier_celebrimbor_overseer:HeroEffectPriority()
	return 100
end


function modifier_celebrimbor_overseer:GetEffectName()
	return "particles/celembribor/deciver.vpcf"
end

function modifier_celebrimbor_overseer:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_celebrimbor_overseer:OnCreated( params )
    if IsServer() then
  		self.original_team = self:GetParent():GetTeamNumber()
  		self.target_team = self:GetAbility():GetCaster():GetTeamNumber()

  		self:GetParent():SetTeam(self.target_team)

  		local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		print(#units )
		if #units > 0 then
			if (self:HasHeroInList(units)) then 
				local target = self:GetFirstHero(units)
				print(target:GetUnitName())
				local order = 
				{
					UnitIndex = target:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = self:GetParent():entindex()
				}

				ExecuteOrderFromTable(order)
				self:GetParent():SetForceAttackTarget(target)
			else
				local target = self:GetFirstUnit(units)
				local order = 
				{
					UnitIndex = target:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = self:GetParent():entindex()
				}

				ExecuteOrderFromTable(order)
				self:GetParent():SetForceAttackTarget(target)
			end
		end
    end
end

function modifier_celebrimbor_overseer:HasHeroInList(list)
	if IsServer() then 
		for _,unit in pairs(list) do
			if unit:IsHero() then 
				return true
			end
		end	
		return false
	end
end

function modifier_celebrimbor_overseer:GetFirstHero(list)
	if IsServer() then 
		for _,unit in pairs(list) do
			if unit:IsHero() then 
				return unit
			end
		end	
		return nil
	end
end

function modifier_celebrimbor_overseer:GetFirstUnit(list)
	if IsServer() then 
		for _,unit in pairs(list) do
			return unit
		end	
		return nil
	end
end

function modifier_celebrimbor_overseer:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
    }

    return funcs
end

function modifier_celebrimbor_overseer:CheckState()
	local state = {
		[MODIFIER_STATE_DOMINATED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_FAKE_ALLY] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end

function modifier_celebrimbor_overseer:GetModifierProvidesFOWVision()
    return 1
end

function modifier_celebrimbor_overseer:OnDestroy()
  if IsServer() then
		self:GetParent():SetTeam(self.original_team)
		self:GetParent():SetForceAttackTarget(nil)
	end
end

function celebrimbor_overseer:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

