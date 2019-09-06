LinkLuaModifier("modifier_death_eater_debuff", "abilities/death_eater_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death_eater_aura", "abilities/death_eater_aura.lua", LUA_MODIFIER_MOTION_NONE)

death_eater_aura = class({})

function death_eater_aura:GetIntrinsicModifierName() return "modifier_death_eater_aura" end

modifier_death_eater_aura = class({})

function modifier_death_eater_aura:IsAura()	return true end
function modifier_death_eater_aura:IsHidden()	return true end
function modifier_death_eater_aura:IsPurgable()	return false end

function modifier_death_eater_aura:GetEffectName()
    return "particles/econ/items/necrolyte/necro_ti9_immortal/necro_ti9_immortal_ambient.vpcf"
end 

function modifier_death_eater_aura:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_death_eater_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_death_eater_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_death_eater_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_death_eater_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_death_eater_aura:GetModifierAura() return "modifier_death_eater_debuff" end

if modifier_death_eater_debuff == nil then
modifier_death_eater_debuff = class({})

function modifier_death_eater_debuff:IsPurgable() return false end
function modifier_death_eater_debuff:IsHidden() return true end

function modifier_death_eater_debuff:GetEffectName()
    return "particles/units/heroes/hero_necrolyte/necrolyte_spirit_debuff_rings.vpcf"
end


function modifier_death_eater_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_death_eater_debuff:OnCreated(table)
    if IsServer() then
        self:StartIntervalThink(0.1)
        self:OnIntervalThink()
    end
end

function modifier_death_eater_debuff:OnIntervalThink()
    if IsServer() then
        ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = (self:GetParent():GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("plague_damage")/100))})
    end
end

function modifier_death_eater_debuff:DeclareFunctions() return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_bonus} end
function modifier_death_eater_debuff:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("armor_reduction") * -1 end
function modifier_death_eater_debuff:GetModifierMagicalResistanceBonus() return self:GetAbility():GetSpecialValueFor("magic_resistance") * -1 end
function modifier_death_eater_debuff:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
end