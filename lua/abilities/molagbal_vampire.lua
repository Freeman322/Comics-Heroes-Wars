if not molagbal_vampire then molagbal_vampire = class({}) end
LinkLuaModifier( "modifier_molagbal_vampire",           "abilities/molagbal_vampire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_molagbal_vampire_invs",      "abilities/molagbal_vampire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_molagbal_vampire_invs_fade", "abilities/molagbal_vampire.lua", LUA_MODIFIER_MOTION_NONE )

function molagbal_vampire:GetIntrinsicModifierName()
  return "modifier_molagbal_vampire"
end

function molagbal_vampire:OnSpellStart ()
  if IsServer() then
    if not GameRules:IsDaytime() then 
      self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_molagbal_vampire_invs", {duration = self:GetSpecialValueFor("duration")})

      local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_night_stalker/nightstalker_change.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() );
      ParticleManager:ReleaseParticleIndex( nFXIndex );

      EmitSoundOn( "Hero_Nightstalker.Void", self:GetCaster() )

    else self:RefundManaCost() self:EndCooldown() end 
  end
end

modifier_molagbal_vampire = class({})

function modifier_molagbal_vampire:IsHidden()
  return true
end

function modifier_molagbal_vampire:OnCreated()
  if IsServer() then self:StartIntervalThink(1) end
end

function modifier_molagbal_vampire:OnIntervalThink()
  if IsServer() then 
    if GameRules:IsDaytime() and self:GetCaster():HasModifier("modifier_molagbal_vampire_invs") then self:GetCaster():RemoveModifierByName("modifier_molagbal_vampire_invs") end 
    if GameRules:IsDaytime() then self:SetStackCount(0) else self:SetStackCount(1) end  

    self:GetParent():CalculateStatBonus()
  end 
end

function modifier_molagbal_vampire:IsPurgable()
  return false
end

function modifier_molagbal_vampire:RemoveOnDeath()
  return false
end

function modifier_molagbal_vampire:DeclareFunctions ()
  local funcs = {
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_BONUS_NIGHT_VISION
  }

  return funcs
end

function modifier_molagbal_vampire:OnAttackLanded (params)
  if IsServer() then
    if params.attacker == self:GetParent() and not params.target:IsBuilding() then
        local damage = self:GetAbility():GetSpecialValueFor("vampiric") 
        if self:GetCaster():HasTalent("special_bonus_unique_molag_bal_2") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_molag_bal_2") end 

        self:GetParent():Heal(params.damage * (damage / 100), self:GetAbility())

        local lifesteal_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent ())
        ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent ():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(lifesteal_fx)
     end 
  end
end


function modifier_molagbal_vampire:GetModifierHPRegenAmplify_Percentage() if self:GetStackCount() == 1 then return self:GetAbility():GetSpecialValueFor("daynight_heal_mana_amp") end return self:GetAbility():GetSpecialValueFor("daynight_heal_mana_amp") * (-1) end
function modifier_molagbal_vampire:GetModifierMPRegenAmplify_Percentage() if self:GetStackCount() == 1 then return self:GetAbility():GetSpecialValueFor("daynight_heal_mana_amp") end return self:GetAbility():GetSpecialValueFor("daynight_heal_mana_amp") * (-1) end
function modifier_molagbal_vampire:GetModifierBonusStats_Agility (params) if self:GetStackCount() == 1 then return self:GetAbility():GetSpecialValueFor("daynight_attr") end  return self:GetAbility():GetSpecialValueFor("daynight_attr") * (-1) end
function modifier_molagbal_vampire:GetModifierBonusStats_Intellect (params) if self:GetStackCount() == 1 then return self:GetAbility():GetSpecialValueFor("daynight_attr") end  return self:GetAbility():GetSpecialValueFor("daynight_attr") * (-1) end
function modifier_molagbal_vampire:GetModifierBonusStats_Strength (params) if self:GetStackCount() == 1 then return self:GetAbility():GetSpecialValueFor("daynight_attr") end  return self:GetAbility():GetSpecialValueFor("daynight_attr") * (-1) end
function modifier_molagbal_vampire:GetBonusNightVision (params) if self:GetStackCount() == 1 then return 5000 end  return end

if not modifier_molagbal_vampire_invs then modifier_molagbal_vampire_invs = class({}) end 


function modifier_molagbal_vampire_invs:IsHidden()
  return true
end


function modifier_molagbal_vampire_invs:GetStatusEffectName()
  if not self:GetParent():HasModifier("modifier_molagbal_vampire_invs_fade") then
    return "particles/status_fx/status_effect_dark_willow_wisp_fear.vpcf"
  end 
  return
end

function modifier_molagbal_vampire_invs:StatusEffectPriority()
  return 1000
end


function modifier_molagbal_vampire_invs:IsPurgable()
  return false
end

function modifier_molagbal_vampire_invs:RemoveOnDeath()
  return false
end

function modifier_molagbal_vampire_invs:DeclareFunctions ()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL
  }

  return funcs
end

function modifier_molagbal_vampire_invs:OnAttackLanded (params)
  if IsServer() then
    if params.attacker == self:GetParent() then
      self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_molagbal_vampire_invs_fade", {duration = self:GetAbility():GetSpecialValueFor("fade_delay")})
     end 
  end
end

function modifier_molagbal_vampire_invs:GetModifierInvisibilityLevel()
  if not self:GetParent():HasModifier("modifier_molagbal_vampire_invs_fade") then
    return 1
  end 
  return
end

function modifier_molagbal_vampire_invs:CheckState()
  if not self:GetParent():HasModifier("modifier_molagbal_vampire_invs_fade") then
    return {[MODIFIER_STATE_INVISIBLE] = true}
  end
  return 
end

if modifier_molagbal_vampire_invs_fade == nil then modifier_molagbal_vampire_invs_fade = class({}) end

function modifier_molagbal_vampire_invs_fade:RemoveOnDeath()
   return false
end

function modifier_molagbal_vampire_invs_fade:IsPurgable()
   return false
end

function modifier_molagbal_vampire_invs_fade:IsHidden()
   return true
end
