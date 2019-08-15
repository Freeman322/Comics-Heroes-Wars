if valkorion_force_wave == nil then valkorion_force_wave = class({}) end

function valkorion_force_wave:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function valkorion_force_wave:OnSpellStart()
     if IsServer() then
          local duration = self:GetSpecialValueFor(  "duration" )

          local damage = self:GetSpecialValueFor("damage")
      
          if self:GetCaster():HasTalent("special_bonus_unique_valkorion_1") then
               damage = damage + self:GetCaster():FindTalentValue("special_bonus_unique_valkorion_1")
          end
      
          local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), self:GetCaster(), self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
          if #targets > 0 then
               for _,target in pairs(targets) do
                    target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )
                    ApplyDamage({attacker = self:GetCaster(), victim = target, damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
               end
          end
      
          EmitSoundOn("Hero_ObsidianDestroyer.Equilibrium.Cast", self:GetCaster())
      
          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_cast_arcana_water.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
          ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetCursorPosition() )
          ParticleManager:SetParticleControl( nFXIndex, 2, Vector(400, 400, 0) )
          ParticleManager:ReleaseParticleIndex( nFXIndex )
     end 
end