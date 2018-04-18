LinkLuaModifier ("modifier_item_ancient_cursed_helmet", "items/item_ancient_cursed_helmet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_zombies", "items/item_ancient_cursed_helmet.lua", LUA_MODIFIER_MOTION_NONE)

if item_ancient_cursed_helmet == nil then
  item_ancient_cursed_helmet = class({})
end

function item_ancient_cursed_helmet:GetIntrinsicModifierName ()
  return "modifier_item_ancient_cursed_helmet"
end

function item_ancient_cursed_helmet:OnSpellStart ()
  local point = self:GetCaster():GetCursorPosition()
  local caster = self:GetCaster()

  EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Target", caster)

  local nFXIndex = ParticleManager:CreateParticle( "particles/hero_arthas/snow_rise_explosion.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
  ParticleManager:SetParticleControl(nFXIndex, 0, point)
  ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetSpecialValueFor("range"), 5, 0))
  ParticleManager:SetParticleControl(nFXIndex, 2, point)
  ParticleManager:SetParticleControl(nFXIndex, 3, Vector(1, 0, 0))

  local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, self:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
  for _, target in pairs(units) do
    local origin = target:GetAbsOrigin()
    if target:IsRealHero() then
      ApplyDamage({victim = target, attacker = self:GetCaster(), damage = self:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_PURE})
      if target:GetHealth() == 0 then
        local golem = CreateUnitByName( "npc_lich_zombie_golem", origin, true, caster, caster:GetOwner(), caster:GetTeamNumber())
        golem:SetControllableByPlayer(caster:GetPlayerID(), false)
        golem:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("summon_duration")})
        golem:AddNewModifier(caster, self, "modifier_zombies", {duration = self:GetSpecialValueFor("summon_duration")})
      end
    else
      target:Kill(self, caster)
      local golem = CreateUnitByName( "npc_lich_zombie", origin, true, caster, caster:GetOwner(), caster:GetTeamNumber())
      golem:SetControllableByPlayer(caster:GetPlayerID(), false)
      golem:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("summon_duration")})
      golem:AddNewModifier(caster, self, "modifier_zombies", {duration = self:GetSpecialValueFor("summon_duration")})
    end
  end
end

if modifier_item_ancient_cursed_helmet == nil then
  modifier_item_ancient_cursed_helmet = class ( {})
end

function modifier_item_ancient_cursed_helmet:IsHidden ()
  return true
end

function modifier_item_ancient_cursed_helmet:IsPurgable()
  return false
end

function modifier_item_ancient_cursed_helmet:DeclareFunctions ()
  local funcs = {
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_EVENT_ON_ATTACK_LANDED
  }

  return funcs
end

function modifier_item_ancient_cursed_helmet:GetModifierPreAttack_BonusDamage (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("bonus_damage")
end
function modifier_item_ancient_cursed_helmet:GetModifierBonusStats_Strength (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("bonus_strength")
end
function modifier_item_ancient_cursed_helmet:GetModifierBonusStats_Intellect (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("bonus_intellect")
end
function modifier_item_ancient_cursed_helmet:GetModifierPhysicalArmorBonus(params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("bonus_armor")
end
function modifier_item_ancient_cursed_helmet:GetModifierConstantHealthRegen (params)
  local hAbility = self:GetAbility ()
  return hAbility:GetSpecialValueFor ("bonus_regen")
end

function modifier_item_ancient_cursed_helmet:OnAttackLanded (params)
  if IsServer () then
    if params.attacker == self:GetParent () then
      local target = params.target
      local damage = (self:GetParent():GetAverageTrueAttackDamage(target)*self:GetAbility():GetSpecialValueFor("lifesteal_percent"))/100
      self:GetParent():Heal(damage, self:GetAbility())
      local particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"
      local lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self:GetParent ())
      ParticleManager:SetParticleControl(lifesteal_fx, 0, self:GetParent ():GetAbsOrigin())
    end
  end

  return 0
end

if modifier_zombies == nil then modifier_zombies = class({}) end

function modifier_zombies:IsHidden()
  return true
  -- body
end

function modifier_zombies:IsPurgable()
  return false
  -- body
end

function modifier_zombies:OnCreated(table)
  if IsServer() then
    self.health = self:GetCaster():GetMaxHealth()
  end
end

function modifier_zombies:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
  }

  return funcs
end

function modifier_zombies:GetModifierExtraHealthBonus( params )
  return self.health*0.2
end

function modifier_zombies:GetModifierBaseAttack_BonusDamage( params )
  return self.health*0.05
end

function item_ancient_cursed_helmet:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

