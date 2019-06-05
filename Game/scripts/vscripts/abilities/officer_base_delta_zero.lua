if officer_base_delta_zero == nil then officer_base_delta_zero = class({}) end

LinkLuaModifier( "modifier_officer_base_delta_zero_thinker", "abilities/officer_base_delta_zero.lua", LUA_MODIFIER_MOTION_NONE )

function officer_base_delta_zero:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL end
function officer_base_delta_zero:SpeakTrigger() return DOTA_ABILITY_SPEAK_CAST end

function officer_base_delta_zero:OnSpellStart( )
     if IsServer() then
          local point = self:GetCursorPosition()
          local vDirection = point - self:GetCaster():GetOrigin()
          vDirection = vDirection:Normalized()

          local dist = (point - self:GetCaster():GetOrigin()):Length2D()

          local info = 
          {
               Ability = self,
               ---EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
               vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
               fStartRadius = 320,
               fEndRadius = 320,
               vVelocity = vDirection * 1600,
               fDistance = dist,
               Source = self:GetCaster(),
               iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
               iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING,
               iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
               bProvidesVision = true,
               iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
               iVisionRadius = 400,
          }

          ProjectileManager:CreateLinearProjectile(info)

          local round = ParticleManager:CreateParticle( "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster() )
          ParticleManager:SetParticleAlwaysSimulate( round )

          ParticleManager:SetParticleControl(round, 0, self:GetCaster():GetAbsOrigin())
          ParticleManager:SetParticleControl(round, 1, point)
          ParticleManager:SetParticleControl(round, 2, Vector(1600, 0, 0))

          Timers:CreateTimer(dist / 1600, function()
               ParticleManager:DestroyParticle(round, true)
          end)

          -- Create Sound
          EmitSoundOn( "Hero_Rattletrap.Rocket_Flare.Fire", self:GetCaster() )
     end
end

function officer_base_delta_zero:OnProjectileHit_ExtraData( hTarget, vLocation, table )
     if hTarget == nil then
          local hCaster = self:GetCaster()
          
          local nFXIndex = ParticleManager:CreateParticle( "particles/officer/dase_delta_zero.vpcf", PATTACH_CUSTOMORIGIN, nil );
          ParticleManager:SetParticleControl( nFXIndex, 0, vLocation);
          ParticleManager:SetParticleControl( nFXIndex, 1, Vector(600, 0, 0));
          ParticleManager:SetParticleControl( nFXIndex, 2, vLocation);
          ParticleManager:SetParticleControl( nFXIndex, 3, vLocation);
          ParticleManager:SetParticleControl( nFXIndex, 4, vLocation);
          ParticleManager:SetParticleControl( nFXIndex, 5, Vector(1000, 1000, 0));
          ParticleManager:ReleaseParticleIndex( nFXIndex );

          EmitSoundOnLocationWithCaster(vLocation, "Hero_Rattletrap.Rocket_Flare.Explode", hCaster)
          EmitSoundOnLocationWithCaster(vLocation, "Hero_EarthShaker.EchoSlam", hCaster)
          EmitSoundOnLocationWithCaster(vLocation, "Hero_EarthShaker.EchoSlamSmall", hCaster)
          EmitSoundOnLocationWithCaster(vLocation, "PudgeWarsClassic.echo_slam", hCaster)
        
          local units = FindUnitsInRadius(hCaster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius_damage_max"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
          for i, target in ipairs(units) do  --Restore health and play a particle effect for every found ally.
               local damage = self:GetSpecialValueFor("radius_damage_max") - (target:GetAbsOrigin() - vLocation):Length2D()
               local damage = {
                    victim = target,
                    attacker = hCaster,
                    damage = damage * self:GetSpecialValueFor("damage_per_distance_mult"),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self,
               }

               ApplyDamage( damage )
          end

          CreateModifierThinker (hCaster, self, "modifier_officer_base_delta_zero_thinker", {damage = self:GetSpecialValueFor("damage_second"), duration = self:GetSpecialValueFor("debuff_duration") }, vLocation, hCaster:GetTeamNumber(), false)

          AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, 400, 5, true)
     end
end


modifier_officer_base_delta_zero_thinker = class({})

modifier_officer_base_delta_zero_thinker.m_iDamage = 0

function modifier_officer_base_delta_zero_thinker:OnCreated (event)
     if IsServer() then
          self.m_iDamage = event.damage

          self:StartIntervalThink(1)
     end
end

function modifier_officer_base_delta_zero_thinker:OnIntervalThink()
     if IsServer() then
          local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self:GetAbility():GetSpecialValueFor("radius_damage_max"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
          if #units > 0 then
               for _,unit in pairs(units) do
                    local damage = {
                         victim = unit,
                         attacker = self:GetCaster(),
                         damage = self.m_iDamage,
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         ability = self:GetAbility()
                    }

                    if not unit:IsMagicImmune() then              
                         EmitSoundOn("Hero_Alchemist.AcidSpray.Damage", unit)
                         ApplyDamage( damage )
                    end
               end
          end
     end
end

