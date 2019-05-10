LinkLuaModifier ("modifier_ds_sniper_shot", "abilities/ds_sniper_shot.lua", LUA_MODIFIER_MOTION_NONE)

ds_sniper_shot = class ({})
function ds_sniper_shot:GetIntrinsicModifierName() return "modifier_ds_sniper_shot" end

modifier_ds_sniper_shot = class({})

function modifier_ds_sniper_shot:OnCreated()
  self:GetParent():SetRangedProjectileName("particles/econ/items/sniper/sniper_charlie/sniper_base_attack_charlie.vpcf")--("particles/units/heroes/hero_sniper/sniper_base_attack.vpcf")
  self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
end

function modifier_ds_sniper_shot:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
    }
end

function modifier_ds_sniper_shot:GetModifierAttackRangeBonus() return self:GetAbility():GetSpecialValueFor("range") end
function modifier_ds_sniper_shot:GetModifierProjectileSpeedBonus() return 2000 end
function modifier_ds_sniper_shot:OnAttack(params) if params.attacker == self:GetParent() then EmitSoundOn ("Hero_Sniper.MKG_attack",  self:GetParent()) end end
