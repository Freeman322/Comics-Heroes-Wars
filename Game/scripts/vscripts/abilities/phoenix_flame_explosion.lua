phoenix_flame_explosion = class ( {})

function phoenix_flame_explosion:OnSpellStart ()
    if IsServer() then 
        local radius = self:GetSpecialValueFor("radius") 
        local hp = self:GetCaster():GetHealth() * self:GetSpecialValueFor("hp_damage") / 100
        local damage = self:GetSpecialValueFor("damage") + hp

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 0.5 } )
			    ApplyDamage({attacker = self:GetCaster(), victim = unit, damage = damage, ability = self, damage_type = DAMAGE_TYPE_PHYSICAL})	
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_fire_flame_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex2 )

        EmitSoundOn( "Hero_Phoenix.SuperNova.Explode", self:GetCaster() )
    end
end
