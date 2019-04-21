if diablo_burning_attacks == nil then diablo_burning_attacks = class({}) end
LinkLuaModifier( "modifier_diablo_burning_attacks",	"abilities/diablo_burning_attacks.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diablo_burning_target",	"abilities/diablo_burning_attacks.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function diablo_burning_attacks:GetIntrinsicModifierName()
  return "modifier_diablo_burning_attacks"
end

function diablo_burning_attacks:OnSpellStart()
  if IsServer() then
    local hTarget = self:GetCursorTarget()
    if hTarget ~= nil then
      if ( not hTarget:TriggerSpellAbsorb( self ) ) then
        if not hTarget:IsBuilding() and not hTarget:IsAncient() then
            local stun_duration = self:GetSpecialValueFor("ministun_duration")
            if self:GetCaster():HasTalent("special_bonus_unique_diablo_1") then 
                stun_duration = stun_duration + self:GetCaster():FindTalentValue("special_bonus_unique_diablo_1")
            end
           
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_diablo_burning_target", {duration = self:GetSpecialValueFor("burn_duration")})
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration})

            EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", hTarget)
            EmitSoundOn("Hero_DoomBringer.Attack.Impact", hTarget)
        end
      end
    end
  end
end

if modifier_diablo_burning_attacks == nil then
  modifier_diablo_burning_attacks = class ( {})
end

function modifier_diablo_burning_attacks:IsHidden ()
  return true
end

function modifier_diablo_burning_attacks:IsPurgable()
  return false
end

function modifier_diablo_burning_attacks:DeclareFunctions ()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED
  }

  return funcs
end

function modifier_diablo_burning_attacks:OnAttackLanded (params)
  if IsServer () then
    if params.attacker == self:GetParent () then
      if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
        if not params.target:IsBuilding() and not params.target:IsMagicImmune() then
          params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_diablo_burning_target", {duration = self:GetAbility():GetSpecialValueFor("burn_duration")})
          params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("ministun_duration")})

          self:GetAbility():PayManaCost()
          self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))

          EmitSoundOn("Hero_DoomBringer.InfernalBlade.PreAttack", params.target)
          EmitSoundOn("Hero_DoomBringer.Attack.Impact", params.target)
        end
      end
    end
  end

  return 0
end
if modifier_diablo_burning_target == nil then modifier_diablo_burning_target = class ( {}) end

function modifier_diablo_burning_target:GetEffectName ()
  return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_diablo_burning_target:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_diablo_burning_target:OnCreated(event)
  if IsServer() then
    local thinker = self:GetParent()
    local ability = self:GetAbility()

    if thinker:IsBuilding() or thinker:IsAncient() then
      self:Destroy()
    end

    EmitSoundOn("Hero_DoomBringer.InfernalBlade.Target", thinker)    
    self:StartIntervalThink(0.1)
    self:OnIntervalThink()
  end
end

function modifier_diablo_burning_target:OnIntervalThink()
  if IsServer() then
    local damage = self:GetAbility():GetSpecialValueFor("burn_damage")
    local mult = self:GetAbility():GetSpecialValueFor("burn_damage_pct")
    if self:GetCaster():HasTalent("special_bonus_unique_diablo") then
        mult = mult + self:GetCaster():FindTalentValue("special_bonus_unique_diablo") 
    end
    damage = (damage + (self:GetParent():GetMaxHealth() * mult) / 100)
    ApplyDamage ({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage / 10, damage_type = self:GetAbility():GetAbilityDamageType()})
  end
end

function modifier_diablo_burning_target:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function diablo_burning_attacks:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

