pudge_essence_shift = class({})
LinkLuaModifier( "modifier_essence_strike", "abilities/pudge_essence_shift.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pudge_essence_shift", "abilities/pudge_essence_shift.lua", LUA_MODIFIER_MOTION_NONE )

function pudge_essence_shift:GetIntrinsicModifierName()
     return "modifier_pudge_essence_shift"
end

function pudge_essence_shift:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function pudge_essence_shift:OnSpellStart()
    if IsServer() then
      local hTarget = self:GetCursorTarget()
      if hTarget ~= nil then
       
        self:GetCaster():PerformAttack(hTarget, true, true, true, true, false, false, true)
      end
    end
end

if modifier_pudge_essence_shift == nil then modifier_pudge_essence_shift = class({}) end

function modifier_pudge_essence_shift:IsHidden()
    return false
end

function modifier_pudge_essence_shift:IsPurgable()
    return false
end

function modifier_pudge_essence_shift:OnCreated(htable)
   if IsServer() then
     self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_interval"))
   end
end

function modifier_pudge_essence_shift:OnIntervalThink()
   if IsServer() then
      self:GetParent():Purge(false, false, false, true, false)
   end
end

function modifier_pudge_essence_shift:DeclareFunctions ()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end

function modifier_pudge_essence_shift:OnAttackLanded (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
        if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
            if not params.target:IsBuilding() and not params.target:IsAncient() then
                params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_essence_strike", {duration = self:GetAbility():GetDuration()})
                params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = 0.1})

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


if modifier_essence_strike == nil then modifier_essence_strike = class ( {}) end

function modifier_essence_strike:GetEffectName ()
  return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_essence_strike:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_essence_strike:OnCreated(event)
  if IsServer() then
    local thinker = self:GetParent()
    local ability = self:GetAbility()

    if thinker:IsBuilding() or thinker:IsAncient() then
      self:Destroy()
    end

    EmitSoundOn("Hero_DoomBringer.InfernalBlade.Target", thinker)    

    self:StartIntervalThink(1)
    self:OnIntervalThink()
  end
end

function modifier_essence_strike:OnIntervalThink()
  if IsServer() then
    local damage = ((self:GetAbility():GetSpecialValueFor("damage") / 100) * self:GetAbility():GetCaster():GetMaxHealth()) + self:GetAbility():GetSpecialValueFor("damage_bonus")
    ApplyDamage ({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = self:GetAbility():GetAbilityDamageType()})
  end
end

function modifier_essence_strike:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
