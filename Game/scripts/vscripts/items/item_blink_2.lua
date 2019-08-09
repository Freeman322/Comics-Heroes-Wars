if item_blink_2 == nil then
    item_blink_2 = class({})
end

function item_blink_2:IsRefreshable()
    return false
end

function item_blink_2:OnSpellStart()
    local hCaster = self:GetCaster() 
    local hTarget = false 
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
function item_blink_2:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

