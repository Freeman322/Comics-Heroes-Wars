if item_book_of_knowledge == nil then item_book_of_knowledge = class({}) end
LinkLuaModifier ("modifier_item_book_of_knowledge", "items/item_book_of_knowledge.lua", LUA_MODIFIER_MOTION_NONE)

function item_book_of_knowledge:OnOwnerDied()
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

function item_book_of_knowledge:GetIntrinsicModifierName ()
    return "modifier_item_book_of_knowledge"
end

if modifier_item_book_of_knowledge == nil then
    modifier_item_book_of_knowledge = class ( {})
end

function modifier_item_book_of_knowledge:IsHidden()
    return true
end

function modifier_item_book_of_knowledge:IsPurgable()
    return false
end

function modifier_item_book_of_knowledge:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end

function modifier_item_book_of_knowledge:GetModifierBonusStats_Intellect (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_intellect")
end
