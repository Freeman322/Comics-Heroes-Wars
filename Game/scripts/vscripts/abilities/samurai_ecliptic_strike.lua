LinkLuaModifier( "modifier_samurai_ecliptic_strike", "abilities/samurai_ecliptic_strike.lua", LUA_MODIFIER_MOTION_NONE )

samurai_ecliptic_strike = class({})

function samurai_ecliptic_strike:GetIntrinsicModifierName() return "modifier_samurai_ecliptic_strike" end

modifier_samurai_ecliptic_strike = class({})

function modifier_samurai_ecliptic_strike:IsHidden() return true end
function modifier_samurai_ecliptic_strike:IsPurgable() return false end
function modifier_samurai_ecliptic_strike:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_samurai_ecliptic_strike:OnAttackLanded( params )
  if IsServer() then
    if params.attacker == self:GetParent() and params.attacker:IsRealHero() and self:GetAbility():IsCooldownReady() and params.target:IsBuilding() == false and params.target:GetUnitName() ~= "npc_dota_creature_yaz" then
      if self:GetParent():PassivesDisabled() then return 0 end
      ApplyDamage( {attacker = self:GetParent(), victim = params.target, ability = self:GetAbility(), damage = (self:GetAbility():GetSpecialValueFor("crit_mult") * params.target:GetMaxHealth()) / 100, damage_type = DAMAGE_TYPE_PHYSICAL} )
      self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
    end
  end
end

