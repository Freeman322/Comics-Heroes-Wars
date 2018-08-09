if miraak_mana_void == nil then miraak_mana_void = class({}) end
LinkLuaModifier( "modifier_miraak_mana_void",	"abilities/miraak_mana_void.lua", LUA_MODIFIER_MOTION_NONE )


function miraak_mana_void:GetIntrinsicModifierName()
  return "modifier_miraak_mana_void"
end

function miraak_mana_void:GetManaForDamage()
    if IsServer() then 
        local damage = self:GetSpecialValueFor("mana_damage")
        if self:GetCaster():HasTalent("special_bonus_unique_miraak_1") then damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_miraak_1") end

        return damage
    end 
end

function miraak_mana_void:ApplyDamage(params)
    ApplyDamage( params )

    self:GetCaster():SpendMana(params.damage, self)
end

function miraak_mana_void:GetManaCost(iLevel)
    return self:GetManaForDamage()
end

function miraak_mana_void:OnSpellStart()
  if IsServer() then
    local hTarget = self:GetCursorTarget()
    if hTarget ~= nil and self:IsOwnersManaEnough() then
        local stun_duration = self:GetSpecialValueFor("ministun_duration")
        local damage = self:GetSpecialValueFor("mana_damage")

        if self:GetCaster():HasTalent("special_bonus_unique_miraak_1") then 
            damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_miraak_1")
        end

        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration})

        EmitSoundOn("Hero_Antimage.ManaBreak", hTarget)

        
        self:GetAbility():ApplyDamage({
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self
        })
    end
  end
end

if modifier_miraak_mana_void == nil then
    modifier_miraak_mana_void = class ( {})
end

function modifier_miraak_mana_void:IsHidden ()
  return true
end

function modifier_miraak_mana_void:IsPurgable()
  return false
end

function modifier_miraak_mana_void:DeclareFunctions ()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_LANDED
  }

  return funcs
end

function modifier_miraak_mana_void:OnAttackLanded (params)
  if IsServer () then
    if params.attacker == self:GetParent () then
      if self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsOwnersManaEnough() then
        local hTarget = params.target
        local stun_duration = self:GetAbility():GetSpecialValueFor("ministun_duration")
        local damage = self:GetAbility():GetSpecialValueFor("mana_damage")

        if self:GetCaster():HasTalent("special_bonus_unique_miraak_1") then 
            damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_miraak_1")
        end

        hTarget:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = stun_duration})

        EmitSoundOn("Hero_Antimage.ManaBreak", hTarget)

        self:GetAbility():ApplyDamage({
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self:GetAbility()
        })

        self:GetAbility():UseResources(true, false, true)
      end
    end
  end

  return 0
end