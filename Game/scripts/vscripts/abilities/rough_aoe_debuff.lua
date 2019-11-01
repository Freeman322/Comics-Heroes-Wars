rough_aoe_debuff = class({})

function rough_aoe_debuff:GetAOERadius()
    return self:GetSpecialValueFor( "radius" )
end

function rough_aoe_debuff:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function rough_aoe_debuff:OnSpellStart()
    if IsServer() then 
        local caster = self:GetCaster()
        local point = self:GetCursorPosition()
        local team_id = caster:GetTeamNumber()
        local sound = "Hero_Silencer.Curse.Impact"

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "succubus") then
          local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_CUSTOMORIGIN, nil );
          ParticleManager:SetParticleControl( nFXIndex, 0, point);
          ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetSpecialValueFor( "radius" ), self:GetSpecialValueFor( "radius" ), 0) );
          ParticleManager:SetParticleControl( nFXIndex, 3, point);
          ParticleManager:ReleaseParticleIndex( nFXIndex );
          sound = "Hero_QueenOfPain.ScreamOfPain"
        else
          local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil );
          ParticleManager:SetParticleControl( nFXIndex, 0, point);
          ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetSpecialValueFor( "radius" ), self:GetSpecialValueFor( "radius" ), 0) );
          ParticleManager:SetParticleControl( nFXIndex, 3, point);
          ParticleManager:ReleaseParticleIndex( nFXIndex );
        end

        EmitSoundOn(sound, self:GetCaster()) 

        local units = FindUnitsInRadius( caster:GetTeamNumber(), point, caster, self:GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                local damage = {
                    victim = unit,
                    attacker = caster,
                    damage = self:GetSpecialValueFor("damage"),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
               
                unit:AddNewModifier( caster, self, "modifier_silence", { duration = self:GetSpecialValueFor("tooltip_duration") } )

                ApplyDamage( damage )
            end
        end
    end
end