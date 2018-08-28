zatana_magic_knowledge = class({})

LinkLuaModifier( "modifier_zatana_magic_knowledge", "abilities/zatana_magic_knowledge.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zatana_magic_knowledge_aura","abilities/zatana_magic_knowledge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_zatana_magic_knowldege_aura_scepter", "abilities/zatana_magic_knowledge.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function zatana_magic_knowledge:GetIntrinsicModifierName()
    return "modifier_zatana_magic_knowledge"
end


modifier_zatana_magic_knowledge = class({})

function modifier_zatana_magic_knowledge:IsAura()
    return true
end

function modifier_zatana_magic_knowledge:GetAuraRadius() 
    return 999999
end

function modifier_zatana_magic_knowledge:IsHidden()
    return true
end

function modifier_zatana_magic_knowledge:RemoveOnDeath()
    return false
end
 
function modifier_zatana_magic_knowledge:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_zatana_magic_knowledge:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_zatana_magic_knowledge:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_zatana_magic_knowledge:GetModifierAura()
    return "modifier_zatana_magic_knowledge_aura"
end


modifier_zatana_magic_knowledge_aura = class ({})

function modifier_zatana_magic_knowledge_aura:OnCreated()
    self:StartIntervalThink(0.1)
end

function modifier_zatana_magic_knowledge_aura:OnIntervalThink()
    if IsServer() then
        if self:GetCaster():HasItemInInventory("item_ultimate_scepter") then
            self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_zatana_magic_knowldege_aura_scepter", nil)
        end

        if self:GetParent():HasModifier("modifier_zatana_magic_knowldege_aura_scepter") and not self:GetCaster():HasItemInInventory("item_ultimate_scepter")  then
            self:GetParent():RemoveModifierByName("modifier_zatana_magic_knowldege_aura_scepter")
        end
    end
end


function modifier_zatana_magic_knowledge_aura:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_zatana_magic_knowldege_aura_scepter")
    end
end

function modifier_zatana_magic_knowledge_aura:IsPurgable()
    return false
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


modifier_zatana_magic_knowldege_aura_scepter = class({})

function modifier_zatana_magic_knowldege_aura_scepter:IsHidden()
    return true
end

function modifier_zatana_magic_knowldege_aura_scepter:IsPurgable()
    return false
end

function modifier_zatana_magic_knowldege_aura_scepter:IsPurgeException()
    return false
end

function modifier_zatana_magic_knowldege_aura_scepter:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IS_SCEPTER
    }

    return funcs
end

function modifier_zatana_magic_knowldege_aura_scepter:GetModifierScepter( params )
    return 1
end

function zatana_magic_knowledge:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

