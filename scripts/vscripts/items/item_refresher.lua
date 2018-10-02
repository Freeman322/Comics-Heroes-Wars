if item_refresher == nil then
    item_refresher = class ( {})
end
function item_refresher:GetIntrinsicModifierName ()
    return "modifier_item_refresherorb"
end

function item_refresher:OnSpellStart ()
    EmitSoundOn ("DOTA_Item.Refresher.Activate", self:GetCaster () )
    local nFXIndex = ParticleManager:CreateParticle ("particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster ());
    ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true);
    ParticleManager:ReleaseParticleIndex (nFXIndex);

    for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
        local current_ability = self:GetCaster ():GetAbilityByIndex (i)
        if current_ability ~= nil then
            if (current_ability:GetName () ~= "zoom_charge_of_darkness" or current_ability:GetName () ~= "lich_king_reincarnation") and current_ability:IsRefreshable() then 
                current_ability:EndCooldown ()
            end
        end
    end
    for i=0, 5, 1 do
        local current_item = self:GetCaster ():GetItemInSlot (i)
        if current_item ~= nil then
            if current_item:GetName () == "item_refresher" or current_item:GetName () == "item_heart_of_abyss"  then
                current_item:StartCooldown(195)
            else
                current_item:EndCooldown ()
            end
        end
    end
end
function item_refresher:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

