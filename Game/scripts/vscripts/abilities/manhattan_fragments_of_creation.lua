manhattan_fragments_of_creation = class({})

LinkLuaModifier( "modifier_manhattan_fragments_of_creation", "abilities/manhattan_fragments_of_creation.lua" ,LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function manhattan_fragments_of_creation:OnSpellStart()
     if IsServer() then
          local vDirection = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized()
 
          local stun = self:GetSpecialValueFor("stun_duration")
          local base_damage = self:GetAbilityDamage()
          local ptc = self:GetSpecialValueFor("damage_pct") / 100

          local dest_pos = self:GetCaster():GetAbsOrigin() + vDirection * self:GetSpecialValueFor("crack_distance")

          local nFXIndex = ParticleManager:CreateParticle( "particles/dr_manhattan/manhattan_rope_trail.vpcf", PATTACH_CUSTOMORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() + Vector(0, 0, 96) );
		ParticleManager:SetParticleControl( nFXIndex, 1, dest_pos + Vector(0, 0, 96) );
          ParticleManager:ReleaseParticleIndex( nFXIndex );

          local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE

          local unit_table = FindUnitsInLine(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), dest_pos, nil, self:GetSpecialValueFor("crack_width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, target_flags)
          if #unit_table > 0 then
               for k, unit in pairs(unit_table) do 
                    EmitSoundOn( "Hero_Earthshaker.Arcana.ComboDamageTick" , self:GetCaster() )

                    unit:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun})
                    ApplyDamage({attacker = self:GetCaster(), victim = unit, ability = self, damage = base_damage + (unit:GetHealth() * ptc), damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
               end
          end

          self:GetCaster():SetAbsOrigin(dest_pos)
          FindClearSpaceForUnit(self:GetCaster(), dest_pos, true)
          
          EmitSoundOn( "Hero_EarthShaker.Arcana.run_alt2" , self:GetCaster() )
          EmitSoundOn( "Hero_EarthShaker.Arcana.run_alt1" , self:GetCaster() )
     end
end
