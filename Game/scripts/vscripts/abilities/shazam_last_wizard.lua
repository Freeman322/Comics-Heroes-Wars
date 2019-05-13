shazam_last_wizard = class({})
LinkLuaModifier ("modifier_shazam_last_wizard", "abilities/shazam_last_wizard.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_shazam_last_wizard_debuff", "abilities/shazam_last_wizard.lua", LUA_MODIFIER_MOTION_NONE)

shazam_last_wizard.m_iSpellAmpCount = 1

function shazam_last_wizard:GetIntrinsicModifierName()
     return "modifier_shazam_last_wizard"
end

modifier_shazam_last_wizard = class({})

function modifier_shazam_last_wizard:IsAura() return true end
function modifier_shazam_last_wizard:IsHidden() return true end
function modifier_shazam_last_wizard:IsPurgable()	return true end
function modifier_shazam_last_wizard:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("range") end
function modifier_shazam_last_wizard:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_shazam_last_wizard:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_shazam_last_wizard:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE end
function modifier_shazam_last_wizard:GetModifierAura() return "modifier_shazam_last_wizard_debuff" end
function modifier_shazam_last_wizard:DeclareFunctions() return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE} end

function modifier_shazam_last_wizard:GetModifierSpellAmplify_PercentageUnique(params)
	return self:GetAbility().m_iSpellAmpCount
end


modifier_shazam_last_wizard_debuff = class({})

function modifier_shazam_last_wizard_debuff:OnCreated(params)
     if IsServer() then
          self:GetAbility().m_iSpellAmpCount = self:GetAbility().m_iSpellAmpCount + self:GetAbility():GetSpecialValueFor("spell_amp_steal")
     end 
end

function modifier_shazam_last_wizard_debuff:OnDestroy()
     if IsServer() then
          self:GetAbility().m_iSpellAmpCount = self:GetAbility().m_iSpellAmpCount - self:GetAbility():GetSpecialValueFor("spell_amp_steal")

          if self:GetAbility().m_iSpellAmpCount <= 0 then self:GetAbility().m_iSpellAmpCount = 1 end 
     end 
end

function modifier_shazam_last_wizard_debuff:IsPurgable() return false end

function modifier_shazam_last_wizard_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE} end

function modifier_shazam_last_wizard_debuff:GetModifierSpellAmplify_PercentageUnique(params)
	return self:GetAbility():GetSpecialValueFor("spell_amp_steal") * (-1)
end
