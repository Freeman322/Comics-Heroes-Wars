LinkLuaModifier("modifier_venom_infest_venom", "abilities/venom_infest.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_venom_infest_buff", "abilities/venom_infest.lua", LUA_MODIFIER_MOTION_NONE)

venom_infest = class({})

function venom_infest:CastFilterResultTarget( hTarget )
   if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
    end

    if hTarget:HasModifier("modifier_item_mind_gem_active") or hTarget:HasModifier("modifier_spawn_soul_trick") or hTarget:HasModifier("modifier_celebrimbor_overseer") then
        return UF_FAIL_DOMINATED
    end

	if IsServer() then
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end

	return UF_SUCCESS
end

function venom_infest:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
	return ""
end

function venom_infest:IsStealable() return false end

function venom_infest:OnSpellStart()
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_venom_infest_venom", nil)
  self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_venom_infest_buff", nil)
  EmitSoundOn("Hero_LifeStealer.Infest", self:GetCursorTarget())
end

modifier_venom_infest_venom = class({})

function modifier_venom_infest_venom:RemoveOnDeath() return true end
function modifier_venom_infest_venom:IsPurgable() return false end
function modifier_venom_infest_venom:IsHidden() return true end

if IsServer() then
  function modifier_venom_infest_venom:OnCreated()
    self:GetParent():AddNoDraw()
    self:StartIntervalThink(FrameTime())
    self:GetAbility():SetActivated(false)
    self.target = self:GetAbility():GetCursorTarget()
  end

  function modifier_venom_infest_venom:OnIntervalThink()
    if self.target:IsAlive() == false then
      self:Destroy()
    end
    self:GetParent():SetAbsOrigin(Vector(self.target:GetAbsOrigin().x, self.target:GetAbsOrigin().y, self.target:GetAbsOrigin().z + 128))
    if self:GetCaster():HasModifier("modifier_venom_infest_venom") then
      self:GetCaster():FindAbilityByName("venom_out"):SetActivated(true)
    else
      self:GetCaster():FindAbilityByName("venom_out"):SetActivated(false)
    end
  end

  function modifier_venom_infest_venom:OnDestroy()
    self:GetParent():RemoveNoDraw()
    self:GetAbility():SetActivated(true)
    self:GetCaster():FindAbilityByName("venom_out"):SetActivated(false)
    self.target:RemoveModifierByName("modifier_venom_infest_buff")
    self.target = nil
  end
end

function modifier_venom_infest_venom:CheckState()
  return {
	  [MODIFIER_STATE_ROOTED] = true,
    [MODIFIER_STATE_DISARMED]	= true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
    [MODIFIER_STATE_UNSELECTABLE]	= true,
    [MODIFIER_STATE_OUT_OF_GAME]	= true,
    [MODIFIER_STATE_NO_HEALTH_BAR]	= true,
    [MODIFIER_STATE_INVULNERABLE]	= true
	}
end

modifier_venom_infest_buff = class({})

function modifier_venom_infest_buff:IsHidden() return false end
function modifier_venom_infest_buff:IsPurgable() return false end
function modifier_venom_infest_buff:RemoveOnDeath() return true end

function modifier_venom_infest_buff:DeclareFunctions()
  return {
      MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
      MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
      MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
  }
end

function modifier_venom_infest_buff:GetModifierBonusStats_Strength()
  local mult = self:GetAbility():GetSpecialValueFor("stats") / 100
  if self:GetCaster():IsHasSuperStatus() then mult = mult + mult end
  return self:GetCaster():GetStrength() * mult
end
function modifier_venom_infest_buff:GetModifierBonusStats_Agility()
  local mult = self:GetAbility():GetSpecialValueFor("stats") / 100
  if self:GetCaster():IsHasSuperStatus() then mult = mult + mult end
  return self:GetCaster():GetAgility() * mult
end
function modifier_venom_infest_buff:GetModifierBonusStats_Intellect()
  local mult = self:GetAbility():GetSpecialValueFor("stats") / 100
  if self:GetCaster():IsHasSuperStatus() then mult = mult + mult end
  return self:GetCaster():GetIntellect() * mult
end

function modifier_venom_infest_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end



venom_out = class({})

function venom_out:IsStealable() return false end
function venom_out:GetBehavior() return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
function venom_out:OnInventoryContentsChanged() self:SetHidden(not self:GetCaster():HasScepter()) self:SetLevel(1) end

function venom_out:OnSpellStart()
  self:GetCaster():RemoveModifierByName("modifier_venom_infest_venom")
  EmitSoundOn("Hero_LifeStealer.Consume", self:GetCaster())
end
