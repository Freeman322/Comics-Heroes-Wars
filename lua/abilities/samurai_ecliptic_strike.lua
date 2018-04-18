samurai_ecliptic_strike = class({})
LinkLuaModifier( "modifier_samurai_ecliptic_strike", "abilities/samurai_ecliptic_strike.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function samurai_ecliptic_strike:GetIntrinsicModifierName()
  return "modifier_samurai_ecliptic_strike"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_samurai_ecliptic_strike = class({})

--------------------------------------------------------------------------------

function modifier_samurai_ecliptic_strike:IsHidden()
  return true
end

function modifier_samurai_ecliptic_strike:IsPurgable()
  return false
end

function modifier_samurai_ecliptic_strike:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED,
  }

  return funcs
end

--------------------------------------------------------------------------------

function modifier_samurai_ecliptic_strike:OnAttackLanded( params )
  if IsServer() then
    if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
      if self:GetParent():PassivesDisabled() then
        return 0
      end
      if self:GetAbility():IsCooldownReady() then
		local target = params.target
		if target ~= nil and target:IsBuilding() == false then
			if target:GetUnitName() == "npc_dota_warlock_golem_1" then
			return nil
			end
			local Damage = ( self:GetAbility():GetSpecialValueFor( "crit_mult" )*target:GetMaxHealth()) / 100.0
			ApplyDamage( {attacker = self:GetParent(), victim = target, ability = self:GetAbility(), damage = Damage, damage_type = DAMAGE_TYPE_PHYSICAL} )
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
		end
  	  end
	end
  end

  return 0
end

function samurai_ecliptic_strike:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

