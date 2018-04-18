item_aether = class ( {})

LinkLuaModifier( "item_aether_effect_modifier", "items/item_aether.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_aether_passive_modifier", "items/item_aether.lua", LUA_MODIFIER_MOTION_NONE )
function item_aether:GetIntrinsicModifierName()
    return "item_aether_passive_modifier"
end

function item_aether:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local duration = self:GetSpecialValueFor( "duration" )
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "item_aether_effect_modifier", {duration = duration} )

    EmitSoundOn ("Hero_Morphling.Replicate", self:GetCaster() )
end
---------------------------------------------------------------------------------

if item_aether_effect_modifier == nil then
    item_aether_effect_modifier = class({})
end
--------------------------------------------------------------------------------

function item_aether_effect_modifier:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function item_aether_effect_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function item_aether_effect_modifier:StatusEffectPriority()
    return 1
end

--------------------------------------------------------------------------------

function item_aether_effect_modifier:GetHeroEffectName()
    return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function item_aether_effect_modifier:HeroEffectPriority()
    return 100
end

--------------------------------------------------------------------------------

function item_aether_effect_modifier:IsAura()
    return false
end

function item_aether_effect_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_ancestral_spirit.vpcf"
end

--------------------------------------------------------------------------------

function item_aether_effect_modifier:GetEffectName ()
    return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf"
end

--------------------------------------------------------------------------------

function item_aether_effect_modifier:GetEffectAttachType ()
    return PATTACH_ABSORIGIN_FOLLOW
end


function item_aether_effect_modifier:CheckState ()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end


if item_aether_passive_modifier == nil then
    item_aether_passive_modifier = class({})
end

function item_aether_passive_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_aether_passive_modifier:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE
    }

    return funcs
end

function item_aether_passive_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_aether_passive_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_aether_passive_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_aether_passive_modifier:GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen" )
end

function item_aether:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

