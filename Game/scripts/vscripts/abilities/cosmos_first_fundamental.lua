cosmos_first_fundamental = class({})

--------------------------------------------------------------------------------

function cosmos_first_fundamental:OnSpellStart()
     if IsServer() then
          local radius = self:GetSpecialValueFor( "radius" ) 
          local duration = self:GetSpecialValueFor(  "stun_duration" )

          local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
          if #units > 0 then
               for _,unit in pairs(units) do
                    unit:SetAbsOrigin(self:GetCaster():GetAbsOrigin())
                    
                    FindClearSpaceForUnit(unit, self:GetCaster():GetAbsOrigin(), true)

                    unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )

                    ApplyDamage({
                         victim = unit,
                         attacker = self:GetCaster(),
                         damage = self:GetAbilityDamage(),
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         ability = self
                    })
               end
          end

          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_cast_water_ground.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
          ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
          ParticleManager:ReleaseParticleIndex( nFXIndex )

          EmitSoundOn( "Hero_Wisp.Return", self:GetCaster() )
     end
end
