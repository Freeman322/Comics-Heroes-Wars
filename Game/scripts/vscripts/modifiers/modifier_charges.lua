modifier_charges = class({})

if IsServer() then
  function modifier_charges:Update()
    if self:GetDuration() == -1 then     
      local cooldown = self:GetAbility():GetCooldownTime() ---self:GetAbility().BaseClass.GetCooldown( self:GetAbility(), self:GetAbility():GetLevel() )
      
      self:SetDuration(cooldown, true)
      self:StartIntervalThink(cooldown)
    end

	  if self:GetStackCount() == self:GetAbility():GetSpecialValueFor("max_charges") then self:SetDuration(-1, true)
	    elseif self:GetStackCount() > self:GetAbility():GetSpecialValueFor("max_charges") then self:SetDuration(-1, true)  self:SetStackCount(self:GetAbility():GetSpecialValueFor("max_charges"))
	  end

    if self:GetStackCount() == 0 then self:GetAbility():StartCooldown(self:GetRemainingTime()) end 
    
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
    if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_charges") then
      self:SetDuration(self:GetAbility():GetCooldownTime(), true)
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
