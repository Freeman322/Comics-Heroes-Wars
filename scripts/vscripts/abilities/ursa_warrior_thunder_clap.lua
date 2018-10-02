ursa_warrior_thunder_clap = class ( {})
LinkLuaModifier ("modifier_ursa_warrior_thunder_clap", "abilities/ursa_warrior_thunder_clap.lua", LUA_MODIFIER_MOTION_NONE)

function ursa_warrior_thunder_clap:OnSpellStart ()
    if IsServer() then 
        local radius = self:GetSpecialValueFor( "radius" ) 
        local duration = self:GetSpecialValueFor(  "duration" )

        local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
        if #units > 0 then
            for _,unit in pairs(units) do
                unit:AddNewModifier( self:GetCaster(), self, "modifier_ursa_warrior_thunder_clap", { duration = duration } )
                unit:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 0.5 } )
			    ApplyDamage({attacker = self:GetCaster(), victim = unit, damage = self:GetAbilityDamage(), ability = self, damage_type = DAMAGE_TYPE_MAGICAL})	
            end
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_ursa/ursa_thunderclap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )

        EmitSoundOn( "n_creep_Ursa.Clap", self:GetCaster() )

        self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
    end
end

modifier_ursa_warrior_thunder_clap = class ( {})

function modifier_ursa_warrior_thunder_clap:IsHidden()
    return false
end

function modifier_ursa_warrior_thunder_clap:IsBuff()
    return false
end

function modifier_ursa_warrior_thunder_clap:IsPurgable()
    return false
end

function modifier_ursa_warrior_thunder_clap:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_ursa_warrior_thunder_clap:GetModifierMoveSpeedBonus_Percentage (params)
    local hAbility = self:GetAbility ()
    return hAbility:GetSpecialValueFor ("movespeed_slow")
end