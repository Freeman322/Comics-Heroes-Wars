zatana_magic_knowledge = class({})

LinkLuaModifier( "modifier_zatana_magic_knowledge", "abilities/zatana_magic_knowledge.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zatana_magic_knowledge_aura","abilities/zatana_magic_knowledge.lua", LUA_MODIFIER_MOTION_NONE)

function zatana_magic_knowledge:GetIntrinsicModifierName()
    return "modifier_zatana_magic_knowledge"
end

modifier_zatana_magic_knowledge = class({})

function modifier_zatana_magic_knowledge:IsAura() return true end
function modifier_zatana_magic_knowledge:GetAuraRadius() return 999999 end
function modifier_zatana_magic_knowledge:IsHidden() return true end
function modifier_zatana_magic_knowledge:RemoveOnDeath() return false end
function modifier_zatana_magic_knowledge:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_zatana_magic_knowledge:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_zatana_magic_knowledge:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_zatana_magic_knowledge:GetModifierAura()
    return "modifier_zatana_magic_knowledge_aura"
end

modifier_zatana_magic_knowledge_aura = class ({})

function modifier_zatana_magic_knowledge_aura:IsPurgable() return false end

function modifier_zatana_magic_knowledge_aura:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_zatana_magic_knowledge_aura:GetModifierManaBonus() return self:GetAbility():GetSpecialValueFor("bonus_mana") end
function modifier_zatana_magic_knowledge_aura:GetModifierCastRangeBonus() return self:GetAbility():GetSpecialValueFor("cast_range_bonus") end
function modifier_zatana_magic_knowledge_aura:GetModifierSpellAmplify_Percentage() return self:GetAbility():GetSpecialValueFor("spell_amp") end

