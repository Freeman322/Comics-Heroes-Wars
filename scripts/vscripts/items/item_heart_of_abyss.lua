LinkLuaModifier ("modifier_item_heart_of_abyss", "items/item_heart_of_abyss.lua", LUA_MODIFIER_MOTION_NONE)
if item_heart_of_abyss == nil then
    item_heart_of_abyss = class ( {})
end
function item_heart_of_abyss:GetIntrinsicModifierName ()
    return "modifier_item_heart_of_abyss"
end

function item_heart_of_abyss:OnSpellStart ()
    EmitSoundOn ("DOTA_Item.Refresher.Activate", self:GetCaster () )
    local nFXIndex = ParticleManager:CreateParticle ("particles/refresh_2.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster ());
    ParticleManager:SetParticleControlEnt (nFXIndex, 0, self:GetCaster (), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster ():GetOrigin (), true);
    ParticleManager:ReleaseParticleIndex (nFXIndex);
    self:GetCaster ():StartGesture (ACT_DOTA_OVERRIDE_ABILITY_3);

    for i=0, 15, 1 do  
        local current_ability = self:GetCaster ():GetAbilityByIndex (i)
        if current_ability ~= nil then
            if current_ability:IsRefreshable() then 
                current_ability:EndCooldown ()
            end
        end
    end

    for i=0, 5, 1 do
        local current_item = self:GetCaster ():GetItemInSlot (i)
        if current_item ~= nil and current_item:IsRefreshable() then
            if current_item ~= self and current_item:GetSharedCooldownName() ~= "refresher" then current_item:EndCooldown() end 
        end
    end

    self:GetCaster ():SetMana (self:GetCaster ():GetMaxMana ())
    self:GetCaster ():SetHealth (self:GetCaster ():GetMaxHealth ())
end

if modifier_item_heart_of_abyss == nil then
    modifier_item_heart_of_abyss = class ( {})
end

function modifier_item_heart_of_abyss:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_heart_of_abyss:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }

    return funcs
end

function modifier_item_heart_of_abyss:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_heart_of_abyss:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_heart_of_abyss:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_heart_of_abyss:GetModifierConstantHealthRegen (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_health_regen")
end

function modifier_item_heart_of_abyss:GetModifierConstantManaRegen (params)
    local hAbility = self:GetAbility ()
    local hCaster = self:GetParent ()
    return hCaster:GetMaxMana () * (hAbility:GetSpecialValueFor ("mana_regen")/100)
end


function modifier_item_heart_of_abyss:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_heart_of_abyss:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

