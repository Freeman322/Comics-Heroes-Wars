LinkLuaModifier( "modifier_nightbringer_rise_of_night", "abilities/nightbringer_rise_of_night.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nightbringer_rise_of_night_scepter", "abilities/nightbringer_rise_of_night.lua",LUA_MODIFIER_MOTION_NONE )

nightbringer_rise_of_night = class({})

function nightbringer_rise_of_night:IsStealable()
    return true
end
--------------------------------------------------------------------------------
function nightbringer_rise_of_night:GetManaCost(iLevel)
    self.cost = self.BaseClass.GetManaCost( self, iLevel )
    if  self:GetCaster():HasScepter() then
        return 0
    end
    return self.cost
end

function nightbringer_rise_of_night:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 60
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function nightbringer_rise_of_night:OnSpellStart()
  local hTarget = self:GetCursorTarget()
  local caster = self:GetCaster()
  if hTarget ~= nil then
    if ( not hTarget:TriggerSpellAbsorb( self ) ) then
      local damage_increase_pct = self:GetSpecialValueFor( "damage_increase_pct" )
      local duration = self:GetSpecialValueFor( "duration" )
      hTarget:AddNewModifier( self:GetCaster(), self, "modifier_nightbringer_rise_of_night", { duration = duration } )

      if caster:HasScepter() then
        hTarget:AddNewModifier( self:GetCaster(), self, "modifier_nightbringer_rise_of_night_scepter", { duration = duration } )
      end

      EmitSoundOn( "Hero_Bane.Nightmare.End", hTarget )
    end

    local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
    local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, hTarget )

    ParticleManager:SetParticleControlEnt(particle, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)

    -- Show the particle target-> caster
    local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
    local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )

    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)

    EmitSoundOn( "Hero_Clinkz.DeathPact.Cast", self:GetCaster() )
  end
end

--------------------modifiers---------------------------------------

modifier_nightbringer_rise_of_night = class({})
--------------------------------------------------------------------------------

function modifier_nightbringer_rise_of_night:OnCreated( kv )
  self.damage_increase_pct = self:GetAbility():GetSpecialValueFor( "damage_increase_pct" )
  if IsServer() then
    local nFXIndex = ParticleManager:CreateParticle( "particles/nightbringer_night_status_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetOrigin(), true )
    ParticleManager:SetParticleControl( nFXIndex, 15, Vector(255, 255, 255) )
    ParticleManager:SetParticleControl( nFXIndex, 16, Vector(1, 0, 0) )
    self:AddParticle( nFXIndex, false, false, -1, false, true )
  end
end

function modifier_nightbringer_rise_of_night:IsHidden()
  return false
end

--------------------------------------------------------------------------------

function modifier_nightbringer_rise_of_night:OnRefresh( kv )
    self.damage_increase_pct = self:GetAbility():GetSpecialValueFor( "damage_increase_pct" )
end

--------------------------------------------------------------------------------

function modifier_nightbringer_rise_of_night:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
  }

  return funcs
end

--------------------------------------------------------------------------------

function modifier_nightbringer_rise_of_night:GetModifierIncomingDamage_Percentage( params )
  return self.damage_increase_pct
end

--------------------------------------------------------------------------------

function modifier_nightbringer_rise_of_night:GetAbsoluteNoDamagePhysical( params )
  return 1
end

---------------------modifier_scepter------------------------------


modifier_nightbringer_rise_of_night_scepter = class({})

--------------------------------------------------------------------------------

function modifier_nightbringer_rise_of_night_scepter:IsDebuff()
  return true
end

function modifier_nightbringer_rise_of_night_scepter:IsHidden()
  return true
end

--------------------------------------------------------------------------------

function modifier_nightbringer_rise_of_night_scepter:CheckState()
  local state = {
  [MODIFIER_STATE_MUTED] = true,
  [MODIFIER_STATE_SILENCED] = true,
  [MODIFIER_STATE_DISARMED] = true,
  }

  return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function nightbringer_rise_of_night:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

