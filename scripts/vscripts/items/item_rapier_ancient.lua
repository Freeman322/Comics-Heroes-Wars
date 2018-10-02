if item_rapier_ancient == nil then item_rapier_ancient = class({}) end

LinkLuaModifier("modifier_item_rapier_ancient", "items/item_rapier_ancient.lua", LUA_MODIFIER_MOTION_NONE)

function item_rapier_ancient:OnOwnerDied()
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

function item_rapier_ancient:GetIntrinsicModifierName()
   return "modifier_item_rapier_ancient"
end

if modifier_item_rapier_ancient == nil then modifier_item_rapier_ancient = class({}) end


function modifier_item_rapier_ancient:GetEffectName()
    return "particles/items2_fx/radiance_owner.vpcf"
end

function modifier_item_rapier_ancient:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_rapier_ancient:DeclareFunctions()
	local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
	return funcs
end

function modifier_item_rapier_ancient:IsHidden()
	return true
end

function modifier_item_rapier_ancient:IsPurgable()
	return false
end

function modifier_item_rapier_ancient:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_rapier_ancient:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("dmg") 
end

function item_rapier_ancient:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

