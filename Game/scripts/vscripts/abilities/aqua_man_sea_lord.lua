local Z_PROXY = 130
local ADAPTIVE_SPEED = 2500

LinkLuaModifier ("modifier_aqua_man_sea_lord", "abilities/aqua_man_sea_lord.lua", LUA_MODIFIER_MOTION_NONE)

aqua_man_sea_lord = class ( {})

function aqua_man_sea_lord:Spawn()
    if IsServer() then self:SetLevel(1) end
end

function aqua_man_sea_lord:GetIntrinsicModifierName () return "modifier_aqua_man_sea_lord" end
function aqua_man_sea_lord:GetBehavior () return DOTA_ABILITY_BEHAVIOR_PASSIVE end

function aqua_man_sea_lord:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and not hTarget:IsMagicImmune()  then
        EmitSoundOn( "Hero_Morphling.AdaptiveStrikeAgi.Cast", hTarget )

        local damage = self:GetSpecialValueFor( "water_strike_base_damage" )
        local mult = self:GetSpecialValueFor( "water_strike_damage_agi" )

        ApplyDamage( {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = damage + (self:GetCaster():GetAgility() * mult),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        } )
    end

    return true
end


if not modifier_aqua_man_sea_lord then modifier_aqua_man_sea_lord = class({}) end

function modifier_aqua_man_sea_lord:IsPurgable() return false end
function modifier_aqua_man_sea_lord:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_aqua_man_sea_lord:DoAdaptiveStrike(target)
    if target then
        local info = {
            EffectName = "particles/units/heroes/hero_morphling/morphling_adaptive_strike_agi_proj.vpcf",
            Ability = self:GetAbility(),
            iMoveSpeed = ADAPTIVE_SPEED,
            Source = self:GetCaster(),
            Target = target,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        }

        ProjectileManager:CreateTrackingProjectile( info )
    end
end

function modifier_aqua_man_sea_lord:OnAttackLanded(params)
    if IsServer() and params.attacker == self:GetParent() then
        self:IncrementStackCount()

        if self:GetStackCount() == 4 then
            self:DoAdaptiveStrike(params.target)

            self:SetStackCount(1)
        end
    end

    return 0
end

function modifier_aqua_man_sea_lord:GetModifierConstantHealthRegen()
    if self:GetCaster():GetAbsOrigin().z <= Z_PROXY then
        return self:GetAbility():GetSpecialValueFor("bonus_hp_regen_on_water")
    end

    return 0
end

function modifier_aqua_man_sea_lord:GetModifierPhysicalArmorBonus()
    if self:GetCaster():GetAbsOrigin().z <= Z_PROXY then
        return self:GetAbility():GetSpecialValueFor("bonus_armor_on_water")
    end

    return 0
end


function modifier_aqua_man_sea_lord:GetModifierMoveSpeedBonus_Percentage_Unique()
    if self:GetCaster():GetAbsOrigin().z <= Z_PROXY then
        return self:GetAbility():GetSpecialValueFor("bonus_movespeed_on_water")
    end

    return 0
end
