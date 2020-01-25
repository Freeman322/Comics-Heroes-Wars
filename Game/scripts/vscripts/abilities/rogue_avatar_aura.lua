LinkLuaModifier ("modifier_rogue_avatar_aura_aura", 				"abilities/rogue_avatar_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_rogue_avatar_aura_passive", "abilities/rogue_avatar_aura.lua", LUA_MODIFIER_MOTION_NONE)

if rogue_avatar_aura == nil then rogue_avatar_aura = class({}) end

function rogue_avatar_aura:GetIntrinsicModifierName()
    return "modifier_rogue_avatar_aura_aura"
end

if modifier_rogue_avatar_aura_aura == nil then modifier_rogue_avatar_aura_aura = class({}) end

function modifier_rogue_avatar_aura_aura:IsAura()
    return true
end

function modifier_rogue_avatar_aura_aura:IsHidden()
    return true
end

function modifier_rogue_avatar_aura_aura:IsPurgable()
    return false
end

function modifier_rogue_avatar_aura_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_rogue_avatar_aura_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_rogue_avatar_aura_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_rogue_avatar_aura_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_rogue_avatar_aura_aura:GetModifierAura()
    return "modifier_rogue_avatar_aura_passive"
end

if modifier_rogue_avatar_aura_passive == nil then modifier_rogue_avatar_aura_passive = class({}) end

function modifier_rogue_avatar_aura_passive:IsHidden()
    return true
end

function modifier_rogue_avatar_aura_passive:IsPurgable()
    return false
end

function modifier_rogue_avatar_aura_passive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }

    return funcs
end

function modifier_rogue_avatar_aura_passive:OnCreated(params)
    if IsServer() then
        local mult = self:GetAbility():GetSpecialValueFor("main_attr") / 100

        if self:GetParent():GetPrimaryAttribute() == 0 then
            self:SetStackCount(math.floor(mult * self:GetParent():GetStrength()))
        elseif self:GetParent():GetPrimaryAttribute() == 1 then
            self:SetStackCount(math.floor(mult * self:GetParent():GetAgility()))
        elseif self:GetParent():GetPrimaryAttribute() == 2 then
            self:SetStackCount(math.floor(mult * self:GetParent():GetIntellect()))
        end

        self:GetParent():CalculateStatBonus()
    end
end

function modifier_rogue_avatar_aura_passive:GetModifierBonusStats_Agility()
    if self:GetParent():GetPrimaryAttribute() == 1 then
        return self:GetStackCount()
    end
end

function modifier_rogue_avatar_aura_passive:GetModifierBonusStats_Intellect_()
    if self:GetParent():GetPrimaryAttribute() == 2 then
        return self:GetStackCount()
    end
end

function modifier_rogue_avatar_aura_passive:GetModifierBonusStats_Strength()
    if self:GetParent():GetPrimaryAttribute() == 0 then
        return self:GetStackCount()
    end
end

function rogue_avatar_aura:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

