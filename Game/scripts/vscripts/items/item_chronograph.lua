LinkLuaModifier("modifier_item_chronograph", "items/item_chronograph.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chronograph_active", "items/item_chronograph.lua", LUA_MODIFIER_MOTION_NONE)

item_chronograph = class({})

function item_chronograph:GetIntrinsicModifierName() return "modifier_item_chronograph" end


function item_chronograph:OnSpellStart()
  if IsServer() then
    local hTarget = self:GetCursorTarget()

    if hTarget:IsIllusion() then hTarget:Kill(self, self:GetCaster()) end

    if not self:GetCaster():IsFriendly(hTarget) then
      hTarget:Purge(true, false, false, false, false)
      local mods = hTarget:FindAllModifiers()

      for _, mod in pairs (mods) do
        if mod and mod:GetDuration() > 0 and mod:GetAbility() and mod:GetAbility():GetCaster() and mod:GetAbility():GetCaster():GetTeam() ~= self:GetCaster():GetTeam() and mod:IsPermanent() == false then--На врага
            mod:Destroy()
        end
      end
      hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_chronograph_active", {duration = self:GetSpecialValueFor("debuff_duration")})
    else --На союзника
      hTarget:Purge(false, true, false, true, true)
      for _,mod in pairs(hTarget:FindAllModifiers()) do
        if mod:IsDebuff() == true or mod:IsStunDebuff() == true then
            mod:Destroy()
        end
      end
    end
    EmitSoundOn("Hero_FacelessVoid.TimeDilation.Target", hTarget)
    ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_red_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget()))
  end
end


modifier_item_chronograph = class({})

function modifier_item_chronograph:IsHidden() return true end
function modifier_item_chronograph:IsPurgable() return false end
function modifier_item_chronograph:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_MANA_BONUS,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
  }
end

function modifier_item_chronograph:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_int") end
function modifier_item_chronograph:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_item_chronograph:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_item_chronograph:GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end
function modifier_item_chronograph:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("bonus_hp_reg") end
function modifier_item_chronograph:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

function modifier_item_chronograph:OnAttackLanded(params)
  local mana_damage = self:GetAbility():GetSpecialValueFor("mana_burn")
  if params.attacker == self:GetParent() and params.target:IsBuilding() == false and params.target:GetMana() > 0 then
      if params.attacker:IsRealHero() then
          params.target:SpendMana(mana_damage, self:GetAbility())
          ApplyDamage({victim = params.target, attacker = params.attacker, damage = mana_damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})

      elseif params.attacker:IsIllusion() then
          params.target:SpendMana(mana_damage / 10, self:GetAbility())
          ApplyDamage({victim = params.target, attacker = params.attacker, damage = mana_damage / 10, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
      end

      ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target))
      EmitSoundOn("Hero_Antimage.ManaBreak", params.target)
  end
end


function modifier_item_chronograph:GetModifierPreAttack_CriticalStrike() if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then return self:GetAbility():GetSpecialValueFor("crit_damage") end end

modifier_item_chronograph_active = class({})

function modifier_item_chronograph_active:IsPurgable() return false end
function modifier_item_chronograph_active:IsHidden() return false end

if IsServer() then
  function modifier_item_chronograph_active:OnCreated()
      self.armor = self:GetParent():GetPhysicalArmorValue( false ) * -1
      self.mag_res = (self:GetParent():GetMagicalArmorValue() + self:GetParent():GetBaseMagicalResistanceValue()) * -1
      self:StartIntervalThink(FrameTime())
  end

  function modifier_item_chronograph_active:OnIntervalThink()
      local health_reduce = (100 - self:GetAbility():GetSpecialValueFor("health_reduce")) / 100
      if self:GetParent():GetHealth() / self:GetParent():GetMaxHealth() > health_reduce then
          self:GetParent():ModifyHealth(self:GetParent():GetMaxHealth() * health_reduce, self:GetAbility(), false, 0) --- SOFT CHANGE
      end
      self:GetParent():CalculateStatBonus()
  end
end


function modifier_item_chronograph_active:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_item_chronograph_active:GetModifierPhysicalArmorBonus() return self.armor end
function modifier_item_chronograph_active:GetModifierMagicalResistanceBonus() return self.mag_res end

function modifier_item_chronograph_active:GetEffectName() return "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_red_timedialate.vpcf" end
function modifier_item_chronograph_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
