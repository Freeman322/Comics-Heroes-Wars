if not loki_triks_of_the_trade then loki_triks_of_the_trade = class({}) end

LinkLuaModifier( "modifier_loki_triks_of_the_trade", "abilities/loki_triks_of_the_trade.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_loki_triks_of_the_trade_crit", "abilities/loki_triks_of_the_trade.lua" ,LUA_MODIFIER_MOTION_NONE )

function loki_triks_of_the_trade:GetIntrinsicModifierName()
	return "modifier_loki_triks_of_the_trade"
end

modifier_loki_triks_of_the_trade = class({})

function modifier_loki_triks_of_the_trade:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_loki_triks_of_the_trade:OnAttackLanded( params )
    if IsServer() then
        if params.attacker == self:GetParent() then
          local ability = self:GetAbility()
          if ability and ability:IsCooldownReady() then
              EmitSoundOn("DOTA_Item.MKB.Minibash", params.target)
              local mod = self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_loki_invis_crit", {duration = 5, crit = ability:GetSpecialValueFor("crit")})
              self:GetParent():PerformAttack(params.target, true, true, true, true, false, true, true)
              mod:Destroy()
              ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
           end
        end
    end
end

if not modifier_loki_triks_of_the_trade_crit then modifier_loki_triks_of_the_trade_crit = class({}) end

function modifier_loki_triks_of_the_trade_crit:IsHidden ()
    return true
end

function modifier_loki_triks_of_the_trade_crit:RemoveOnDeath ()
    return true
end

function modifier_loki_triks_of_the_trade_crit:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }

    return funcs
end

function modifier_loki_triks_of_the_trade_crit:GetModifierPreAttack_CriticalStrike (params)
    return self:GetAbility():GetSpecialValueFor("crit")
end


function modifier_loki_triks_of_the_trade_crit:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end
