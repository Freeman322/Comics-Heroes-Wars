LinkLuaModifier ("modifier_ds_sniper_shot", "abilities/ds_sniper_shot.lua", 0)

ds_sniper_shot = class ({GetIntrinsicModifierName = function() return "modifier_ds_sniper_shot" end})

modifier_ds_sniper_shot = class({
    DeclareFunctions = function() return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS} end,
    GetModifierProjectileSpeedBonus = function() return 2000 end
})

function modifier_ds_sniper_shot:OnCreated()
  self:GetParent():SetRangedProjectileName("particles/econ/items/sniper/sniper_charlie/sniper_base_attack_charlie.vpcf")
  self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
end

function modifier_ds_sniper_shot:GetModifierAttackRangeBonus() return self:GetAbility():GetSpecialValueFor("range") end
function modifier_ds_sniper_shot:OnAttackStart(params) if params.attacker == self:GetParent() then self:GetParent():RemoveGesture(ACT_DOTA_ATTACK) self:GetParent():StartGesture(ACT_DOTA_DAGON) end end
function modifier_ds_sniper_shot:OnAttack(params) if params.attacker == self:GetParent() then EmitSoundOn("Hero_Sniper.MKG_attack", self:GetParent()) end end
