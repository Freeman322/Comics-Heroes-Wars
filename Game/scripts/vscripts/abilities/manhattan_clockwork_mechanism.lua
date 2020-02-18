LinkLuaModifier( "modifier_manhattan_clockwork_mechanism", "abilities/manhattan_clockwork_mechanism.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_manhattan_clockwork_mechanism_tinker", "abilities/manhattan_clockwork_mechanism.lua", LUA_MODIFIER_MOTION_NONE )

manhattan_clockwork_mechanism = class({})

local CONST_MISS_CHANCE = 50

function manhattan_clockwork_mechanism:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local point = self:GetCursorPosition()
        local team_id = caster:GetTeamNumber()
        local duration = self:GetSpecialValueFor("duration")

        if self:GetCaster():HasTalent("special_bonus_unique_manhattan_1") then
            duration = duration + self:GetCaster():FindTalentValue("special_bonus_unique_manhattan_1")
        end

        local thinker = CreateModifierThinker(caster, self, "modifier_manhattan_clockwork_mechanism_tinker", {duration = self:GetSpecialValueFor("duration")}, point, team_id, false)
    end
end


modifier_manhattan_clockwork_mechanism_tinker = class ({})

function modifier_manhattan_clockwork_mechanism_tinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
 
        self.radius = ability:GetSpecialValueFor("radius")

        if self:GetCaster():HasTalent("special_bonus_unique_manhattan_2") then
            self.radius = self.radius + self:GetCaster():FindTalentValue("special_bonus_unique_manhattan_2")
        end

        local nFXIndex = ParticleManager:CreateParticle( "particles/manhattan/manhattan_dazzling.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, thinker:GetAbsOrigin() + Vector(0, 0, 156))
        ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 0, 0))
        self:AddParticle( nFXIndex, false, false, -1, false, true )

        AddFOWViewer( thinker:GetTeam(), thinker:GetAbsOrigin(), 1500, 5, false)

        EmitSoundOn("Hero_KeeperOfTheLight.Wisp.Active", thinker)

        GridNav:DestroyTreesAroundPoint(thinker:GetAbsOrigin(), 1500, false)
    end
end

function modifier_manhattan_clockwork_mechanism_tinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_manhattan_clockwork_mechanism_tinker:IsAura()
    return true
end

function modifier_manhattan_clockwork_mechanism_tinker:GetAuraRadius()
    return self.radius
end

function modifier_manhattan_clockwork_mechanism_tinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_manhattan_clockwork_mechanism_tinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_manhattan_clockwork_mechanism_tinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_manhattan_clockwork_mechanism_tinker:GetModifierAura()
    return "modifier_manhattan_clockwork_mechanism"
end

modifier_manhattan_clockwork_mechanism = class ( {})

function modifier_manhattan_clockwork_mechanism:IsDebuff () return true end
function modifier_manhattan_clockwork_mechanism:IsPurgable() return false end

function modifier_manhattan_clockwork_mechanism:OnCreated (event)
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()

        EmitSoundOn("Hero_KeeperOfTheLight.Wisp.Target", self:GetParent())

        for i = 0, 15, 1 do  
            local current_ability = self:GetParent():GetAbilityByIndex(i)
            
            if current_ability ~= nil then
                 current_ability:SetFrozenCooldown(true)
            end
        end
        for i = 0, 5, 1 do
            local current_item = self:GetParent():GetItemInSlot(i)
            
            if current_item ~= nil then
                 current_item:SetFrozenCooldown(true)
            end
       end
    end
end

function modifier_manhattan_clockwork_mechanism:OnIntervalThink()
    if IsServer() then
        ApplyDamage ( { attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self:GetAbility():GetAbilityDamage(), damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function modifier_manhattan_clockwork_mechanism:OnDestroy()
    if IsServer() then
        for i = 0, 15, 1 do  
            local current_ability = self:GetParent():GetAbilityByIndex(i)
            
            if current_ability ~= nil then
                 current_ability:SetFrozenCooldown(false)
            end
        end
        for i = 0, 5, 1 do
            local current_item = self:GetParent():GetItemInSlot(i)
            
            if current_item ~= nil then
                 current_item:SetFrozenCooldown(false)
            end
       end
    end
end

function modifier_manhattan_clockwork_mechanism:DeclareFunctions ()
    return { MODIFIER_PROPERTY_MISS_PERCENTAGE }
end

function modifier_manhattan_clockwork_mechanism:GetModifierMiss_Percentage()
    return CONST_MISS_CHANCE
end

function modifier_manhattan_clockwork_mechanism:GetEffectName()
    return "particles/econ/items/wisp/wisp_relocate_teleport_ti7_out.vpcf"
end

function modifier_manhattan_clockwork_mechanism:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true
    }

    return state
end

function modifier_manhattan_clockwork_mechanism:GetEffectAttachType ()
    return PATTACH_ABSORIGIN_FOLLOW
end
