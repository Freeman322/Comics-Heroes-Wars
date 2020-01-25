if zeus_gods_eye == nil then
  zeus_gods_eye = class({})
end
LinkLuaModifier( "modifier_zeus_gods_eye", "abilities/zeus_gods_eye.lua", LUA_MODIFIER_MOTION_NONE )
function zeus_gods_eye:GetIntrinsicModifierName()
  return "modifier_zeus_gods_eye"
end
function zeus_gods_eye:GetAOERadius()
  if self:GetCaster():HasScepter() then
    return 5000
  end
  return 500
end
function zeus_gods_eye:OnSpellStart()
  local hTarget = self:GetCursorPosition()
  local caster = self:GetCaster()
  local target = hTarget
  local ability = self
  local duration = self:GetSpecialValueFor( "duration" )
  local radius = 500
  if caster:HasScepter() then
    radius = self:GetSpecialValueFor("aoe_radius_scepter")
  end

  EmitSoundOn("Hero_Zuus.StaticField", caster)
  local particle = ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord.vpcf", PATTACH_WORLDORIGIN, caster)
  ParticleManager:SetParticleControl(particle, 1, Vector(500, 500, 500))
  AddFOWViewer( caster:GetTeamNumber(), target, radius, duration, false)
  local particle_new = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, caster)
  ParticleManager:SetParticleControl(particle_new, 0, Vector(target.x,target.y,target.z))
  ParticleManager:SetParticleControl(particle_new, 1, Vector(target.x, target.y, 1000 ))
  ParticleManager:SetParticleControl(particle_new, 2, Vector(target.x,target.y,target.z))
  local targets = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, 1300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for i = 1, #targets do
    local target = targets[i]
    if caster:HasScepter() then
      if not target:HasModifier("modifier_truesight") then
        target:AddNewModifier(caster, ability, "modifier_truesight", {duration = duration})
      end
    end
  end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if modifier_zeus_gods_eye == nil then
  modifier_zeus_gods_eye = class({})
end

function modifier_zeus_gods_eye:OnCreated( kv )
  if IsServer() then
  end
end



function modifier_zeus_gods_eye:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ABILITY_EXECUTED
  }

  return funcs
end

function modifier_zeus_gods_eye:OnAbilityExecuted(params)
  if IsServer() then
    if params.unit == self:GetParent() and not params.ability.IsProcBanned then
      local hAbility = self:GetAbility()
      if hAbility:GetLevel() < 1 then return end
      if params.ability:IsItem() then return end
      local iAoE = hAbility:GetSpecialValueFor( "radius" )
      local iDamage = hAbility:GetSpecialValueFor( "damage" )

      local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), iAoE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
      if #enemies > 0 then
        for _,enemy in pairs(enemies) do
          if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
            local armor = enemy:GetPhysicalArmorValue( false )
            if armor < 1 then armor = 1 end
            local damage = {
              victim = enemy,
              attacker = self:GetCaster(),
              damage = (iDamage / 100) * enemy:GetMaxHealth(),
              damage_type = hAbility:GetAbilityDamageType(),
              ability = self:GetAbility()
            }
            ApplyDamage( damage )

            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_WORLDORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 4, 1, 1 ) )
            ParticleManager:SetParticleControl( nFXIndex, 0, enemy:GetOrigin()+Vector(0,0,100) )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
          end
        end
      end
    end
  end
end

function modifier_zeus_gods_eye:IsHidden()
  return true
end

function zeus_gods_eye:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

