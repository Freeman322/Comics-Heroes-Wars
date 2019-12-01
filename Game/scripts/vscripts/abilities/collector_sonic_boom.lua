if not collector_sonic_boom then collector_sonic_boom = class({}) end

function collector_sonic_boom:IsStealable()
    return false
end

function collector_sonic_boom:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_alma") then return "custom/alma_aoe" end
    return self.BaseClass.GetAbilityTextureName(self)
end

function collector_sonic_boom:OnSpellStart()
    if IsServer() then
        local iAoE = self:GetSpecialValueFor( "radius" )
        local iDmg = self:GetOrbSpecialValueFor( "damage", "e" )
        local iStun = self:GetOrbSpecialValueFor("stun_duration", "w")

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), iAoE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _, target in pairs(units) do
                target:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self:GetOrbSpecialValueFor( "stun_duration", "w"  ) } )
                ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = iDmg, damage_type = DAMAGE_TYPE_MAGICAL})
                EmitSoundOn("Hero_ElderTitan.EarthSplitter.Destroy", target)
            end
        end

        local sound_cast = "Hero_ElderTitan.EchoStomp.ti7"
        local particle_cast = "particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf"
        local sound = "Hero_ElderTitan.EchoStomp.ti7_layer"

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alma") then
            particle_cast = "particles/collector/alma_sonic_boom.vpcf"
            sound_cast =    "Alma.SonicBoom.Cast"
        end

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "strange_artifact") then
            particle_cast = "particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide.vpcf"
            sound_cast =  "Hero_NagaSiren.Riptide.Cast"
            sound = "Ability.GushImpact"
        end

        local nFXIndex = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster() );
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(iAoE, iAoE, 0));
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(255, 255, 255));
        ParticleManager:SetParticleControl( nFXIndex, 3, self:GetCaster():GetAbsOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 6, self:GetCaster():GetAbsOrigin());
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        EmitSoundOn(sound_cast, self:GetCaster())
        EmitSoundOn(sound, self:GetCaster())
    end
end
