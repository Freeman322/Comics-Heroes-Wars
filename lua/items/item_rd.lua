item_rd = class({})
LinkLuaModifier( "item_rd_effect_modifier", "items/item_rd.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_rd_passive_modifier", "items/item_rd.lua", LUA_MODIFIER_MOTION_NONE )
function item_rd:GetIntrinsicModifierName()
    return "item_rd_passive_modifier"
end

function item_rd:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local duration = self:GetSpecialValueFor( "duration" )
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "item_rd_effect_modifier", {duration = duration} )
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
    EmitSoundOn( "Hero_Bane.Nightmare.End", self:GetCaster() )
end
---------------------------------------------------------------------------------

if item_rd_effect_modifier == nil then
    item_rd_effect_modifier = class({})
end
--------------------------------------------------------------------------------

function item_rd_effect_modifier:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function item_rd_effect_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function item_rd_effect_modifier:StatusEffectPriority()
    return 1
end

--------------------------------------------------------------------------------

function item_rd_effect_modifier:GetHeroEffectName()
    return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function item_rd_effect_modifier:HeroEffectPriority()
    return 100
end

--------------------------------------------------------------------------------


function item_rd_effect_modifier:GetStatusEffectName ()
    return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

--------------------------------------------------------------------------------

function item_rd_effect_modifier:StatusEffectPriority ()
    return 1000
end

function item_rd_effect_modifier:IsAura()
    return false
end

function item_rd_effect_modifier:OnCreated( kv )
    if IsServer () then
        local duration = self:GetAbility():GetSpecialValueFor ("duration")
        self:GetParent ():AddNewModifier (self:GetCaster (), self, "modifier_persistent_invisibility", { duration = duration } )
    end
end


function item_rd_effect_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY
    }

    return funcs
end

function item_rd_effect_modifier:CheckState ()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
    }

    return state
end
--------------------------------------------------------------------------------

function item_rd_effect_modifier:GetModifierPersistentInvisibility()
    return 1
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
if item_rd_passive_modifier == nil then
    item_rd_passive_modifier = class({})
end

function item_rd_passive_modifier:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_rd_passive_modifier:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return funcs
end

function item_rd_passive_modifier:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_rd_passive_modifier:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_rd_passive_modifier:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_rd_passive_modifier:GetModifierPreAttack_BonusDamage ( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_damage" )
end

function item_rd_passive_modifier:GetModifierAttackSpeedBonus_Constant ( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_attack_speed" )
end

function item_rd:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

