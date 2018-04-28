if not ursa_warrior_overcome then ursa_warrior_overcome = class({}) end
LinkLuaModifier ("modifier_ursa_warrior_overcome", "abilities/ursa_warrior_overcome.lua", LUA_MODIFIER_MOTION_NONE)

function ursa_warrior_overcome:OnSpellStart()
  if IsServer() then
    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ursa/ursa_infernal_rage_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() );
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector(300, 300, 0));
    ParticleManager:SetParticleControl( nFXIndex, 2, self:GetCaster():GetAbsOrigin());
    ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin());
    ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetAbsOrigin());
    ParticleManager:SetParticleControl( nFXIndex, 5, self:GetCaster():GetAbsOrigin());
    ParticleManager:ReleaseParticleIndex( nFXIndex );

    EmitSoundOn("Hero_Ursa.Overpower", self:GetCaster())
    EmitSoundOn("Hero_Ursa.Enrage", self:GetCaster())

    local duration = self:GetSpecialValueFor("duration")
    if self:GetCaster():HasTalent("special_bonus_unique_ursa_warrior") then 
      duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_ursa_warrior")
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ursa_warrior_overcome", {duration = duration})
  end
end

if not modifier_ursa_warrior_overcome then modifier_ursa_warrior_overcome = class({}) end 

function modifier_ursa_warrior_overcome:GetEffectName()
  return "particles/hero_ursa/ursa_infernal_rage_buff.vpcf"
end

function modifier_ursa_warrior_overcome:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ursa_warrior_overcome:IsPurgable()
  return false
end

function modifier_ursa_warrior_overcome:OnCreated( params )
  if IsServer() then
    self.damage = {}
    local damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    if self:GetCaster():HasTalent("special_bonus_unique_ursa_warrior_4") then 
      damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_ursa_warrior_4")
    end
    self.bonus_damage = self:GetParent():GetMaxHealth() * (damage / 100)
    print(self.bonus_damage)
  end
end

function modifier_ursa_warrior_overcome:AddDamage(attacker, damage)
  if IsServer() then 
    self.damage[attacker] = (self.damage[attacker] or 0) + (damage or 0)
  end
end

function modifier_ursa_warrior_overcome:OnDestroy()
  if IsServer() then 
    local damage = self:GetAbility():GetSpecialValueFor("damage_return")
    if self:GetCaster():HasTalent("special_bonus_unique_ursa_warrior_1") then 
      damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_ursa_warrior_1")
    end

    EmitSoundOn ("Hero_ArcWarden.SparkWraith.Activate", hTarget)
    for hTarget, _damage in pairs(self.damage) do
      EmitSoundOn ("Hero_ArcWarden.SparkWraith.Damage", hTarget)
      ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = hTarget, ability = self:GetAbility(), damage = _damage * (damage / 100), damage_type = DAMAGE_TYPE_PURE})

      local pop_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
      ParticleManager:SetParticleControl(pop_pfx, 0, hTarget:GetAbsOrigin())
      ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))
      ParticleManager:ReleaseParticleIndex(pop_pfx)
    end
  end
end

function modifier_ursa_warrior_overcome:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
  }

  return funcs
end

function modifier_ursa_warrior_overcome:GetModifierPreAttack_BonusDamage (params)
  return self.bonus_damage
end
