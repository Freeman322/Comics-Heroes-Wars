rough_aoe_debuff = class({})

function rough_aoe_debuff:GetAOERadius()
    return self:GetSpecialValueFor( "radius" )
end

function rough_aoe_debuff:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function rough_aoe_debuff:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    
    local flDamagePerTick = self:GetSpecialValueFor("damage")


    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil );
    ParticleManager:SetParticleControl( nFXIndex, 0, point);
    ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetSpecialValueFor( "radius" ), self:GetSpecialValueFor( "radius" ), 0) );
    ParticleManager:SetParticleControl( nFXIndex, 3, point);
    ParticleManager:ReleaseParticleIndex( nFXIndex );
    EmitSoundOn("Hero_Silencer.Curse.Impact", self:GetCaster()) 

    local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), caster, self:GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
    if #units > 0 then
        for _,unit in pairs(units) do
            local damage = {
                victim = unit,
                attacker = caster,
                damage = flDamagePerTick,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = flDamagePerTick
            }
            ApplyDamage( damage )

            unit:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_silenced", { duration = self:GetSpecialValueFor("tooltip_duration") } )
        end
    end
end