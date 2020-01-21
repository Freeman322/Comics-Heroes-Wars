LinkLuaModifier ("eternity_chronosphere_thinker", "abilities/eternity_chronosphere.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("eternity_chronosphere_modifier", "abilities/eternity_chronosphere.lua", LUA_MODIFIER_MOTION_NONE)

eternity_chronosphere = class ( {})

function eternity_chronosphere:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 60
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function eternity_chronosphere:OnSpellStart ()
    local point = self:GetCursorPosition ()
    local caster = self:GetCaster ()
    local team_id = caster:GetTeamNumber ()
    local duration = self:GetSpecialValueFor ("duration")
    if caster:HasScepter() then
        duration = self:GetSpecialValueFor ("duration_scepter")
    end
    local thinker = CreateModifierThinker (caster, self, "eternity_chronosphere_thinker", {duration = duration }, point, team_id, false)

    local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, self:GetSpecialValueFor ("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    for i = 1, #units do
        local vic = units[i]
        vic:AddNewModifier(caster, self, "modifier_truesight", {duration = duration})
    end
end

function eternity_chronosphere:GetAOERadius ()
    return self:GetSpecialValueFor ("radius")
end

eternity_chronosphere_thinker = class ( {})

function eternity_chronosphere_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local caster = ability:GetCaster()
        self.target = self:GetCaster():GetCursorPosition()
        self.duration = ability:GetSpecialValueFor ("duration")
        if caster:HasScepter() then
            self.duration = ability:GetSpecialValueFor ("duration_scepter")
        end
        local thinker_pos = thinker:GetAbsOrigin()

        EmitSoundOn("Hero_FacelessVoid.Chronosphere.MaceOfAeons", thinker)

        local bhParticle1 = ParticleManager:CreateParticle ("particles/eternity/chronosphere.vpcf", PATTACH_WORLDORIGIN, thinker)
        ParticleManager:SetParticleControl(bhParticle1, 0, thinker_pos)
        ParticleManager:SetParticleControl(bhParticle1, 1, Vector (self.radius, self.radius, 0))
        ParticleManager:SetParticleControl(bhParticle1, 3, thinker_pos)
        ParticleManager:SetParticleControl(bhParticle1, 4, thinker_pos)
        ParticleManager:SetParticleControl(bhParticle1, 6, thinker_pos)
        ParticleManager:SetParticleControl(bhParticle1, 10, thinker_pos)
        self:AddParticle( bhParticle1, false, false, -1, false, true )
    end
end

function eternity_chronosphere_thinker:IsAura ()
    return true
end

function eternity_chronosphere_thinker:GetAuraRadius ()
    return self.radius
end

function eternity_chronosphere_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function eternity_chronosphere_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_ALL
end

function eternity_chronosphere_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function eternity_chronosphere_thinker:GetModifierAura ()
    return "eternity_chronosphere_modifier"
end

eternity_chronosphere_modifier = class ( {})

function eternity_chronosphere_modifier:IsBuff ()
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return true
    end

    return false
end

function eternity_chronosphere_modifier:OnCreated( kv )
	if IsServer() then
		if self:GetAbility():GetCaster() ~= self:GetParent() then
            for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
                local current_ability = self:GetParent():GetAbilityByIndex(i)
                if current_ability ~= nil then
                    current_ability:SetFrozenCooldown( true )
                end
            end
        end
	end
end

function eternity_chronosphere_modifier:OnDestroy()
    if IsServer() then
        if self:GetAbility():GetCaster() ~= self:GetParent() then
            for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
                local current_ability = self:GetParent():GetAbilityByIndex(i)
                if current_ability ~= nil then
                    current_ability:SetFrozenCooldown( false )
                end
            end
        end
    end
end


function eternity_chronosphere_modifier:DeclareFunctions ()
    return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function eternity_chronosphere_modifier:GetModifierMoveSpeed_Absolute (params)
    if self:GetParent() == self:GetAbility():GetCaster() then
        return 1200
    end

    return 0
end

function eternity_chronosphere_modifier:GetModifierDamageOutgoing_Percentage (params)
    if self:GetParent() == self:GetAbility():GetCaster() and self:GetCaster():HasScepter() then
        return 100
    end

    return 0
end

function eternity_chronosphere_modifier:GetModifierAttackSpeedBonus_Constant (params)
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return 200
    end

    return 0
end


function eternity_chronosphere_modifier:CheckState()
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_INVULNERABLE] = true}
    end

    return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FROZEN] = true}
end

function eternity_chronosphere:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

