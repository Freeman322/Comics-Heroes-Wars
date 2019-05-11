bolt_ultimate = class({})
LinkLuaModifier( "modifier_bolt_ultimate", "abilities/bolt_ultimate.lua",LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function bolt_ultimate:GetCooldown( nLevel )
  if self:GetCaster():HasScepter() then
    return self:GetSpecialValueFor("cooldown_scepter")
  end

  return self.BaseClass.GetCooldown( self, nLevel )
end

function bolt_ultimate:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_bolt_arcana") then
    return "custom/bolt_ult_arcana"
  end
  return "custom/bolt_ultimate"
end

function bolt_ultimate:GetBehavior()
  return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function bolt_ultimate:OnSpellStart()
  EmitSoundOn( "chw.bolt_ulti" , self:GetCaster() )
  EmitSoundOn( "Hero_Beastmaster.Primal_Roar" , self:GetCaster() )
  GridNav:DestroyTreesAroundPoint( self:GetCaster():GetAbsOrigin(), 1000, false)
  local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
  vDirection = vDirection:Normalized()

  self.caster_pos = self:GetCaster():GetAbsOrigin()

  self.wave_speed = self:GetSpecialValueFor( "speed" )
  self.vision_aoe = 220
  self.duration = self:GetSpecialValueFor( "dur" )
  self.vision_duration = 4
  self.wave_width = 800 - 300
  local projectile = "particles/hero_black_bolt/black_bolt_quasisonic_scream.vpcf"

  if self:GetCaster():HasModifier("modifier_bolt_arcana") then
    projectile = "particles/hero_black_bolt/arcana/black_bolt_ult_arcana.vpcf"
    local pos = self:GetCursorPosition() - self:GetCaster():GetOrigin()

    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_black_bolt/arcana/black_bolt_ult_arcana_wave.vpcf", PATTACH_CUSTOMORIGIN, nil );
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() );
    ParticleManager:SetParticleControl( nFXIndex, 1, pos);
    ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin() );
    ParticleManager:SetParticleControl( nFXIndex, 4, self:GetCaster():GetAbsOrigin() );
    ParticleManager:SetParticleControl( nFXIndex, 5, self:GetCaster():GetAbsOrigin() );
    ParticleManager:SetParticleControl( nFXIndex, 10, self:GetCaster():GetAbsOrigin() );
    ParticleManager:ReleaseParticleIndex( nFXIndex );

    local nFXIndex = ParticleManager:CreateParticle( "particles/hero_black_bolt/arcana/black_bolt_ult_arcana_exp.vpcf", PATTACH_CUSTOMORIGIN, nil );
    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() );
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector(1, 1, 1) );
    ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1) );
    ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin() );
    ParticleManager:ReleaseParticleIndex( nFXIndex );

    EmitSoundOn( "Hero_MonkeyKing.Spring.Water", self:GetCaster() )
    EmitSoundOn( "Hero_MonkeyKing.Spring.Impact.Water", self:GetCaster() )
  end

  local info = {
    EffectName = projectile,
    Ability = self,
    vSpawnOrigin = self:GetCaster():GetOrigin(),
    fStartRadius = 100,
    fEndRadius = 850,
    vVelocity = vDirection * self.wave_speed,
    fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
    Source = self:GetCaster(),
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    bProvidesVision = true,
    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    iVisionRadius = self.vision_aoe,
  }

  self.flVisionTimer = self.wave_width / self.wave_speed
  self.flLastThinkTime = GameRules:GetGameTime()
  self.nProjID = ProjectileManager:CreateLinearProjectile( info )
  EmitSoundOn( "chw.bolt_ulti" , self:GetCaster() )
  EmitSoundOn( "Hero_Beastmaster.Primal_Roar" , self:GetCaster() )
end

--------------------------------------------------------------------------------

function bolt_ultimate:OnProjectileHit( hTarget, vLocation )
  if hTarget ~= nil then
      EmitSoundOn( "chw.bolt_ulti" , hTarget )
      local k = 1 - (((hTarget:GetAbsOrigin() - self.caster_pos):Length2D())/2000)
      self.damage = (2000*k) * self:GetSpecialValueFor( "damage_mult" )

      if self:GetCaster():HasTalent("special_bonus_unique_black_bolt") then
          self.damage = self.damage * 2.5
      end

      local damage = {
          victim = hTarget,
          attacker = self:GetCaster(),
          damage = self.damage,
          damage_type = DAMAGE_TYPE_MAGICAL,
          ability = self,
      }

      local knockbackProperties =
      {
          center_x = self:GetCaster():GetAbsOrigin().x,
          center_y = self:GetCaster():GetAbsOrigin().y,
          center_z = self:GetCaster():GetAbsOrigin().z,
          duration = 2,
          knockback_duration = 2,
          knockback_distance = 380,
          knockback_height = 0
      }

      hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
      hTarget:AddNewModifier( self:GetCaster(), self, "modifier_bolt_ultimate", { duration = 3 } )

      ApplyDamage( damage )
  end

  return false
end


modifier_bolt_ultimate = class({})

--------------------------------------------------------------------------------

function modifier_bolt_ultimate:IsDebuff()
  return true
end

--------------------------------------------------------------------------------

function modifier_bolt_ultimate:IsStunDebuff()
  return true
end

--------------------------------------------------------------------------------
function modifier_bolt_ultimate:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end
function modifier_bolt_ultimate:GetEffectName()
  return "particles/generic_gameplay/generic_stunned_old.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bolt_ultimate:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_bolt_ultimate:OnCreated( kv )
  if IsServer() then
    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_stone_gaze_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "follow_hitloc", self:GetParent():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "follow_hitloc", self:GetParent():GetOrigin(), true )
    self:AddParticle( nFXIndex, false, false, -1, false, true )
  end
end

--------------------------------------------------------------------------------

function modifier_bolt_ultimate:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
  }

  return funcs
end

--------------------------------------------------------------------------------

function modifier_bolt_ultimate:GetOverrideAnimation( params )
  return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_bolt_ultimate:CheckState()
  local state = {
    [MODIFIER_STATE_STUNNED] = true,
  }

  return state
end

function bolt_ultimate:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end

