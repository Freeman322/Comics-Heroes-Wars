if item_ghost_staff == nil then
    item_ghost_staff = class({})
end
LinkLuaModifier( "item_ghost_staff_effect_modifier", "items/item_ghost_staff.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_ghost_staff_passive_modifier", "items/item_ghost_staff.lua", LUA_MODIFIER_MOTION_NONE )
function item_ghost_staff:GetIntrinsicModifierName()
    return "item_ghost_staff_passive_modifier"
end

function item_ghost_staff:GetBehavior()
    if self:GetCaster():GetUnitName() == "npc_dota_hero_night_stalker" then
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function item_ghost_staff:GetCooldown( nLevel )
    if self:GetCaster():GetUnitName() == "npc_dota_hero_night_stalker" then
        return 0
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function item_ghost_staff:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local duration = self:GetSpecialValueFor( "duration" )
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "item_ghost_staff_effect_modifier", {duration = duration} )
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    EmitSoundOn( "DOTA_Item.Mango.Activate", self:GetCaster() )
end
---------------------------------------------------------------------------------

if item_ghost_staff_effect_modifier == nil then
    item_ghost_staff_effect_modifier = class({})
end
--------------------------------------------------------------------------------

function item_ghost_staff_effect_modifier:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function item_ghost_staff_effect_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function item_ghost_staff_effect_modifier:StatusEffectPriority()
    return 1
end

--------------------------------------------------------------------------------

function item_ghost_staff_effect_modifier:GetHeroEffectName()
    return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function item_ghost_staff_effect_modifier:HeroEffectPriority()
    return 100
end

--------------------------------------------------------------------------------

function item_ghost_staff_effect_modifier:IsAura()
    return false
end

function item_ghost_staff_effect_modifier:OnCreated( kv )
    self.gods_strength_damage = self:GetAbility():GetSpecialValueFor( "active_damage" )

    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
        local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt( nFXIndex2, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex2 )

        EmitSoundOn( "Item.StarEmblem.Enemy", self:GetCaster() )
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

--------------------------------------------------------------------------------

function item_ghost_staff_effect_modifier:OnRefresh( kv )
    self.gods_strength_damage = self:GetAbility():GetSpecialValueFor( "active_damage" )
end

--------------------------------------------------------------------------------

function item_ghost_staff_effect_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

--------------------------------------------------------------------------------

function item_ghost_staff_effect_modifier:	GetModifierTotalDamageOutgoing_Percentage()
    return self.gods_strength_damage
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
if item_ghost_staff_passive_modifier == nil then
    item_ghost_staff_passive_modifier = class({})
end

function item_ghost_staff_passive_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_ghost_staff_passive_modifier:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_CAST_RANGE_BONUS
}

return funcs
end

function item_ghost_staff_passive_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_ghost_staff_passive_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_ghost_staff_passive_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_ghost_staff_passive_modifier:	GetModifierTotalDamageOutgoing_Percentage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "spell_amp" )
end

function item_ghost_staff_passive_modifier:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end
function item_ghost_staff_passive_modifier:	GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_magical_armor" )
end
function item_ghost_staff_passive_modifier:GetModifierCastRangeBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "cast_range_bonus" )
end
function item_ghost_staff:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

