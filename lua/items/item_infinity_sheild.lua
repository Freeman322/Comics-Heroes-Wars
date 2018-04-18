LinkLuaModifier ("modifier_infinity_shield", "items/item_infinity_sheild.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_item_infinity_sheild", "items/item_infinity_sheild.lua", LUA_MODIFIER_MOTION_NONE)

if item_infinity_sheild == nil then
    item_infinity_sheild = class ( {})
end

function item_infinity_sheild:GetIntrinsicModifierName ()
    return "modifier_item_infinity_sheild"
end

--------------------------------------------------------------------------------

function item_infinity_sheild:OnSpellStart ()
    local duration = self:GetSpecialValueFor ("reflect_duration")
    local caster = self:GetCaster ()
    EmitSoundOn("Item.GuardianGreaves.Target", caster)
    caster:AddNewModifier(caster, self, "modifier_infinity_shield", {duration = duration})
end


if modifier_infinity_shield == nil then
    modifier_infinity_shield = class({})
end


function modifier_infinity_shield:IsPurgable()
    return false
end

function modifier_infinity_shield:GetEffectName()
    return "particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf"
end


function modifier_infinity_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_infinity_shield:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker
            target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
            ApplyDamage({attacker = self:GetParent(), victim = target, ability = self:GetAbility(), damage = params.damage, damage_type = DAMAGE_TYPE_PURE})
        end
    end
end

if modifier_item_infinity_sheild == nil then
    modifier_item_infinity_sheild = class({})
end

function modifier_item_infinity_sheild:IsHidden()
    return true
end

function modifier_item_infinity_sheild:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return funcs
end

function modifier_item_infinity_sheild:GetModifierPreAttack_BonusDamage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("bonus_damage")
end

function modifier_item_infinity_sheild:GetModifierBonusStats_Strength (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("all")
end

function modifier_item_infinity_sheild:GetModifierBonusStats_Intellect (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("all")
end

function modifier_item_infinity_sheild:GetModifierBonusStats_Agility (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("all")
end

function modifier_item_infinity_sheild:GetModifierAttackSpeedBonus_Constant (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("as")
end

function item_infinity_sheild:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

