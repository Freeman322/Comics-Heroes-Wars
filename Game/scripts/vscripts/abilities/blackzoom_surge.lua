blackzoom_surge = class({})

LinkLuaModifier( "modifier_zoom_remtant", "abilities/blackzoom_surge.lua", LUA_MODIFIER_MOTION_NONE )

function blackzoom_surge:IsRefreshable()
   return false
end

function blackzoom_surge:IsStealable()
   return false
end

function blackzoom_surge:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()
  self:SetActivated(false)
  if self.remnant ~= nil and self.remnant:IsNull() ~= true then
    self:GetCaster():SetAbsOrigin(self.remnant:GetAbsOrigin())
    UTIL_Remove(self.remnant)
    self:SetActivated(true)
    return nil
  else
  	local info = {
  		EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
  		Ability = self,
  		vSpawnOrigin = self:GetCaster():GetOrigin(),
  		fStartRadius = 100,
  		fEndRadius = 100,
  		vVelocity = vDirection * 1500,
  		fDistance = (self:GetCursorPosition() - self:GetCaster():GetOrigin()):Length2D(),
  		Source = self:GetCaster(),
  		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
  		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
  		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
  		bProvidesVision = true,
  		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
  		iVisionRadius = 100,
  	}
  	self.nProjID = ProjectileManager:CreateLinearProjectile( info )
  	EmitSoundOn( "Hero_EmberSpirit.FireRemnant.Cast" , self:GetCaster() )
  end

  function blackzoom_surge:OnProjectileHit( hTarget, vLocation )
  	if hTarget ~= nil then
  		local damage = {
  			victim = hTarget,
  			attacker = self:GetCaster(),
  			damage = self:GetAbilityDamage(),
  			damage_type = DAMAGE_TYPE_MAGICAL,
  			ability = self,
  		}

  		ApplyDamage( damage )
  		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 0.2 } )
  	else
      self:SetActivated(true)
      local duration = self:GetSpecialValueFor("duration")
      self.remnant = CreateUnitByName( "npc_dota_zoom_remnant", vLocation, true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
      Timers:CreateTimer(0.1, function()
        self.remnant:AddNewModifier(self:GetCaster(), self, "modifier_zoom_remtant",  {duration = duration})
        self.remnant:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = duration})
        EmitSoundOn("Hero_EmberSpirit.Remnant.Appear", self.remnant)
      end)
    end
  end

	return false
end

if modifier_zoom_remtant == nil then modifier_zoom_remtant = class({}) end

function modifier_zoom_remtant:IsPurgable()
	return false
end

function modifier_zoom_remtant:GetStatusEffectName()
	return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_zoom_remtant:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

function blackzoom_surge:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

