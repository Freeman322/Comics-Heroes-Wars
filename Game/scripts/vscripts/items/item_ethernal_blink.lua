if item_ethernal_blink == nil then
    item_ethernal_blink = class({})
end

LinkLuaModifier( "item_ethernal_blink_modifier", "items/item_ethernal_blink.lua", LUA_MODIFIER_MOTION_NONE )

function item_ethernal_blink:GetIntrinsicModifierName()
    return "item_ethernal_blink_modifier"
end

function item_ethernal_blink:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local hTarget = false --We might not have target so we make fail-safe so we do not get an error when calling - self:GetCursorTarget()
    if not self:GetCursorTargetingNothing() then
        hTarget = self:GetCursorPosition()
    end
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hCaster)
    hCaster:EmitSound("DOTA_Item.BlinkDagger.Activate")
    if hTarget then
        hCaster:SetAbsOrigin(hTarget)
        FindClearSpaceForUnit(hCaster, hCaster:GetAbsOrigin(), false)
    end
end
function item_ethernal_blink:OnOwnerDied(keys)
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
item_ethernal_blink_modifier = class({})

function item_ethernal_blink_modifier:DeclareFunctions()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function item_ethernal_blink_modifier:IsHidden()
    return true
end

function item_ethernal_blink_modifier:OnTakeDamage( event )
    local attacker_name = event.attacker:GetName()
    if event.unit == self:GetParent() then
      if event.damage > 0 and (attacker_name == "npc_dota_roshan" or event.attacker:IsControllableByAnyPlayer()) then
          if self:GetAbility():GetCooldownTimeRemaining() < 12 then
              self:GetAbility():StartCooldown(9)
          end
      end
    end
end

function item_ethernal_blink_modifier:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function item_ethernal_blink:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

