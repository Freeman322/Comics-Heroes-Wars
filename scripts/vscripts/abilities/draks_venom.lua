LinkLuaModifier("modifier_draks_venom", "abilities/draks_venom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_draks_venom_poison", "abilities/draks_venom", LUA_MODIFIER_MOTION_NONE)

draks_venom = class({})

function draks_venom:GetIntrinsicModifierName()
  return "modifier_draks_venom"
end

modifier_draks_venom = class({})

function modifier_draks_venom:IsHidden() return true end
function modifier_draks_venom:IsPurgable() return false end
function modifier_draks_venom:IsPermanent() return true end

function modifier_draks_venom:DeclareFunctions()
  return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_draks_venom:OnAttackLanded(params)
  if params.attacker == self:GetParent() then
    if not params.target:IsMagicImmune() then
      params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_draks_venom_poison", {duration = self:GetAbility():GetSpecialValueFor("duration")})
    end
  end
end

modifier_draks_venom_poison = class({})

function modifier_draks_venom_poison:IsHidden() return false end
function modifier_draks_venom_poison:IsPurgable() return true end

function modifier_draks_venom_poison:OnCreated()
  if IsServer() then
    self:StartIntervalThink(0.25)
  end
end

function modifier_draks_venom_poison:OnIntervalThink()
  if IsServer() then
    local damage = self:GetAbility():GetSpecialValueFor("poison_damage") / 4
    ApplyDamage({ attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
  end
end

function modifier_draks_venom_poison:DeclareFunctions()
  return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_draks_venom_poison:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor("movespeed_slow") * -1
end

function modifier_draks_venom_poison:GetModifierAttackSpeedBonus_Constant()
  return self:GetAbility():GetSpecialValueFor("attackspeed_slow") * -1
end

function modifier_draks_venom_poison:GetEffectName()
  return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_draks_venom_poison:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end
