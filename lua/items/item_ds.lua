LinkLuaModifier ("modifier_item_ds", "items/item_ds.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("item_ds_effect_modifier", "items/item_ds.lua", LUA_MODIFIER_MOTION_NONE )

if item_ds == nil then
    item_ds = class({})
end

function item_ds:GetIntrinsicModifierName()
    return "modifier_item_ds"
end

function item_ds:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local hTarget = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor( "duration" )
    hTarget:AddNewModifier (self:GetCaster (), self, "item_ds_effect_modifier", {duration = duration} )
    EmitSoundOn( "Hero_Clinkz.DeathPact.Cast", hTarget )
end
---------------------------------------------------------------------------------

if item_ds_effect_modifier == nil then
    item_ds_effect_modifier = class ( {})
end


--------------------------------------------------------------------------------

function item_ds_effect_modifier:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function item_ds_effect_modifier:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function item_ds_effect_modifier:StatusEffectPriority()
    return 1
end

--------------------------------------------------------------------------------

function item_ds_effect_modifier:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf"
end

--------------------------------------------------------------------------------

function item_ds_effect_modifier:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function item_ds_effect_modifier:IsAura()
    return false
end

function item_ds_effect_modifier:OnCreated( kv )
    self.bonus_damage = self:GetAbility():GetSpecialValueFor( "incoming_damage" )
end

--------------------------------------------------------------------------------

function item_ds_effect_modifier:OnRefresh( kv )
    self.bonus_damage = self:GetAbility ():GetSpecialValueFor ("incoming_damage")
end

--------------------------------------------------------------------------------

function item_ds_effect_modifier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end

function item_ds_effect_modifier:CheckState ()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function item_ds_effect_modifier:GetModifierIncomingDamage_Percentage (params)
    return self.bonus_damage
end


if modifier_item_ds == nil then
    modifier_item_ds = class ( {})
end

function modifier_item_ds:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function modifier_item_ds:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS
    }

    return funcs
end

function modifier_item_ds:GetModifierHealthBonus ( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_health" )
end

function modifier_item_ds:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_int" )
end

function modifier_item_ds:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end
function modifier_item_ds:GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor ("bonus_mana_regen" )
end

function item_ds:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

