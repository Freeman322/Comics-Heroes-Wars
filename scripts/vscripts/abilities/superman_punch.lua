superman_punch = class ({})

LinkLuaModifier( "modifier_superman_punch", "abilities/superman_punch.lua", LUA_MODIFIER_MOTION_NONE )

function superman_punch:GetIntrinsicModifierName()
	return "modifier_superman_punch"
end

modifier_superman_punch = class({})

function modifier_superman_punch:IsHidden() return true end
function modifier_superman_punch:IsDebuff() return false end

function modifier_superman_punch:DeclareFunctions()
  local funcs = {
      MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
  }

  return funcs
end

function modifier_superman_punch:GetModifierPreAttack_CriticalStrike(params)
  if IsServer() then 
    if self:GetAbility():IsCooldownReady() then
        local hTarget = params.target

        local damage = self:GetAbility():GetSpecialValueFor("crit_multiplier")
        if self:GetParent():HasTalent("special_bonus_unique_superman_1") then damage = damage + self:GetParent():FindTalentValue("special_bonus_unique_superman_1") end 

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7_proj_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn("Hero_ElderTitan.EchoStomp", hTarget)

        self:GetAbility():UseResources(false, false, true)

        return damage
    end
  end 
  
  return
end

