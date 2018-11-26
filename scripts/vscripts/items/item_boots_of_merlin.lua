LinkLuaModifier("modifier_boots_of_merlin", "items/item_boots_of_merlin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boots_of_merlin_aura", "items/item_boots_of_merlin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boots_of_merlin_buff", "items/item_boots_of_merlin", LUA_MODIFIER_MOTION_NONE)

item_boots_of_merlin = class ({})

function item_boots_of_merlin:GetIntrinsicModifierName()
    return "modifier_boots_of_merlin"
end

function item_boots_of_merlin:OnSpellStart()
    if IsServer() then
        local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetSpecialValueFor("active_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
        if #allies > 0 then
            for _,unit in pairs(allies) do
                unit:GiveMana(unit:GetMaxMana() * (self:GetSpecialValueFor("mana_restore_pct") / 100))
            end
        end
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_boots_of_merlin_buff", nil)
    end
end

modifier_boots_of_merlin_buff = class({})

function modifier_boots_of_merlin_buff:IsHidden() return false end
function modifier_boots_of_merlin_buff:IsPurgable() return true end
function modifier_boots_of_merlin_buff:RemoveOnDeath() return true end

function modifier_boots_of_merlin_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
    }
    return funcs
end

function modifier_boots_of_merlin_buff:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor("spell_amp_active")
end

function modifier_boots_of_merlin_buff:GetModifierPercentageCooldownStacking()
    return self:GetAbility():GetSpecialValueFor("cd_reduce_active")
end

function modifier_boots_of_merlin_buff:OnAbilityFullyCast(params)
    if IsServer() then 
        if params.unit == self:GetParent() and params.unit:HasModifier("modifier_boots_of_merlin_buff") then 
            self:GetParent():RemoveModifierByName("modifier_boots_of_merlin_buff")
        end
    end 
end

modifier_boots_of_merlin = class ({})

function modifier_boots_of_merlin:IsAura() return true end
function modifier_boots_of_merlin:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_boots_of_merlin:GetAuraDuration() return 0.5 end
function modifier_boots_of_merlin:IsHidden() return true end
function modifier_boots_of_merlin:RemoveOnDeath() return false end 
function modifier_boots_of_merlin:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_boots_of_merlin:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_boots_of_merlin:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_boots_of_merlin:GetModifierAura() return "modifier_boots_of_merlin_aura" end

function modifier_boots_of_merlin:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end

function modifier_boots_of_merlin:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_boots_of_merlin:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_agi")
end

function modifier_boots_of_merlin:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_boots_of_merlin:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_boots_of_merlin:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_boots_of_merlin:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_move_speed")
end

modifier_boots_of_merlin_aura = class ({})

function modifier_boots_of_merlin_aura:IsPurgable() return false end

function modifier_boots_of_merlin_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_boots_of_merlin_aura:GetModifierPhysicalArmorBonus()
    if self:GetParent():GetHealthPercent() < self:GetAbility():GetSpecialValueFor("health_threshold") then
        return self:GetAbility():GetSpecialValueFor("aura_armor+")
    else
        return self:GetAbility():GetSpecialValueFor("aura_armor")
    end
end

function modifier_boots_of_merlin_aura:GetModifierConstantHealthRegen()
    if self:GetParent():GetHealthPercent() < self:GetAbility():GetSpecialValueFor("health_threshold") then
        return self:GetAbility():GetSpecialValueFor("aura_hp_regen+")
    else
        return self:GetAbility():GetSpecialValueFor("aura_hp_regen")
    end
end