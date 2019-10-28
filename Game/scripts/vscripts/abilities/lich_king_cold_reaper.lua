LinkLuaModifier ("modifier_item_frostmourne", "items/item_frostmourne.lua", LUA_MODIFIER_MOTION_NONE)

if lich_king_cold_reaper == nil then lich_king_cold_reaper = class({}) end

function lich_king_cold_reaper:IsRefreshable()
  return true
end

function lich_king_cold_reaper:IsStealable()
  return false
end

function lich_king_cold_reaper:OnSpellStart()
  local caster = self:GetCaster()
  local spawn_location = caster:GetAbsOrigin()
  local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:SetParticleControl(nFXIndex, 0, Vector(0, 0, 0))
  ParticleManager:SetParticleControl(nFXIndex, 1, Vector(250, 250, 250))
  EmitSoundOn( "Hero_Ancient_Apparition.IceBlast.Target", self:GetCaster() )
  EmitSoundOn( "Hero_Crystal.CrystalNova", self:GetCaster() )
  EmitSoundOn( "hero_Crystal.CrystalNovaCast", self:GetCaster() )

  local nFXIndex = ParticleManager:CreateParticle( "particles/hero_arthas/snow_rise_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self:GetSpecialValueFor("range"), 5, 0))
  ParticleManager:SetParticleControl(nFXIndex, 2, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(nFXIndex, 3, Vector(1, 0, 0))

  local damage = self:GetSpecialValueFor("damage")
  local souls = self:GetCaster():FindModifierByName("modifier_item_frostmourne")
  if souls == nil then
    souls_damage = self:GetSpecialValueFor("bonus_per_soul")
  else
    local stack = souls:GetStackCount()
    souls_damage = stack*self:GetSpecialValueFor("bonus_per_soul")
    self.talent_souls = 15
    if self:GetCaster():HasTalent("special_bonus_unique_lich_king") then
      souls_damage = stack * (self:GetSpecialValueFor("bonus_per_soul") + 15)
    end
  end

  self.damage = damage + souls_damage

  self.range = self:GetSpecialValueFor("range")

  self.range = self.range + (self:GetLevel()*50)

  if self:GetCaster():HasScepter() then
    self.range = self.range + 100
  end

  local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
  if #units > 0 then
    for _,target in pairs(units) do
      if target:IsRealHero() then 
        ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self.damage, damage_type = self:GetAbilityDamageType(), ability = self})
        target:AddNewModifier(caster, self, "modifier_ancientapparition_coldfeet_freeze", {duration = self:GetSpecialValueFor("duration")})
        end
    end
end

  local creeps = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false )
  if #creeps > 0 then
    for _,creep in pairs(creeps) do
      if not creep:IsConsideredHero() and not creep:IsAncient() then 
        creep:Kill(self, caster)
        local golem = CreateUnitByName( "npc_lich_zombie", creep:GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
        golem:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)
        golem:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 30})
      end
    end
  end
end

function lich_king_cold_reaper:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

