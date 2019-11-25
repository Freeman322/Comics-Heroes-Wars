LinkLuaModifier( "modifier_green_lantern_lantern_aura", "abilities/green_lantern_lantern.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_green_lantern_lantern_aura_effect", "abilities/green_lantern_lantern.lua", LUA_MODIFIER_MOTION_NONE )

green_lantern_lantern = class({})

function green_lantern_lantern:OnSpellStart()
    local unit = CreateUnitByName( "npc_dota_gl_lantern", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeam())
    unit:AddNewModifier(self:GetCaster(), self, "modifier_green_lantern_lantern_aura", { duration = self:GetSpecialValueFor("duration") })
    unit:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = self:GetSpecialValueFor("duration") })
    FindClearSpaceForUnit(unit, self:GetCursorPosition(), true)
    EmitSoundOn( "Hero_Sven.GodsStrength", self:GetCaster() )
end

modifier_green_lantern_lantern_aura = class({
    IsPurgable = function() return false end,
    IsAura = function() return true end,
    GetModifierAura = function() return "modifier_green_lantern_lantern_aura_effect" end
})

function modifier_green_lantern_lantern_aura:IsHidden()
    if self:GetParent():GetUnitName() == "npc_dota_gl_turret" then
        return false
    end
end

function modifier_green_lantern_lantern_aura:GetAuraSearchTeam() return self:GetAbility():GetAbilityTargetTeam() end
function modifier_green_lantern_lantern_aura:GetAuraSearchType() return self:GetAbility():GetAbilityTargetType() end
function modifier_green_lantern_lantern_aura:GetAuraSearchFlags() return self:GetAbility():GetAbilityTargetFlags() end
function modifier_green_lantern_lantern_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("buff_radius") end

modifier_green_lantern_lantern_aura_effect = class({
    IsHidden = function() return true end,
    IsPurgable = function() return false end,
    DeclareFunctions = function() return {MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE , MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE} end
})

function modifier_green_lantern_lantern_aura_effect:GetModifierBaseDamageOutgoing_Percentage()
    if self:GetParent():GetUnitName() == "npc_dota_gl_turret" then
        return self:GetAbility():GetSpecialValueFor("damage_amp_pct") + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_gl_lantern") or 0)
    end
end

function modifier_green_lantern_lantern_aura_effect:GetModifierTotalPercentageManaRegen()
    if self:GetParent() == self:GetCaster() then
        return self:GetAbility():GetSpecialValueFor ("mana_regen_pct")
    end
end
