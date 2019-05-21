LinkLuaModifier ("manhattan_elemental_fragmintation_modifier", "abilities/manhattan_elemental_fragmintation.lua", LUA_MODIFIER_MOTION_NONE)
manhattan_elemental_fragmintation = class ( {})

function manhattan_elemental_fragmintation:OnSpellStart ()
    local hTarget = self:GetCursorTarget ()
    local hCaster = self:GetCaster ()
    local duration = self:GetSpecialValueFor ("duration")
    local radius = self:GetSpecialValueFor ("radius")
    if hTarget ~= nil then
        if ( not hTarget:TriggerSpellAbsorb (self) ) then
            hTarget:AddNewModifier (self:GetCaster (), self, "manhattan_elemental_fragmintation_modifier", { duration = duration } )
        end
        EmitSoundOn ("Manhattan.Elemental_Fragmentation.Start", self:GetCaster () )
    end
    local nearby_allied_units = FindUnitsInRadius (hTarget:GetTeam (), hTarget:GetAbsOrigin (), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for i, nearby_ally in ipairs (nearby_allied_units) do  --Restore health and play a particle effect for every found ally.
        nearby_ally:AddNewModifier (self:GetCaster (), self, "modifier_stunned", { duration = duration } )
    end
end

function manhattan_elemental_fragmintation:GetAOERadius ()
    return self:GetSpecialValueFor ("radius")
end

manhattan_elemental_fragmintation_modifier = class ( {})

function manhattan_elemental_fragmintation_modifier:IsBuff ()
    return false
end

function manhattan_elemental_fragmintation_modifier:IsPurgable ()
    return false
end

function manhattan_elemental_fragmintation_modifier:OnCreated(event)
    local ability = self:GetAbility ()
    local target = self:GetParent ()
    if IsServer () then
        local nFXIndex = ParticleManager:CreateParticle( "particles/dr_manhattan/elemental_fragmentation_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, target:GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(0, 0, 0))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(600, 600, 600))
        ParticleManager:SetParticleControl( nFXIndex, 3, target:GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 5, target:GetOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
    end
end

function manhattan_elemental_fragmintation_modifier:OnDestroy(event)
    local ability = self:GetAbility ()
    local target = self:GetParent ()
    if IsServer() then
        local damage_percent = ability:GetSpecialValueFor ("damage_percent")/100
        local target_mana = target:GetMana()
        local target_health = target:GetHealth()
        local kill_bourder = ability:GetSpecialValueFor ("kill_bourder")
        local damage = target_mana * damage_percent
       
        EmitSoundOn ("Manhattan.Elemental_Fragmentation.Damage", target)
       
        local nFXIndex = ParticleManager:CreateParticle( "particles/dr_manhattan/elemental_fragmentation_damage.vpcf", PATTACH_CUSTOMORIGIN, nil );
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin() + Vector( 0, 0, 0 ), true );
        ParticleManager:SetParticleControl( nFXIndex, 1, ability:GetCaster():GetOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 2, ability:GetCaster():GetOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 3, ability:GetCaster():GetOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 4, ability:GetCaster():GetOrigin());
        ParticleManager:SetParticleControl( nFXIndex, 5, ability:GetCaster():GetOrigin());
        ParticleManager:ReleaseParticleIndex( nFXIndex );

        ApplyDamage ( { attacker = ability:GetCaster (), victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE })
      
        if target and not target:IsNull() then
            local units = FindUnitsInRadius (target:GetTeam (), target:GetAbsOrigin (), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

            for i = 1, #units do
                local targets = units[i]
                ApplyDamage ( { attacker = ability:GetCaster (), victim = targets, ability = ability, damage = damage/#units, damage_type = DAMAGE_TYPE_MAGICAL })
            end
        end
    end
end


function manhattan_elemental_fragmintation_modifier:CheckState ()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_FROZEN] = true,
    }

    return state
end

function manhattan_elemental_fragmintation:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

