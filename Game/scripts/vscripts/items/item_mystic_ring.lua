LinkLuaModifier("modifier_item_mystic_ring", "items/item_mystic_ring" , 0)
 
item_mystic_ring = class({})
 
function item_mystic_ring:GetIntrinsicModifierName() return "modifier_item_mystic_ring" end
 
 function item_mystic_ring:OnOwnerDied()
    if IsServer() then
        local mod = self:GetCaster():FindModifierByName("modifier_item_mystic_ring")
       
        if mod then
            mod:SetStackCount(mod:GetStackCount() / 2)
        end
    end
end
 
modifier_item_mystic_ring = class({})
 
function modifier_item_mystic_ring:IsPurgable() return false end
function modifier_item_mystic_ring:IsHidden()   return false end
function modifier_item_mystic_ring:RemoveOnDeath() return false end
function modifier_item_mystic_ring:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
        MODIFIER_EVENT_ON_HERO_KILLED,
    }
end
 
 
function modifier_item_mystic_ring:GetModifierSpellAmplify_Percentage_Unique() return self:GetAbility():GetSpecialValueFor("bonus_amp") end
function modifier_item_mystic_ring:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_mystic_ring:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_item_mystic_ring:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_item_mystic_ring:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_item_mystic_ring:GetModifierPercentageManacost() return self:GetAbility():GetSpecialValueFor("bonus_mana_cost_reduction") end
function modifier_item_mystic_ring:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_item_mystic_ring:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_item_mystic_ring:GetModifierPercentageCooldownStacking() return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("bonus_cooldown_reduction_per_soul") or 1) end
function modifier_item_mystic_ring:GetModifierSpellAmplify_Percentage() return self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("bonus_amp_per_soul") or 1) end
function modifier_item_mystic_ring:OnHeroKilled(params)
    if params.target:GetTeam() ~= self:GetParent():GetTeam() then
        if params.attacker == self:GetParent() then
            if self:GetStackCount() < 10 then
            self:SetStackCount(self:GetStackCount() + 1)
            end
        end
    end
function item_mystic_ring:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self) end 
end
