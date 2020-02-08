beyonder_astral_step = class({})
--------------------------------------------------------------------------------

beyonder_astral_step.m_hParticles = {}

local VACCUM_DURATION = 1.45
local VACUUM_SPEED = 70
local RADIUS = 500

function beyonder_astral_step:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function beyonder_astral_step:Spawn()
     if IsServer() then
          self:SetLevel(1)
     end
end

--------------------------------------------------------------------------------

function beyonder_astral_step:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function beyonder_astral_step:GetChannelTime()
     local delay = self:GetSpecialValueFor("teleport_delay")

	if IsServer() then
          if self:GetCaster():HasTalent("special_bonus_unique_beyonder_4") then
               delay = delay - self:GetCaster():FindTalentValue("special_bonus_unique_beyonder_4")
          end
	end

	return delay
end

--------------------------------------------------------------------------------

function beyonder_astral_step:OnAbilityPhaseStart()
	if IsServer() then
		self.m_vPos = self:GetCursorPosition()
	end

	return true
end

--------------------------------------------------------------------------------

function beyonder_astral_step:OnSpellStart()
     if IsServer() then
          if self.m_vPos == nil then
               return
          end

          local caster = self:GetCaster()

          local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/debut/void_spirit_portal_debut.vpcf", PATTACH_CUSTOMORIGIN, nil)
          ParticleManager:SetParticleControl(particle, 0, self.m_vPos + Vector(0, 0, 125))
          ParticleManager:SetParticleControl(particle, 1, self.m_vPos + Vector(0, 0, 125))
          ParticleManager:SetParticleControl(particle, 2, self.m_vPos + Vector(0, 0, 125))
     
          table.insert(self.m_hParticles, particle)

          local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/debut/void_spirit_portal_debut.vpcf", PATTACH_CUSTOMORIGIN, nil)
          ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin() + Vector(0, 0, 125))
          ParticleManager:SetParticleControl(particle2, 1, caster:GetAbsOrigin() + Vector(0, 0, 125))
          ParticleManager:SetParticleControl(particle2, 2, caster:GetAbsOrigin() + Vector(0, 0, 125))
     
          table.insert(self.m_hParticles, particle2)

          EmitSoundOnLocationWithCaster(self.m_vPos, "Hero_AbyssalUnderlord.DarkRift.Cast", caster)
          EmitSoundOnLocationWithCaster(caster:GetAbsOrigin() , "Hero_AbyssalUnderlord.DarkRift.Cast", caster)
     end
end


--------------------------------------------------------------------------------

function beyonder_astral_step:OnChannelFinish( bInterrupted )
     if IsServer() then
          local caster = self:GetCaster()

          for k, particle in pairs(self.m_hParticles) do 
               if particle then
                    ParticleManager:DestroyParticle(particle, true)
               end
          end

          self:Clear()

          if not bInterrupted then
               self:Teleport()
          else 
               EmitSoundOnLocationWithCaster(self.m_vPos, "Hero_AbyssalUnderlord.DarkRift.Cancel", caster)
               EmitSoundOnLocationWithCaster(caster:GetAbsOrigin() , "Hero_AbyssalUnderlord.DarkRift.Cancel", caster)
          end
     end
end

function beyonder_astral_step:Teleport()
     local caster = self:GetCaster()

     EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Complete", caster)

     caster:SetAbsOrigin(self.m_vPos)
     FindClearSpaceForUnit(caster, self.m_vPos, true)

     local units = FindUnitsInRadius( caster:GetTeamNumber(), self.m_vPos, nil, RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
     if #units > 0 then
          for _,unit in pairs(units) do
               EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Target", unit )

               ApplyDamage({victim = unit, attacker = caster, damage = self:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
          end
     end

     -- adjustment
     local radius = RADIUS * 2

     -- Create Particle
     local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
     ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
     ParticleManager:ReleaseParticleIndex( effect_cast )

     -- Create Sound
     EmitSoundOn( "Hero_VoidSpirit.Pulse", caster )
     EmitSoundOn( "Hero_VoidSpirit.Pulse.Cast", caster )

     self:Vacuum(units)
end

function beyonder_astral_step:Clear()
     self.m_hParticles = nil
     self.m_hParticles = {}
end

function beyonder_astral_step:Vacuum(units)
	local caster = self:GetCaster()
     local duration = VACCUM_DURATION

     Timers:CreateTimer(0.03, function() 
          duration = duration - 0.03

          if duration <= 0 then
               return nil
          end

          for _,unit in pairs(units) do
               local unit_location = unit:GetAbsOrigin()

               local vector_distance = self.m_vPos - unit_location

               local distance = vector_distance:Length2D()
               local direction = vector_distance:Normalized()

               if unit:HasModifier("modifier_stunned") == false then
                    unit:AddNewModifier(caster, self, "modifier_stunned", {duration = 1})
               end

               if distance < 128 then
                    FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
               else 
                    unit:SetAbsOrigin(unit_location + direction * VACUUM_SPEED * 0.03)
               end
          end
          
          return 0.03
     end)     
end
