LinkLuaModifier("modifier_item_bloody_tome", "items/item_bloody_tome" , 0)
LinkLuaModifier("modifier_item_bloody_tome_aura", "items/item_bloody_tome" , 0)

item_bloody_tome = class({})

function item_bloody_tome:GetIntrinsicModifierName() return "modifier_item_bloody_tome" end

function item_bloody_tome:OnHeroDiedNearby (hVictim, hKiller, kv)
    if hVictim == nil or hKiller == nil then
        return
    end

    if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
        self.range = self:GetSpecialValueFor ("soul_stole_range")
        local vToCaster = self:GetCaster ():GetOrigin () - hVictim:GetOrigin ()
        local flDistance = vToCaster:Length2D ()
        if hKiller == self:GetCaster () or self.range >= flDistance then
            self:SetCurrentCharges(self:GetCurrentCharges() + 1)

            self:GetCaster():CalculateStatBonus()

            self:GetCaster():FindModifierByName("modifier_item_bloody_tome"):ForceRefresh()
        end
    end
end

modifier_item_bloody_tome = class({})
 
function modifier_item_bloody_tome:GetEffectName()
    return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end 

function modifier_item_bloody_tome:IsPurgable() return false end
function modifier_item_bloody_tome:IsHidden()   return false end
function modifier_item_bloody_tome:RemoveOnDeath() return false end
function modifier_item_bloody_tome:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
    }
end

function modifier_item_bloody_tome:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_strength") end
function modifier_item_bloody_tome:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_item_bloody_tome:GetModifierBonusStats_Agility() return self:GetAbility():GetSpecialValueFor("bonus_agility") end
function modifier_item_bloody_tome:GetModifierHealthBonus() return self:GetAbility():GetSpecialValueFor("bonus_health") end
function modifier_item_bloody_tome:GetModifierManaBonus() return self:GetAbility():GetSpecialValueFor( "mana_bonus" ) end
function modifier_item_bloody_tome:GetModifierPercentageManacost() return self:GetAbility():GetSpecialValueFor( "manacost_reduction" ) end
function modifier_item_bloody_tome:GetModifierTotalPercentageManaRegen() return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_mana_regen_pct") end
function modifier_item_bloody_tome:GetModifierPercentageCooldownStacking() return self:GetAbility():GetSpecialValueFor("bonus_cooldown_reduction") end

function modifier_item_bloody_tome:GetModifierSpellAmplify_Percentage()
    return (self:GetAbility():GetSpecialValueFor ("bonus_amp") + (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_amp_per_soul")))
end

function modifier_item_bloody_tome:IsAura() return true end
function modifier_item_bloody_tome:GetAuraRadius() return 1200 end
function modifier_item_bloody_tome:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_bloody_tome:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_bloody_tome:GetAuraSearchFlags()	return 0 end
function modifier_item_bloody_tome:GetModifierAura() return "modifier_item_bloody_tome_aura" end

if modifier_item_bloody_tome_aura == nil then modifier_item_bloody_tome_aura = class({}) end

function modifier_item_bloody_tome_aura:IsHidden()
	return false
end

function modifier_item_bloody_tome_aura:IsPurgable()
	return false
end

function modifier_item_bloody_tome_aura:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

function modifier_item_bloody_tome_aura:GetModifierConstantManaRegen()	
    return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") 
end 