aqua_man_water_wave = class ( {})

function aqua_man_water_wave:OnSpellStart ()
    if IsServer() then 
        local radius = self:GetSpecialValueFor( "radius" ) 
        local duration = self:GetSpecialValueFor(  "duration" )

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_slardar_amplify_damage", { duration = duration } )
                unit:AddNewModifier( self:GetCaster(), self, "modifier_slithereen_crush",  { duration = duration } )
                unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 1.0 } )
			    ApplyDamage({attacker = self:GetCaster(), victim = unit, damage = self:GetAbilityDamage(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})	
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/slardar/slardar_takoyaki/slardar_crush_tako.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		
		local nFXIndex2 = ParticleManager:CreateParticle( "particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Slardar.Slithereen_Crush_Tako", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end
end
