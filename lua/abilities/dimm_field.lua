if dimm_field == nil then dimm_field = class({}) end

LinkLuaModifier( "modifier_dimm_field", "abilities/dimm_field.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dimm_field_debuff", "abilities/dimm_field.lua", LUA_MODIFIER_MOTION_NONE )

function dimm_field:GetIntrinsicModifierName()
  return "modifier_dimm_field"
end

function dimm_field:OnProjectileHit( hTarget, vLocation )
  if IsServer() then 
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_dimm_field_debuff", {duration = self:GetSpecialValueFor("duration")})
    EmitSoundOn("Hero_Lich.ChainFrostImpact.Hero", hTarget)
  end
  return true
end


modifier_dimm_field = class({})

function modifier_dimm_field:IsHidden()
  return true
end

function modifier_dimm_field:IsPurgable()
  return false
end

function modifier_dimm_field:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK
  }

  return funcs
end

function modifier_dimm_field:OnAttack (params)
    if IsServer () then
        if params.attacker == self:GetParent () then
            if self:GetParent():GetMana() >= self:GetAbility():GetManaCost(self:GetAbility():GetLevel()) and self:GetAbility():GetAutoCastState() then
              local info = {
                  EffectName = "particles/units/heroes/hero_jakiro/jakiro_base_attack.vpcf",
                  Ability = self:GetAbility(),
                  iMoveSpeed = 1000,
                  Source = self:GetCaster(),
                  Target = params.target,
                  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
                }

              ProjectileManager:CreateTrackingProjectile( info )
              EmitSoundOn( "Ability.DarkRitual", self:GetCaster() )

              self:GetAbility():PayManaCost()
            end
        end
    end

    return 0
end


modifier_dimm_field_debuff = class({})

function modifier_dimm_field_debuff:IsHidden()
  return true
end

function modifier_dimm_field_debuff:IsPurgable()
  return false
end

function modifier_dimm_field_debuff:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_l2_dire.vpcf"
end

function modifier_dimm_field_debuff:StatusEffectPriority()
	return 1000
end

function modifier_dimm_field_debuff:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf"
end

function modifier_dimm_field_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_dimm_field_debuff:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(1)
  end
end

function modifier_dimm_field_debuff:OnIntervalThink()
  if IsServer() then
    local damage = self:GetAbility():GetSpecialValueFor("damage")
    if self:GetCaster():HasTalent("special_bonus_unique_dimm_2") then 
      damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_dimm_2")
    end
    ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
  end
end

function modifier_dimm_field_debuff:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
  }

  return funcs
end

function modifier_dimm_field_debuff:GetModifierMoveSpeedBonus_Percentage( params )
  return self:GetAbility():GetSpecialValueFor("slowing") * (-1)
end

function modifier_dimm_field_debuff:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end