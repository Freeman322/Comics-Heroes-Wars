if thanos_believer == nil then thanos_believer = class({}) end

LinkLuaModifier( "modifier_thanos_believer", "abilities/thanos_believer.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_thanos_believer_active", "abilities/thanos_believer.lua", LUA_MODIFIER_MOTION_NONE )

function thanos_believer:GetIntrinsicModifierName()
  return "modifier_thanos_believer"
end

function thanos_believer:OnOwnerDied()
 if IsServer() then
    if self:IsCooldownReady() then
       local pos = self:GetCaster():GetAbsOrigin()
       self:StartCooldown(self:GetCooldown(self:GetLevel()))
       self:GetCaster():Heal(1, self) 
       self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_lotus_orb_active", {duration = self:GetDuration()} )
       self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_thanos_believer_active", {duration = self:GetDuration()} )

       self:GetCaster():RespawnHero(false, false, false)
       self:GetCaster():SetAbsOrigin(pos)
    end
  end
end

if modifier_thanos_believer == nil then modifier_thanos_believer = class({}) end

function modifier_thanos_believer:IsHidden()
  return true
end

function modifier_thanos_believer:IsPurgable()
  return false
end

function modifier_thanos_believer:GetPriority()
  return MODIFIER_PRIORITY_ULTRA
end


function modifier_thanos_believer:DeclareFunctions ()
  local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }

  return funcs
end

function modifier_thanos_believer:OnTakeDamage( params )
  if IsServer() then
    if params.unit == self:GetParent() then
      local target = params.attacker
      if target == self:GetParent() then
        return
      end
      if self:GetParent():GetHealthPercent() <= 15 and self:GetAbility():IsCooldownReady() then
        self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_thanos_believer_active", {duration = self:GetAbility():GetDuration()} )
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_lotus_orb_active", {duration = self:GetAbility():GetDuration()} )
      end
    end
  end
end

modifier_thanos_believer_active = class ( {})

function modifier_thanos_believer_active:IsHidden()
    return false
end

function modifier_thanos_believer_active:IsBuff()
    return false
end

function modifier_thanos_believer_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_sylph_wisp_fear.vpcf"
end

function modifier_thanos_believer_active:StatusEffectPriority()
    return 1000
end

function modifier_thanos_believer_active:GetEffectName()
    return "particles/hero_thanos/thanos_beliver.vpcf"
end

function modifier_thanos_believer_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_thanos_believer_active:OnCreated()
    if IsServer() then
        self.min = self:GetParent():GetHealth()
        local particle_lifesteal = "particles/items4_fx/combo_breaker_spell.vpcf"
        local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
        EmitSoundOn("Hero_DarkWillow.Bramble.Target.Layer", self:GetParent())
        EmitSoundOn("DOTA_Item.ComboBreaker", self:GetParent())
    end
end

function modifier_thanos_believer_active:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MIN_HEALTH,
        MODIFIER_PROPERTY_REFLECT_SPELL,
        MODIFIER_PROPERTY_DISABLE_HEALING
    }

    return funcs
end

function modifier_thanos_believer_active:GetMinHealth (params)
    return self.min
end

function modifier_thanos_believer_active:GetReflectSpell (params)
    return 1
end

function modifier_thanos_believer_active:GetDisableHealing (params)
    return 1
end


function thanos_believer:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

