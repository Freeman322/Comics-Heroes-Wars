golden_god_aoe = class({})

function golden_god_aoe:GetAOERadius() return self:GetSpecialValueFor("radius") end

function golden_god_aoe:OnSpellStart()
    if IsServer() then
        local radius = self:GetSpecialValueFor("radius")

        local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false )
        if #allies > 0 then
            for _,ally in pairs(allies) do
                ally:AddNewModifier(self:GetCaster(), self, "modifier_black_king_bar_immune", {duration = self:GetSpecialValueFor("duration")})

                local nFXIndex = ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
                ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCursorPosition())
                ParticleManager:SetParticleControl(nFXIndex, 1, Vector(radius, radius, 0))
                ParticleManager:ReleaseParticleIndex(nFXIndex)

                ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally))
            end
        end

        EmitSoundOn("Hero_Omniknight.Purification.Wingfall", self:GetCaster())
    end
end
