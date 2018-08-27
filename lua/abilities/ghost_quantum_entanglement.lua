ghost_quantum_entanglement = class({})
LinkLuaModifier( "modifier_ghost_quantum_entanglement", "abilities/ghost_quantum_entanglement.lua", LUA_MODIFIER_MOTION_NONE )

function ghost_quantum_entanglement:CastFilterResultTarget( hTarget )
    if IsServer() then

        if hTarget ~= nil and hTarget:IsMagicImmune() then
            return UF_FAIL_MAGIC_IMMUNE_ENEMY
        end

        local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
        return nResult
    end

    return UF_SUCCESS
end

function ghost_quantum_entanglement:GetCastRange( vLocation, hTarget )
    return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end

function ghost_quantum_entanglement:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function ghost_quantum_entanglement:GetAOERadius()
    return self:GetSpecialValueFor("chain_radius")
end

function ghost_quantum_entanglement:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function ghost_quantum_entanglement:OnSpellStart()
    if IsServer() then 
        local target = self:GetCursorTarget()
        local iMaxUnits = self:GetSpecialValueFor("chain_max_targets")
        local iCounter = 0
        if target ~= nil then 
            local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, self:GetSpecialValueFor("chain_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
            if #units > 0 then
                for i = 1, #units do
                    local unit = units[i]
                    local nextUnit = units[i + 1] or unit

                    if iCounter > iMaxUnits then break end 

                    EmitSoundOn("Ghost.Quantum_entanglement.Target", unit)

                    unit:AddNewModifier(self:GetCaster(), self, "modifier_ghost_quantum_entanglement", {duration = self:GetSpecialValueFor("chain_duration"), next_target = nextUnit:entindex()})

                    iCounter = iCounter + 1
                end
            end
        end  
    end 
end

modifier_ghost_quantum_entanglement = class ( {})

function modifier_ghost_quantum_entanglement:IsPurgable()
    return false
end

function modifier_ghost_quantum_entanglement:OnCreated(htable)
    if IsServer() then
        if htable.next_target then 
            local target = EntIndexToHScript(htable.next_target)

            if IsValidEntity(target) then 
                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() );
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true );
                ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
                
                self:AddParticle(nFXIndex, false, false, -1, false, false)
            end 
        end
    end
end


function modifier_ghost_quantum_entanglement:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_ghost_quantum_entanglement:ApplyDamage(attacker, damage, damage_type)
    if IsServer() then
        ApplyDamage ( {
            victim = self:GetParent(),
            attacker = attacker,
            damage = damage,
            damage_type = damage_type,
            ability = self:GetAbility(),
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS,
        })  
    end 
end

function modifier_ghost_quantum_entanglement:OnTakeDamage( params )
    if IsServer() then
        if params.unit == self:GetParent() then
            local target = params.attacker

            local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
            for _, unit in pairs(units) do
                if unit and unit:HasModifier("modifier_ghost_quantum_entanglement") then 
                    local mod = unit:FindModifierByName("modifier_ghost_quantum_entanglement") 
                    if mod then mod:ApplyDamage(target, params.damage * (self:GetAbility():GetSpecialValueFor("chain_damage_splash") / 100), params.damage_type) end 
                end 
            end
        end
    end
end

function modifier_ghost_quantum_entanglement:GetModifierMoveSpeedBonus_Percentage( params )
    return self:GetAbility():GetSpecialValueFor("movement_slow") * (-1)
end
