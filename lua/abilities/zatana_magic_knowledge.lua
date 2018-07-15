zatana_magic_knowledge = class({})

LinkLuaModifier( "modifier_zatana_magic_knowledge_aura", "abilities/zatana_magic_knowledge.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zatana_magic_knowledge:GetIntrinsicModifierName()
    return "modifier_zatana_magic_knowledge_aura"
end

modifier_zatana_magic_knowledge_aura = class({})

function modifier_zatana_magic_knowledge_aura:IsAura()
    return true
end

function modifier_zatana_magic_knowledge_aura:GetAuraRadius()
    return 999999
end
 
function modifier_zatana_magic_knowledge_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_zatana_magic_knowledge_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_zatana_magic_knowledge_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_zatana_magic_knowledge_aura:GetModifierAura()
    return "modifier_zatana_magic_knowledge_aura"
end

function modifier_zatana_magic_knowledge_aura:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return funcs
end

function modifier_zatana_magic_knowledge_aura:GetModifierManaBonus (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_mana")
end

function modifier_zatana_magic_knowledge_aura:GetModifierConstantHealthRegen (params)
    return self:GetAbility():GetSpecialValueFor ("bonus_health_regen")
end

function modifier_zatana_magic_knowledge_aura:GetModifierCastRangeBonus (params)
    return self:GetAbility():GetSpecialValueFor ("cast_range_bonus")
end

function modifier_zatana_magic_knowledge_aura:GetModifierSpellAmplify_Percentage (params)
    return self:GetAbility():GetSpecialValueFor ("spell_amp")
end

function modifier_zatana_magic_knowledge_aura:GetModifierConstantManaRegen  (params)
	return self:GetAbility():GetSpecialValueFor ("mana_regen")
end

function zatana_magic_knowledge:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

