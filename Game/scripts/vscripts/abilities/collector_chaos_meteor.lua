collector_chaos_meteor = class({})
LinkLuaModifier( "modifier_collector_chaos_meteor_burn", "abilities/collector_chaos_meteor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_collector_chaos_meteor_delay", "abilities/collector_chaos_meteor.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_collector_chaos_meteor_thinker", "abilities/collector_chaos_meteor.lua", LUA_MODIFIER_MOTION_NONE )

function collector_chaos_meteor:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end


function collector_chaos_meteor:IsStealable()
  return false
end

function collector_chaos_meteor:GetAbilityDamageType()
  return IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_collector_1") or DAMAGE_TYPE_MAGICAL
end


--------------------------------------------------------------------------------
-- Ability Start
function collector_chaos_meteor:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create modifier thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_collector_chaos_meteor_delay", -- modifier name
		{ duration = delay },
		point,
		caster:GetTeamNumber(),
		false
	)
end

modifier_collector_chaos_meteor_delay = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_collector_chaos_meteor_delay:IsHidden()
	return true
end

function modifier_collector_chaos_meteor_delay:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_collector_chaos_meteor_delay:OnCreated( kv )
  if IsServer() then
      local particle = "particles/items4_fx/meteor_hammer_aoe.vpcf"
      local sound = "Hero_ElderTitan.EchoStomp.Channel.ti7"
      if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alma") then
          particle = "particles/collector/alma_meteor_aoe.vpcf"
      end

      if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "strange_artifact") then
        particle = "particles/units/heroes/hero_void_spirit/void_spirit_astral_step_destination.vpcf"
        sound = "Hero_VoidSpirit.Dissimilate.Cast"
    end

      local fx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, self:GetParent() )
      ParticleManager:SetParticleControl( fx, 0, self:GetParent():GetOrigin() )
      ParticleManager:SetParticleControl( fx, 1, Vector( self:GetAbility():GetSpecialValueFor("area_of_effect"), 1, 1 ) )
      self:AddParticle(fx, false, false, -1, false, false)

      -- Create Sound
      EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound, self:GetCaster() )
  end
end

function modifier_collector_chaos_meteor_delay:OnDestroy( kv )
  if IsServer() then
      CreateModifierThinker(
          self:GetAbility():GetCaster(), -- player source
          self:GetAbility(), -- ability source
          "modifier_collector_chaos_meteor_thinker", -- modifier name
          { duration = self:GetAbility():GetOrbSpecialValueFor( "duration", "w" ) },
          self:GetParent():GetAbsOrigin(),
          self:GetAbility():GetCaster():GetTeamNumber(),
          false
      )
  end
end


modifier_collector_chaos_meteor_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_collector_chaos_meteor_thinker:IsHidden()
	return true
end

function modifier_collector_chaos_meteor_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_collector_chaos_meteor_thinker:OnCreated( kv )
	if IsServer() then
		self.burn_duration = self:GetAbility():GetSpecialValueFor("burn_duration")
		self.radius = self:GetAbility():GetSpecialValueFor("area_of_effect")
        self.damage_pct = self:GetAbility():GetSpecialValueFor("damage")
        self._iDamage = self:GetAbility():GetOrbSpecialValueFor( "damage", "e" )
    
		self:StartIntervalThink(1)
	end
end

function modifier_collector_chaos_meteor_thinker:OnIntervalThink()
  if IsServer() then
      local sound2 = "Hero_ElderTitan.EchoStomp.ti7"
      local particle = "particles/items4_fx/meteor_hammer_spell.vpcf"
      if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alma") then
          particle = "particles/collector/alma_meteor_proj.vpcf"
      end

      if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "strange_artifact") then
        particle = "particles/stygian/collector_kid_meteor.vpcf"
        sound2 = "Hero_VoidSpirit.Dissimilate.Stun"
      end

      local fx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, self:GetCaster() )
      ParticleManager:SetParticleControl( fx, 0, Vector(self:GetParent():GetOrigin().x + 1000, self:GetParent():GetOrigin().y + 1000, self:GetParent():GetOrigin().z + 3000) )
      ParticleManager:SetParticleControl( fx, 1, self:GetParent():GetOrigin() )
      ParticleManager:SetParticleControl( fx, 2, Vector( 0.5, self.radius, 0 ) )
      ParticleManager:ReleaseParticleIndex( fx )
      -- find caught units
      local enemies = FindUnitsInRadius(
          self:GetCaster():GetTeamNumber(),
          self:GetParent():GetOrigin(),
          nil,
          self.radius,
          DOTA_UNIT_TARGET_TEAM_ENEMY,
          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          DOTA_UNIT_TARGET_FLAG_NONE,
          0,
          false
      )
      for _, enemy in pairs(enemies) do
          enemy:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_collector_chaos_meteor_burn", {duration = self.burn_duration})

          --[[if self:GetCaster():HasTalent("special_bonus_unique_collector_1") then
              enemy:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetCaster():FindTalentValue("special_bonus_unique_collector_1")})
          end]]--

          local damageTable = {
              attacker = self:GetAbility():GetCaster(),
              damage_type = self:GetAbility():GetAbilityDamageType(),
              ability = self:GetAbility(),
              damage =  self._iDamage,
              victim = enemy
          }

          ApplyDamage(damageTable)
      end

      EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound2, self:GetCaster() )
  end
end



if modifier_collector_chaos_meteor_burn == nil then modifier_collector_chaos_meteor_burn = class ( {}) end

function modifier_collector_chaos_meteor_burn:GetEffectName ()
  return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf"
end

function modifier_collector_chaos_meteor_burn:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_collector_chaos_meteor_burn:OnCreated(event)
  if IsServer() then
    local thinker = self:GetParent()
    local ability = self:GetAbility()

    if thinker:IsBuilding() or thinker:IsAncient() then
      self:Destroy()
    end

    self:StartIntervalThink(0.1)
  end
end

function modifier_collector_chaos_meteor_burn:OnIntervalThink()
  if IsServer() then
    local damage = self:GetAbility():GetOrbSpecialValueFor( "burn_dps", "e" )

    ApplyDamage ({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage / 10, damage_type = self:GetAbility():GetAbilityDamageType()})
  end
end

function modifier_collector_chaos_meteor_burn:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

