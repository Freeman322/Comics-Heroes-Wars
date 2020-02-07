manhattan_dark_projectile = class({})

local FADE_TIME = 0.15

--------------------------------------------------------------------------------

function manhattan_dark_projectile:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function manhattan_dark_projectile:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function manhattan_dark_projectile:GetChannelTime() return self:GetSpecialValueFor("channel_time") end

manhattan_dark_projectile.m_flElapsedTime = 0

function manhattan_dark_projectile:GetElapsedTime() return self.m_flElapsedTime end

--------------------------------------------------------------------------------

function manhattan_dark_projectile:OnAbilityPhaseStart()
     if IsServer() then
          self.hVictim = self:GetCursorTarget()
          self.m_flElapsedTime = 0
     end
     
	return true
end

--------------------------------------------------------------------------------

function manhattan_dark_projectile:OnSpellStart()
	if self.hVictim == nil then
		return
     end
     
     self.hVictim:Interrupt()

     if self.hVictim:TriggerSpellAbsorb( self ) then self.hVictim = nil self:GetCaster():Interrupt() return end 
end

--------------------------------------------------------------------------------

function manhattan_dark_projectile:OnChannelThink(flTime)
     if IsServer() then 
          self.m_flElapsedTime = self.m_flElapsedTime + flTime
     end 
end

--------------------------------------------------------------------------------

function manhattan_dark_projectile:OnChannelFinish( bInterrupted )
     if IsServer() then
          if self.hVictim then
               local radius = self:GetSpecialValueFor("radius")
               local damage = self:GetSpecialValueFor("damage_charge_ptc")
               local mult = self:GetSpecialValueFor("channel_time") / 1.5

               if self:GetCaster():HasTalent("special_bonus_unique_manhattan_3") then damage = damage + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_manhattan_3") or 0) end 

               damage = damage / 100 

               local total = 0

               local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
               
               if #units > 0 then
                    for _,unit in pairs(units) do
                         local nFXIndex = ParticleManager:CreateParticle( "particles/effects/pudge_soul_drain_heal.vpcf", PATTACH_ABSORIGIN, unit )
                         ParticleManager:SetParticleControl( nFXIndex, 0, unit:GetOrigin() )
                         ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetAbsOrigin() )
                         ParticleManager:ReleaseParticleIndex( nFXIndex )

                         EmitSoundOn ("Manhattan.Elemental_Fragmentation.Damage", unit)

                         total = total + (unit:GetAverageTrueAttackDamage(unit) * damage)
                    end
               end

               total = total * mult

               local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil );
               ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
               ParticleManager:SetParticleControlEnt( nFXIndex, 1, self.hVictim, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hVictim:GetOrigin(), true );
               ParticleManager:ReleaseParticleIndex( nFXIndex );
          
               local nFXIndex = ParticleManager:CreateParticle( "particles/manhattan_energy_surge.vpcf", PATTACH_ABSORIGIN, self.hVictim )
               ParticleManager:SetParticleControl( nFXIndex, 0, self.hVictim:GetOrigin() )
               ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 1) )
               ParticleManager:SetParticleControl( nFXIndex, 10, Vector(1, 0, 0) )
               ParticleManager:SetParticleControl( nFXIndex, 11, Vector(1, 1, 0))
               ParticleManager:ReleaseParticleIndex( nFXIndex )
          
               local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.hVictim :GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
               
               if #targets > 0 then
                    for _,target in pairs(targets) do
                         ApplyDamage ( { attacker = self:GetCaster(), victim = target, ability = self, damage = total + self:GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL})
                    end
               end

               EmitSoundOn( "Hero_Earthshaker.BlinkDagger.Arcana", self:GetCaster() )
          
               self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1 );
          end
     end 

     self.m_flElapsedTime = 0
end
