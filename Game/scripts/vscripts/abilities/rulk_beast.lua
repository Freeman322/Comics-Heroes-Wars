LinkLuaModifier("modifier_rulk_beast", "abilities/rulk_beast.lua", LUA_MODIFIER_MOTION_NONE)

rulk_beast = class({})

function rulk_beast:GetIntrinsicModifierName()
  return "modifier_rulk_beast"
end

modifier_rulk_beast = class({})

function modifier_rulk_beast:IsHidden() return true end
function modifier_rulk_beast:IsPurgable() return false end

function modifier_rulk_beast:DeclareFunctions()
  local funcs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
  return funcs
end

function modifier_rulk_beast:OnAttackLanded(params)
  if IsServer() then
    if params.attacker == self:GetParent() and params.attacker:IsRealHero() then
      if self:GetAbility() and RollPercentage(self:GetAbility():GetSpecialValueFor("base_chance") + self:GetCaster():GetStrength() * self:GetAbility():GetSpecialValueFor("chance_per_str")) then
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("bash_duration")})
        ApplyDamage({victim = params.target, attacker = self:GetParent(), damage = self:GetAbility():GetSpecialValueFor("bash_damage"), damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})
        
        if params.target and not params.target:IsNull() and params.target:IsRealHero() then
          params.attacker:ModifyStrength(1)
          params.target:ModifyStrength(-1)
        end
      end
    end
  end
end
