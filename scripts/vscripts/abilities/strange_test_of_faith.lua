strange_test_of_faith = class({})

LinkLuaModifier( "modifier_strange_test_of_faith", "abilities/strange_test_of_faith.lua", LUA_MODIFIER_MOTION_NONE )

function strange_test_of_faith:OnSpellStart()
    if IsServer() then 
    	local hTarget = self:GetCursorTarget()
    	if hTarget ~= nil then
            local duration = self:GetSpecialValueFor( "duration" )
            hTarget:AddNewModifier( self:GetCaster(), self, "modifier_strange_test_of_faith", { duration = duration } )
            hTarget:Purge( false, true, false, true, false )
            EmitSoundOn( "Hero_Abaddon.AphoticShield.Cast", hTarget )
    	end
    end
end

modifier_strange_test_of_faith = class({})

function modifier_strange_test_of_faith:IsPurgable()
    return false
end

function modifier_strange_test_of_faith:OnCreated( params )
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(150, 150, 1))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn ("Hero_Abaddon.AphoticShield.Cast", self:GetParent())

        self.damage_absorb = self:GetAbility():GetSpecialValueFor("damage_block")
    end
end

function modifier_strange_test_of_faith:OnDestroy( params )
    if IsServer() then
        EmitSoundOn( "Hero_Abaddon.AphoticShield.Destroy", hTarget )
	    ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

        local nearby_units = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, 425, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, unit in ipairs(nearby_units) do  --Restore health and play a particle effect for every found ally.
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
            ParticleManager:SetParticleControlEnt( nFXIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 4, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
            ParticleManager:ReleaseParticleIndex(nFXIndex)

            if unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then 
                EmitSoundOn("Hero_Oracle.FalsePromise.Healed", unit)
                unit:Heal(self:GetAbility():GetSpecialValueFor("heal_expier"), self:GetAbility())
            else
                EmitSoundOn("Hero_Abaddon.DeathCoil.Target", unit)
                 local damage = {
                    victim = unit,
                    attacker = self:GetParent(),
                    damage = self:GetAbility():GetSpecialValueFor("damage_expire"),
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self,
                }

                ApplyDamage( damage )

                unit:AddNewModifier (self:GetParent(), self, "modifier_stunned", { duration = 0.5 })
            end
        end
    end
end


function modifier_strange_test_of_faith:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end

function modifier_strange_test_of_faith:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local caster = params.unit
            local damage = params.damage

            if self.damage_absorb >= damage then
                self.damage_absorb = self.damage_absorb - damage
                caster:Heal( damage, caster )

                EmitSoundOn("Hero_Pugna.NetherWard.Target", self:GetParent())

                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect_energy.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
                ParticleManager:ReleaseParticleIndex(nFXIndex)

                caster:Purge( false, true, false, true, false )
            else
                self:Destroy()
            end
        end
    end
end
