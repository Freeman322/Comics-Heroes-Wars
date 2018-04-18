roug_embrace_of_ethernity = class({})
LinkLuaModifier( "modifier_roug_embrace_of_ethernity", "abilities/roug_embrace_of_ethernity.lua" ,LUA_MODIFIER_MOTION_NONE )

function roug_embrace_of_ethernity:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function roug_embrace_of_ethernity:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end


function roug_embrace_of_ethernity:GetChannelTime()
		return self:GetSpecialValueFor("channel_time")
end

function roug_embrace_of_ethernity:GetCooldown( nLevel )
  if self:GetCaster():HasScepter() then
    return self:GetSpecialValueFor("cooldown_scepter")
  end
  return self.BaseClass.GetCooldown( self, nLevel )
end


function roug_embrace_of_ethernity:GetBehavior()
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function roug_embrace_of_ethernity:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

function roug_embrace_of_ethernity:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_roug_embrace_of_ethernity", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end

function roug_embrace_of_ethernity:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "roug_embrace_of_ethernity" )
	end
end

modifier_roug_embrace_of_ethernity = class({})


function modifier_roug_embrace_of_ethernity:IsDebuff()
	return true
end


function modifier_roug_embrace_of_ethernity:IsStunDebuff()
	return true
end

function modifier_roug_embrace_of_ethernity:IsPurgable()
	return false
end

function modifier_roug_embrace_of_ethernity:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_timewalk.vpcf"
end

function modifier_roug_embrace_of_ethernity:StatusEffectPriority()
	return 1000
end

function modifier_roug_embrace_of_ethernity:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )/100
	self.tick_rate = 0.1

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )

    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )

    ParticleManager:SetParticleControlEnt( nFXIndex, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( nFXIndex, 6, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )

    EmitSoundOn("Hero_Enigma.Malefice", self:GetParent())
	end
end

function modifier_roug_embrace_of_ethernity:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

function modifier_roug_embrace_of_ethernity:OnIntervalThink()
	if IsServer() then
		local flDamage = ((self:GetAbility():GetSpecialValueFor("damage_pers")/100)*self:GetParent():GetHealth())/10
    if self:GetCaster():HasScepter() then
      flDamage = ((self:GetAbility():GetSpecialValueFor("damage_pers_scepter")/100)*self:GetParent():GetHealth())/10
    end

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
    local hTarget = self:GetParent()
		ApplyDamage( damage )
	end
end

function modifier_roug_embrace_of_ethernity:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
    [MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

function roug_embrace_of_ethernity:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

