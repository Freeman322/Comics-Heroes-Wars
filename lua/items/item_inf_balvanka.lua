if item_inf_balvanka == nil then item_inf_balvanka = class({}) end

function item_inf_balvanka:OnOwnerDied()
  if IsServer() then
    local itemName = tostring(self:GetAbilityName())
    if self:GetCaster():IsHero() or self:GetCaster():HasInventory() then
      if not self:GetCaster():IsReincarnating() then
        local newItem = CreateItem(itemName, nil, nil)
        CreateItemOnPositionSync(self:GetCaster():GetOrigin(), newItem)
        self:GetCaster():RemoveItem(self)
      end
    end
  end
end

function item_inf_balvanka:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

