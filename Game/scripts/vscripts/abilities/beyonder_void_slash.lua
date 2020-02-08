beyonder_void_slash = class({})

function beyonder_void_slash:OnSpellStart()
     if IsServer() then
          -- unit identifier
          local caster = self:GetCaster()
          local pos = self:GetCursorPosition()

          -- load data
          local duration = self:GetSpecialValueFor( "debuff_duration" )
          local damage_ptc = self:GetSpecialValueFor( "crit_mult" )
          local radius = self:GetSpecialValueFor( "radius" )
          local delay = self:GetSpecialValueFor( "pop_damage_delay" )

          if self:GetCaster():HasTalent("special_bonus_unique_beyonder_3") then
               damage_ptc = damage_ptc + self:GetCaster():FindTalentValue("special_bonus_unique_beyonder_3")
          end

          damage_ptc = damage_ptc / 100

          EmitSoundOn("Hero_VoidSpirit.AstralStep.MarkExplosionAOE", caster)

          caster:SetAbsOrigin(pos)
          FindClearSpaceForUnit(caster, pos, true)

          local units = FindUnitsInRadius( caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
          if #units > 0 then
               for _,unit in pairs(units) do
                    unit:AddNewModifier( caster, self, "modifier_grimstroke_dark_artistry_slow", { duration = duration } )
                    unit:AddNewModifier( caster, self, "modifier_void_spirit_astral_step_debuff", { duration = delay } )

                    EmitSoundOn( "Hero_VoidSpirit.AstralStep.Target", unit )

                    ApplyDamage({victim = unit, attacker = caster, damage = caster:GetAttackDamage() * damage_ptc, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self})
               end
          end

          -- adjustment
          local radius = radius * 2

          -- Create Particle
          local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
          ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
          ParticleManager:ReleaseParticleIndex( effect_cast )

          -- Create Sound
          EmitSoundOn( "Hero_VoidSpirit.Pulse", caster )
          EmitSoundOn( "Hero_VoidSpirit.Pulse.Cast", caster )

          caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
     end
end
