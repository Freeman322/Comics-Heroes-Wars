LinkLuaModifier("modifier_item_mystic_ring", "items/item_mystic_ring" , 0)
LinkLuaModifier("modifier_item_mystic_ring_aura", "items/item_mystic_ring" , 0)
 
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
 
function modifier_item_mystic_ring:GetEffectName()
    return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end 

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
        MODIFIER_EVENT_ON_HERO_KILLED,
    }
end
 
 
function modifier_item_mystic_ring:GetModifierSpellAmplify_PercentageUnique() return self:GetAbility():GetSpecialValueFor("bonus_amp") end
function modifier_item_mystic_ring:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_mystic_ring:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_item_mystic_ring:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
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

if modifier_item_mystic_ring_aura == nil then modifier_item_mystic_ring_aura = class({}) end

function modifier_item_mystic_ring_aura:IsAura()
	return true
end

function modifier_item_mystic_ring_aura:IsHidden()
	return true
end

function modifier_item_mystic_ring_aura:IsPurgable()
	return false
end

function modifier_item_mystic_ring_aura:GetAuraRadius()
	return 1200
end

function modifier_item_mystic_ring_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_mystic_ring_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_item_mystic_ring_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_mystic_ring_aura:DeclareFunctions ()
    local funcs = {
       MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }

function modifier_item_mystic_ring_aura:GetModifierConstantManaRegen()	
    return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
end 