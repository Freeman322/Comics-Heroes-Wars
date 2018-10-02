if not item_telescope_tube then item_telescope_tube = class({}) end 

LinkLuaModifier ("modifier_item_telescope_tube", "items/item_telescope_tube.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_telescope_tube_buff", "items/item_telescope_tube.lua", LUA_MODIFIER_MOTION_NONE)


function item_telescope_tube:GetIntrinsicModifierName()
    return "modifier_item_telescope_tube"
end

function item_telescope_tube:OnSpellStart()
    local hCaster = self:GetCaster() --We will always have Caster.
    local hTarget = self:GetCursorTarget()
    
    hCaster:AddNewModifier(hCaster, self, "modifier_item_telescope_tube_buff", {duration = self:GetSpecialValueFor("duration")})

    EmitSoundOn( "Hero_Clinkz.DeathPact.Cast", hTarget )
end
---------------------------------------------------------------------------------

if modifier_item_telescope_tube == nil then
    modifier_item_telescope_tube = class ( {})
end


--------------------------------------------------------------------------------

function modifier_item_telescope_tube:IsPurgable()
    return false
end

function modifier_item_telescope_tube:IsHidden()
    return true
end

function modifier_item_telescope_tube:RemoveOnDeath()
    return false
end

function modifier_item_telescope_tube:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_item_telescope_tube:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_item_telescope_tube:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor("bonus_damage")
end

function modifier_item_telescope_tube:GetModifierSpellAmplify_Percentage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "spell_amp" )
end

function modifier_item_telescope_tube:GetModifierCastRangeBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "cast_range_bonus" )
end

function modifier_item_telescope_tube:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_telescope_tube:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_telescope_tube:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function modifier_item_telescope_tube:GetModifierConstantManaRegen( params )
    return self:GetAbility():GetSpecialValueFor ("bonus_mana_regen")
end

if not modifier_item_telescope_tube_buff then modifier_item_telescope_tube_buff = class({}) end 

function modifier_item_telescope_tube_buff:IsPurgable()
    return false
end

function modifier_item_telescope_tube_buff:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

function modifier_item_telescope_tube_buff:StatusEffectPriority()
    return 1
end

function modifier_item_telescope_tube_buff:GetEffectName()
    return "particles/units/heroes/hero_broodmother/broodmother_hunger_buff.vpcf"
end

function modifier_item_telescope_tube_buff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_telescope_tube_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS
    }

    return funcs
end

function modifier_item_telescope_tube_buff:GetModifierCastRangeBonus( params )
    return 2000
end