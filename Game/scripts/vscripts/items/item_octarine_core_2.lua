LinkLuaModifier ("modifier_item_octarine_core_2", "items/item_octarine_core_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_octarine_core_2_effect", "items/item_octarine_core_2.lua", LUA_MODIFIER_MOTION_NONE)
if item_octarine_core_2 == nil then
    item_octarine_core_2 = class({})
end
function item_octarine_core_2:GetIntrinsicModifierName ()
    return "modifier_item_octarine_core_2"
end

function item_octarine_core_2:OnSpellStart ()
    EmitSoundOn ("Hero_ShadowDemon.ShadowPoison.Release", self:GetCaster () )
    local duration = self:GetSpecialValueFor ("active_duration")
    self:GetCaster ():AddNewModifier (self:GetCaster (), self, "modifier_item_octarine_core_2_effect", { duration = duration })
end

if modifier_item_octarine_core_2_effect == nil then
    modifier_item_octarine_core_2_effect = class({})
end
--------------------------------------------------------------------------------

function modifier_item_octarine_core_2_effect:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_item_octarine_core_2_effect:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_octarine_core_2_effect:StatusEffectPriority()
    return 1
end

--------------------------------------------------------------------------------

function modifier_item_octarine_core_2_effect:GetHeroEffectName()
    return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_octarine_core_2_effect:HeroEffectPriority()
    return 100
end

--------------------------------------------------------------------------------

function modifier_item_octarine_core_2_effect:IsAura()
    return false
end

function modifier_item_octarine_core_2_effect:OnCreated( kv )
    self.damage = self:GetAbility():GetSpecialValueFor( "active_magical_damage" )
    self.cast_pont = self:GetAbility():GetSpecialValueFor( "active_cast_point" )
    if IsServer() then
        local caster = self:GetCaster()
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
        EmitSoundOn( "Item.DropGemWorld", self:GetCaster() )
        self:AddParticle( particle, false, false, -1, false, true )
    end
end

--------------------------------------------------------------------------------

function modifier_item_octarine_core_2_effect:OnRefresh( kv )
    self.damage = self:GetAbility():GetSpecialValueFor( "active_magical_damage" )
    self.cast_pont = self:GetAbility():GetSpecialValueFor( "active_cast_point" )
end

--------------------------------------------------------------------------------

function modifier_item_octarine_core_2_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
    }

    return funcs
end
        
function modifier_item_octarine_core_2_effect:GetTexture()
    return "item_octarine_core_2"
end
--------------------------------------------------------------------------------

function modifier_item_octarine_core_2_effect:GetModifierTotalDamageOutgoing_Percentage()
    return self.damage
end

function modifier_item_octarine_core_2_effect:GetModifierPercentageCasttime()
    return self.cast_pont
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
if modifier_item_octarine_core_2 == nil then
    modifier_item_octarine_core_2 = class({})
end

function modifier_item_octarine_core_2:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end


function modifier_item_octarine_core_2:DeclareFunctions() --we want to use these functions in this item
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE
    }

    return funcs
end

function modifier_item_octarine_core_2:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_octarine_core_2:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_octarine_core_2:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function modifier_item_octarine_core_2:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health_regen" )
end
function modifier_item_octarine_core_2:	GetModifierPercentageManaRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_regen" )
end
function modifier_item_octarine_core_2:GetModifierManaBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana" )
end
function modifier_item_octarine_core_2:GetModifierHealthBonus( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_health" )
end
function modifier_item_octarine_core_2:GetModifierPercentageCooldown( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_cooldown" )
end
function modifier_item_octarine_core_2:GetModifierPercentageManacost( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_mana_cost" )
end
function item_octarine_core_2:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

