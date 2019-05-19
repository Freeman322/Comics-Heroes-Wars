shazam_lightning_charge = class({})

local FADE_TIME = 0.15

LinkLuaModifier("modifier_shazam_lightning_charge", "abilities/shazam_lightning_charge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shazam_lightning_charge_dummy", "abilities/shazam_lightning_charge.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function shazam_lightning_charge:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function shazam_lightning_charge:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end
function shazam_lightning_charge:GetChannelTime() return self:GetSpecialValueFor("channel") end

shazam_lightning_charge.m_flElapsedTime = 0

function shazam_lightning_charge:GetElapsedTime() return self.m_flElapsedTime end

--------------------------------------------------------------------------------

function shazam_lightning_charge:OnAbilityPhaseStart()
     if IsServer() then
          self.hVictim = self:GetCursorTarget()
          self.m_flElapsedTime = 0
     end
     
	return true
end

--------------------------------------------------------------------------------

function shazam_lightning_charge:OnSpellStart()
	if self.hVictim == nil then
		return
     end
     
     self.hVictim:Interrupt()

     if self.hVictim:TriggerSpellAbsorb( self ) then self.hVictim = nil self:GetCaster():Interrupt() return end 
end

--------------------------------------------------------------------------------

function shazam_lightning_charge:OnChannelThink(flTime)
     if IsServer() then 
          self.m_flElapsedTime = self.m_flElapsedTime + flTime
     end 
end

--------------------------------------------------------------------------------

function shazam_lightning_charge:OnChannelFinish( bInterrupted )
     if IsServer() then
          if self.hVictim then
               self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_shazam_lightning_charge", { duration = FADE_TIME, damage = self:GetElapsedTime()} )	
               
               local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil );
               ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + Vector( 0, 0, 96 ), true );
               ParticleManager:SetParticleControlEnt( nFXIndex, 1, self.hVictim, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hVictim:GetOrigin(), true );
               ParticleManager:ReleaseParticleIndex( nFXIndex );

               EmitSoundOn( "Ability.LagunaBladeImpact", self:GetCaster() )
          end
     end 

     self.m_flElapsedTime = 0
end

modifier_shazam_lightning_charge = class({})

modifier_shazam_lightning_charge.m_iMult = 1

function modifier_shazam_lightning_charge:IsHidden() return true end
function modifier_shazam_lightning_charge:IsPurgable() return false end
function modifier_shazam_lightning_charge:IsDebuff() return true end
function modifier_shazam_lightning_charge:IsPurgable() return false end

function modifier_shazam_lightning_charge:OnCreated(params)
     if IsServer() then
          self.m_iMult = params.damage
     end 
end
--------------------------------------------------------------------------------

function modifier_shazam_lightning_charge:OnDestroy()
     if IsServer() then
          
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetSpecialValueFor( "damage" ) * self.m_iMult,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

          ApplyDamage( damage )
          
          self:Bounce(self:GetParent())
	end
end

function modifier_shazam_lightning_charge:Bounce(unit)
    if IsServer() then
          if not unit:IsNull() and unit then 
               local radius = self:GetAbility():GetSpecialValueFor("radius_bounce")
               local stun = self:GetAbility():GetSpecialValueFor("stun_dur")

               if self:GetCaster():HasTalent("special_bonus_unique_shazam_2") then radius = radius + self:GetCaster():FindTalentValue("special_bonus_unique_shazam_2")  end 
               if self:GetCaster():HasTalent("special_bonus_unique_shazam_3") then  stun = stun + self:GetCaster():FindTalentValue("special_bonus_unique_shazam_3") end 

               unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = stun})
               unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_shazam_lightning_charge_dummy", { duration = 3.0 } )

               local units = FindUnitsInRadius( unit:GetTeamNumber(), unit:GetOrigin(), unit, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
               if #units > 0 then
                    for _, taget in pairs(units) do
                         if taget ~= unit and not taget:HasModifier("modifier_shazam_lightning_charge_dummy") then
                              taget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_shazam_lightning_charge", { duration = FADE_TIME, damage = self.m_iMult } )
                              taget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_shazam_lightning_charge_dummy", { duration = 3.0 } )

                              local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil );
                              ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin() + Vector( 0, 0, 96 ), true );
                              ParticleManager:SetParticleControlEnt( nFXIndex, 1, taget, PATTACH_POINT_FOLLOW, "attach_hitloc", taget:GetOrigin(), true );
                              ParticleManager:ReleaseParticleIndex( nFXIndex );
                    
                              EmitSoundOn( "Ability.LagunaBladeImpact", taget )

                              break
                         end
                    end
               end
          end
    end 
end

modifier_shazam_lightning_charge_dummy = class({})

function modifier_shazam_lightning_charge_dummy:IsHidden() return true end
function modifier_shazam_lightning_charge_dummy:IsPurgable() return false end
function modifier_shazam_lightning_charge_dummy:IsDebuff() return true end
function modifier_shazam_lightning_charge_dummy:IsPurgable() return false end