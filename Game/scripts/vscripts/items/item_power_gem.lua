item_power_gem = class ( {})

LinkLuaModifier( "modifier_item_power_gem", "items/item_power_gem.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_power_gem_active", "items/item_power_gem.lua", LUA_MODIFIER_MOTION_NONE )

function item_power_gem:GetIntrinsicModifierName()
    return "modifier_item_power_gem"
end

function item_power_gem:OnSpellStart()
    local hCaster = self:GetCaster() 
    local duration = self:GetSpecialValueFor( "power_duration" )
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_power_gem_active", {duration = duration} )
 
    EmitSoundOn( "Hero_Invoker.EMP.Discharge", self:GetCaster() )
end
---------------------------------------------------------------------------------

if modifier_item_power_gem_active == nil then
    modifier_item_power_gem_active = class({})
end
--------------------------------------------------------------------------------

function modifier_item_power_gem_active:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_item_power_gem_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_power_gem_active:StatusEffectPriority()
    return 1
end

--------------------------------------------------------------------------------

function modifier_item_power_gem_active:GetEffectName()
    return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_power_gem_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_item_power_gem_active:OnCreated( kv )
    if IsServer() then
        EmitSoundOn( "Item.StarEmblem.Enemy", self:GetCaster() )
    end
end

function modifier_item_power_gem_active:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }

    return funcs
end

function modifier_item_power_gem_active:GetModifierTotalDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("power_totaldmg")
end


--------------------------------------------------------------------------------
if modifier_item_power_gem == nil then
    modifier_item_power_gem = class({})
end

function modifier_item_power_gem:IsHidden()
    return true 
end

function modifier_item_power_gem:IsPurgable()
    return false
end

function modifier_item_power_gem:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }

    return funcs
end



function modifier_item_power_gem:GetModifierPercentageManacost( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_cost" )
end

function modifier_item_power_gem:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_strength" )
end

function modifier_item_power_gem:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_intellect" )
end
function modifier_item_power_gem:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function modifier_item_power_gem:GetModifierSpellAmplify_Percentage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_spell_damage" )
end
