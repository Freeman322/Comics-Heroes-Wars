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
    return "modifier_item_aether_lens"
end

function zatana_magic_knowledge:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

