LinkLuaModifier( "modifier_antman_quantum_realm", "abilities/antman_quantum_realm.lua", LUA_MODIFIER_MOTION_NONE )
antman_quantum_realm = class({})

function antman_quantum_realm:OnSpellStart(  )
  if IsServer() then
    local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), 99999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
    if #allies > 0 then
      for _,ally in pairs(allies) do
        ally:AddNewModifier( self:GetCaster(), self, "modifier_antman_quantum_realm", { duration = self:GetDuration() } )
        EmitSoundOn("Hero_DarkWillow.Brambles.Cast", ally)
      end
    end

    EmitSoundOn("Hero_DarkWillow.Brambles.CastTarget", self:GetCaster())
  end
end

if modifier_antman_quantum_realm == nil then
  modifier_antman_quantum_realm = class({})
end

function modifier_antman_quantum_realm:IsPurgable()
  return false
end

function modifier_antman_quantum_realm:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_ABSORB_SPELL,
    MODIFIER_PROPERTY_REFLECT_SPELL
  }

  return funcs
end

function modifier_antman_quantum_realm:OnTakeDamage( params )
  if IsServer() then
    if params.unit == self:GetParent() then
      local target = params.attacker

      if target:IsAncient() or target:IsBuilding() then return end

      ApplyDamage ( {
        victim = target,
        attacker = self:GetParent(),
        damage = params.damage,
        damage_type = params.damage_type,
        ability = self:GetAbility(),
        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
      })

      EmitSoundOn("DOTA_Item.BladeMail.Damage", target)

      self:GetParent():Heal(params.damage, self)
    end
  end
end

function modifier_antman_quantum_realm:GetAbsorbSpell(keys)
  return true
end

function modifier_antman_quantum_realm:GetReflectSpell(keys)
  if self.stored ~= nil then
    self.stored:RemoveSelf()
  end

  local hCaster = self:GetParent()

  EmitSoundOn( "Hero_AbyssalUnderlord.Firestorm.Target", self:GetParent( ))
  EmitSoundOn( "Hero_AbyssalUnderlord.Pit.TargetHero", self:GetParent( ))
  EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Start", self:GetParent())
  EmitSoundOn ("Hero_AbyssalUnderlord.Firestorm.Cast", self:GetParent())

  if keys.ability:GetAbilityName() == "loki_spell_steal" then
    return nil
  end

  local hAbility = hCaster:AddAbility(keys.ability:GetAbilityName())

  hAbility:SetStolen(true) --just to be safe with some interactions.
  hAbility:SetHidden(true) --hide the ability.
  hAbility:SetLevel(keys.ability:GetLevel()) --same level of ability as the origin.
  hCaster:SetCursorCastTarget(keys.ability:GetCaster()) --lets send this spell back.
  hAbility:OnSpellStart() --cast the spell.
  self.stored = hAbility --store the spell reference for future use.

  ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())
  ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_POINT_FOLLOW, self:GetParent())

  return true
end
