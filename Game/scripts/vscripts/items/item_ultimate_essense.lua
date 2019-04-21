LinkLuaModifier ("modifier_aghanim", "modifiers/modifier_aghanim.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_ultimate_essense", "items/item_ultimate_essense.lua", LUA_MODIFIER_MOTION_NONE)


if item_ultimate_essense == nil then
    item_ultimate_essense = class ( {})
end
  
function item_ultimate_essense:GetIntrinsicModifierName ()
    return "modifier_item_ultimate_essense"
end


if modifier_item_ultimate_essense == nil then
    modifier_item_ultimate_essense = class ( {})
end


function modifier_item_ultimate_essense:IsHidden ()
    return true
end


function modifier_item_ultimate_essense:RemoveOnDeath ()
    return true
end


function modifier_item_ultimate_essense:OnCreated(table)
    if IsServer() then
        if not self:GetParent():HasModifier("modifier_aghanim") then
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_aghanim", nil)
            self:GetAbility():RemoveSelf()
            self:Destroy()
            return
        else
            self:GetParent():SellItem(self:GetAbility())
        end
    end
end

function item_ultimate_essense:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

