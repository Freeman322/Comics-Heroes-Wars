if officer_artillery_battery == nil then officer_artillery_battery = class({}) end

function officer_artillery_battery:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function officer_artillery_battery:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function officer_artillery_battery:OnAbilityPhaseStart()
	if IsServer() then
		
	end

	return true
end

function officer_artillery_battery:OnSpellStart( )
     if IsServer() then
          local point = self:GetCursorPosition()

          local bases = Entities:FindAllByModel("models/heroes/hero_officer/base/base.vmdl")
          local tick = self:GetSpecialValueFor("tick_interval")
          for _, unit in pairs(bases) do
               for i = 1, unit.i_mRounds do
                    Timers:CreateTimer(i * tick, function()
                         local pos = point + RandomVector(RandomFloat(0, self:GetSpecialValueFor("radius")))
                         local vDirection = pos - unit:GetOrigin()
                         vDirection = vDirection:Normalized()

                         local dist = (point - unit:GetOrigin()):Length2D()

                         local info = 
                         {
                              Ability = self,
                              ---EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
                              vSpawnOrigin = unit:GetAbsOrigin(),
                              fStartRadius = 320,
                              fEndRadius = 320,
                              vVelocity = vDirection * 1600,
                              fDistance = dist,
                              Source = unit,
                              iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                              iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING,
                              iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                              bProvidesVision = true,
                              iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
                              iVisionRadius = 400,
                         }

                         ProjectileManager:CreateLinearProjectile(info)

                         local round = ParticleManager:CreateParticle( "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, unit )
                         ParticleManager:SetParticleAlwaysSimulate( round )

                         ParticleManager:SetParticleControl(round, 0, unit:GetAbsOrigin())
                         ParticleManager:SetParticleControl(round, 1, pos)
                         ParticleManager:SetParticleControl(round, 2, Vector(1600, 0, 0))

                         Timers:CreateTimer(dist / 1600, function()
                              ParticleManager:DestroyParticle(round, true)
                         end)

                         -- Create Sound
                         EmitSoundOn( "Hero_Rattletrap.Rocket_Flare.Fire", unit )
                    end)

                    unit.i_mRounds = 0
               end              
          end
     end
end

function officer_artillery_battery:OnProjectileHit_ExtraData( hTarget, vLocation, table )
     if hTarget == nil then
          local hCaster = self:GetCaster()
          
          local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil );
          ParticleManager:SetParticleControl( nFXIndex, 0, vLocation);
          ParticleManager:SetParticleControl( nFXIndex, 3, vLocation);
          ParticleManager:ReleaseParticleIndex( nFXIndex );

          EmitSoundOnLocationWithCaster(vLocation, "Hero_Rattletrap.Rocket_Flare.Explode", hCaster)
        
          local units = FindUnitsInRadius(hCaster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("damage_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
          for i, target in pairs(units) do  --Restore health and play a particle effect for every found ally.
               local dmg = self:GetAbilityDamage()

               if self:GetCaster():HasTalent("special_bonus_unique_officer_3") then dmg = dmg + self:GetCaster():FindTalentValue("special_bonus_unique_officer_3") end 

               local damage = {
                    victim = target,
                    attacker = hCaster,
                    damage = dmg,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self,
               }

               ApplyDamage( damage )
          end

          AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, 400, 5, true)
     end
end