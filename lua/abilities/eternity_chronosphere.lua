LinkLuaModifier ("eternity_chronosphere_thinker", "abilities/eternity_chronosphere.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("eternity_chronosphere_modifier", "abilities/eternity_chronosphere.lua", LUA_MODIFIER_MOTION_NONE)

eternity_chronosphere = class ( {})
local cooldown = {}
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
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_COURIER + DOTA_UNIT_TARGET_HERO
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
    else
        return false
    end
end

function eternity_chronosphere_modifier:OnCreated( kv )
	if IsServer() then
		if self:GetAbility():GetCaster() ~= self:GetParent() then
            self.attackers_table = {}
            self.heal = 0
            self.damage = 0
            self.mana = self:GetParent():GetMana()
            for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
                local current_ability = self:GetParent():GetAbilityByIndex(i)
                if current_ability ~= nil then
                    cooldown[current_ability] = current_ability:GetCooldownTimeRemaining()
                end
            end
            self:StartIntervalThink(0.03)
        end
	end
end

function eternity_chronosphere_modifier:OnIntervalThink()
    if IsServer() then
        if self:GetAbility():GetCaster() ~= self:GetParent() then
            self:GetParent():SetMana(self.mana)
            for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
                local current_ability = self:GetParent():GetAbilityByIndex(i)
                if current_ability ~= nil then
                    current_ability:EndCooldown()
                    current_ability:StartCooldown(cooldown[current_ability])
                end
            end
        end
    end
end

function eternity_chronosphere_modifier:OnDestroy()
    if IsServer() then
        if self:GetAbility():GetCaster() ~= self:GetParent() then
            self:GetParent():Heal( self.heal, self:GetParent() )
            -- Heal this unit.
            for attacker,data in pairs(self.attackers_table) do
                ApplyDamage({attacker = attacker, victim = self:GetParent(), ability = self:GetAbility(), damage = data.damage, damage_type = DAMAGE_TYPE_PURE })
            end
        end
    end
end

function eternity_chronosphere_modifier:OnTakeDamage( params )
    if self:GetParent () == params.unit then
        if self:GetAbility():GetCaster() ~= self:GetParent() then
            local parent = params.unit
            local attacker = params.attacker
            local damage = params.damage
            local damage_type = params.damage_type
            if  self.attackers_table[attacker] == nil then
                self.attackers_table[attacker] = {}
            end
            if self.attackers_table[attacker].damage == nil then
                self.attackers_table[attacker].damage = 0
            end

            self.attackers_table[attacker].damage = self.attackers_table[attacker].damage + damage
            self.attackers_table[attacker].damage_type = damage_type

            self:GetParent():SetHealth( self:GetParent():GetHealth() + damage )

            for i=0, 5, 1 do
                local current_item = self:GetParent():GetItemInSlot(i)
                if current_item ~= nil then
                    if current_item:GetName() == "item_heart" or  current_item:GetName() == "item_heart_2" then
                        current_item:EndCooldown()
                    end
                end
            end
            self.damage = self.damage + damage
        end
    end
end

function eternity_chronosphere_modifier:OnHealReceived( params )
    if self:GetParent () == params.unit then
        if self:GetAbility():GetCaster() ~= self:GetParent() then
            self.heal = self.heal + params.gain
            self:GetParent ():SetHealth ( self:GetParent():GetHealth() - params.gain )
        end
    end
end

function eternity_chronosphere_modifier:DeclareFunctions ()
    return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_EVENT_ON_HEAL_RECEIVED, MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function eternity_chronosphere_modifier:GetModifierMoveSpeedBonus_Constant (params)
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return 1200
    else
        return 0
    end
end

function eternity_chronosphere_modifier:GetModifierAttackSpeedBonus_Constant (params)
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return 200
    else
        return 0
    end
end


function eternity_chronosphere_modifier:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FROZEN] = true}
    local state2 = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_INVULNERABLE] = true}
    if self:GetParent() == self:GetAbility():GetCaster() then
	    return state2
    else
        return state
    end
end

function eternity_chronosphere:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

