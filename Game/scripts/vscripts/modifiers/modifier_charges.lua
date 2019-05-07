modifier_charges = class({})

if IsServer() then
  function modifier_charges:Update()
    if self:GetDuration() == -1 then
		  local cooldown_reduction = 1
		  if self:GetParent():HasModifier("modifier_item_octarine_core") or self:GetParent():HasModifier("modifier_item_bloodstaff") then	cooldown_reduction = 0.75
		  elseif self:GetParent():HasModifier("modifier_item_aether_medallion") or self:GetParent():HasModifier("modifier_item_adamachi_core") then cooldown_reduction = 0.7
      end
      if self:GetParent():HasModifier("modifier_rough_cooldown_aura_passive") then
        cooldown_reduction = cooldown_reduction * 0.84
      end
      if self:GetParent():HasAbility("special_bonus_cooldown_reduction_15") and self:GetParent():FindAbilityByName("special_bonus_cooldown_reduction_15"):GetLevel() > 0 then
        cooldown_reduction = cooldown_reduction * 0.85
      end
      if self:GetParent():HasAbility("special_bonus_cooldown_reduction_25") and self:GetParent():FindAbilityByName("special_bonus_cooldown_reduction_25"):GetLevel() > 0 then
        cooldown_reduction = cooldown_reduction * 0.75
      end
      if self:GetParent():HasAbility("special_bonus_cooldown_reduction_30") and self:GetParent():FindAbilityByName("special_bonus_cooldown_reduction_30"):GetLevel() > 0 then
        cooldown_reduction = cooldown_reduction * 0.70
      end

      self:SetDuration(self:GetAbility():GetSpecialValueFor("recharge_time") * cooldown_reduction, true)
      self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("recharge_time") * cooldown_reduction)
    end

	  if self:GetStackCount() == self:GetAbility():GetSpecialValueFor("max_charges") then
      self:SetDuration(-1, true)
	  elseif self:GetStackCount() > self:GetAbility():GetSpecialValueFor("max_charges") then
		  self:SetDuration(-1, true)
		  self:SetStackCount(self:GetAbility():GetSpecialValueFor("max_charges"))
	  end

    if self:GetStackCount() == 0 then
      self:GetAbility():StartCooldown(self:GetRemainingTime())
    end
    self:GetParent():CalculateStatBonus()
  end

  function modifier_charges:OnCreated()
    self:SetStackCount(self:GetAbility():GetSpecialValueFor("max_charges"))
    if self:GetStackCount() ~= self:GetAbility():GetSpecialValueFor("max_charges") then
      self:Update()
    end
  end

  function modifier_charges:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end

  function modifier_charges:OnAbilityFullyCast(params)
    if params.unit == self:GetParent() then
      if params.ability == self:GetAbility() then
        self:DecrementStackCount()
	       params.ability:EndCooldown()
         self:Update()
		  elseif params.ability:GetName() == "item_refresher" and self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_charges") then
        self:IncrementStackCount()
        self:Update()
      end
    end
    return 0
  end

  function modifier_charges:OnIntervalThink()
    local cooldown_reduction = 1
    if self:GetParent():HasModifier("modifier_item_octarine_core") or self:GetParent():HasModifier("modifier_item_bloodstaff") then	cooldown_reduction = 0.75
    elseif self:GetParent():HasModifier("modifier_item_aether_medallion") or self:GetParent():HasModifier("modifier_item_adamachi_core") then cooldown_reduction = 0.7
    end
    if self:GetParent():HasModifier("modifier_rough_cooldown_aura_passive") then
      cooldown_reduction = cooldown_reduction * 0.84
    end
    if self:GetParent():HasAbility("special_bonus_cooldown_reduction_15") and self:GetParent():FindAbilityByName("special_bonus_cooldown_reduction_15"):GetLevel() > 0 then
      cooldown_reduction = cooldown_reduction * 0.85
    end
    if self:GetParent():HasAbility("special_bonus_cooldown_reduction_25") and self:GetParent():FindAbilityByName("special_bonus_cooldown_reduction_25"):GetLevel() > 0 then
      cooldown_reduction = cooldown_reduction * 0.75
    end
    if self:GetParent():HasAbility("special_bonus_cooldown_reduction_30") and self:GetParent():FindAbilityByName("special_bonus_cooldown_reduction_30"):GetLevel() > 0 then
      cooldown_reduction = cooldown_reduction * 0.70
    end

    if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_charges") then
      self:SetDuration(self:GetAbility():GetSpecialValueFor("recharge_time") * cooldown_reduction, true)
      self:IncrementStackCount()

      if self:GetStackCount() == self:GetAbility():GetSpecialValueFor("max_charges") then
        self:SetDuration(-1, true)
        self:StartIntervalThink(-1)
      end
    end
    self:GetParent():CalculateStatBonus()
  end
end

function modifier_charges:DestroyOnExpire() return false end
function modifier_charges:IsPurgable() return false end
function modifier_charges:RemoveOnDeath() return false end
function modifier_charges:IsDebuff() return false end
