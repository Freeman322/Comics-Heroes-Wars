golden_god_aoe = class({})

function golden_god_aoe:GetAOERadius ()
    return self:GetSpecialValueFor("radius")
end

function golden_god_aoe:GetBehavior ()
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function golden_god_aoe:OnSpellStart ()
    if IsServer() then 
        local radius = self:GetSpecialValueFor( "radius" ) 
        local duration = self:GetSpecialValueFor(  "duration" )

        local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCursorTarget():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #allies > 0 then
            for _,ally in pairs(allies) do
                ally:AddNewModifier( self:GetCaster(), self, "modifier_black_king_bar_immune", { duration = duration } )


                local nCasterFX = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally )
                ParticleManager:ReleaseParticleIndex( nCasterFX )
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCursorTarget():GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, 0) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "Hero_Omniknight.Purification.Wingfall", self:GetCaster() )
    end
end
