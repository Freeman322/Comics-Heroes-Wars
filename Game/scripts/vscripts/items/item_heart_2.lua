LinkLuaModifier ("modifier_item_heart_2", "items/item_heart_2.lua", LUA_MODIFIER_MOTION_NONE)
if item_heart_2 == nil then
    item_heart_2 = class({})
end

function item_heart_2:GetIntrinsicModifierName ()
    return "modifier_item_heart_2"
end

if modifier_item_heart_2 == nil then
    modifier_item_heart_2 = class ( {})
end
function modifier_item_heart_2:IsPurgable() return false end
function modifier_item_heart_2:IsHidden ()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_heart_2:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
        ---MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_item_heart_2:GetModifierBonusStats_Strength (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_heart_2:OnCreated(params)
    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function modifier_item_heart_2:OnIntervalThink()
    if IsServer() then
        if self:GetAbility():IsCooldownReady() then
            self:SetStackCount(1)
        else
            self:SetStackCount(0)
        end
    end
end

function modifier_item_heart_2:GetModifierBonusStats_Intellect (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_all_stats")
end
function modifier_item_heart_2:GetModifierBonusStats_Agility (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_all_stats")
end

function modifier_item_heart_2:GetModifierHealthRegenPercentage (params)
    if self:GetStackCount() == 1 then
        return self:GetAbility():GetSpecialValueFor ("health_regen_percent_per_second")
    end
    return
end

function modifier_item_heart_2:GetModifierTotalPercentageManaRegen (params)
    return self:GetAbility():GetSpecialValueFor ("mana_reget_percent_per_second")
end

function modifier_item_heart_2:OnTakeDamage (params)
    if IsServer () then
        if params.unit == self:GetParent() and not self:GetParent() ~= params.attacker then
            if params.attacker:IsHero() then
               self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
           end
        end
    end
end

function modifier_item_heart_2:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_heart_2:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
