if item_grand_magus_scepter == nil then
    item_grand_magus_scepter = class({})
end
LinkLuaModifier( "item_grand_magus_scepter_passive_modifier", "items/item_grand_magus_scepter.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function item_grand_magus_scepter:GetIntrinsicModifierName()
    return "item_grand_magus_scepter_passive_modifier"
end
function item_grand_magus_scepter:GetBehavior()
    if self:GetCaster():HasModifier("modifier_item_ultimate_scepter_consumed") or self:GetCaster():GetUnitName() == "npc_dota_hero_razor" then
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function item_grand_magus_scepter:OnSpellStart()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_ultimate_scepter_consumed", nil )
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    EmitSoundOn( "DOTA_Item.Mango.Activate", self:GetCaster() )
end

--------------------------------------------------------------------------------
if item_grand_magus_scepter_passive_modifier == nil then
    item_grand_magus_scepter_passive_modifier = class({})
end

function item_grand_magus_scepter_passive_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_grand_magus_scepter_passive_modifier:DeclareFunctions () --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_IS_SCEPTER
    }

    return funcs
end

function item_grand_magus_scepter_passive_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_grand_magus_scepter_passive_modifier:GetModifierScepter (params)
    return 1
end

function item_grand_magus_scepter_passive_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_grand_magus_scepter_passive_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_grand_magus_scepter_passive_modifier:GetModifierPercentageCooldown( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "cooldown_reduction" )
end

function item_grand_magus_scepter_passive_modifier:GetModifierHealthBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health" )
end
function item_grand_magus_scepter_passive_modifier:GetModifierManaBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana" )
end

function item_grand_magus_scepter:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

