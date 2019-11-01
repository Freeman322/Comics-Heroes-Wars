LinkLuaModifier ("manhattan_mind_trick_thinker",           "abilities/manhattan_mind_trick.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("manhattan_mind_trick_modifier",          "abilities/manhattan_mind_trick.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("manhattan_mind_trick_modifier_cooldown", "abilities/manhattan_mind_trick.lua", LUA_MODIFIER_MOTION_NONE)


manhattan_mind_trick = class ( {})

function manhattan_mind_trick:OnSpellStart ()
    if IsServer() then
        local point = self:GetCursorPosition ()
        local caster = self:GetCaster ()
        local team_id = caster:GetTeamNumber ()
        local duration = self:GetSpecialValueFor ("duration")
        local thinker = CreateModifierThinker (caster, self, "manhattan_mind_trick_thinker", { duration = duration }, point, team_id, false)
        self.cooldown = self:GetSpecialValueFor ("cooldown_bonus")
    end
end

function manhattan_mind_trick:GetAOERadius ()
    return self:GetSpecialValueFor ("radius")
end

manhattan_mind_trick_thinker = class ( {})

function manhattan_mind_trick_thinker:OnCreated (event)
    local thinker = self:GetParent ()
    local ability = self:GetAbility ()
    self.team_number = thinker:GetTeamNumber ()
    self.radius = ability:GetSpecialValueFor ("radius")
    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, self.radius, self.radius))
        ParticleManager:SetParticleControl( nFXIndex, 6, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl( nFXIndex, 10, self:GetParent():GetOrigin())
        self:AddParticle( nFXIndex, false, false, -1, false, true )
        EmitSoundOn("Manhattan_CooldownSphere.Start", thinker)

    end
end

function manhattan_mind_trick_thinker:IsAura ()
    return true
end

function manhattan_mind_trick_thinker:GetAuraRadius ()
    return self.radius
end

function manhattan_mind_trick_thinker:GetAuraSearchTeam ()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function manhattan_mind_trick_thinker:GetAuraSearchType ()
    return DOTA_UNIT_TARGET_HERO
end

function manhattan_mind_trick_thinker:GetAuraSearchFlags ()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function manhattan_mind_trick_thinker:GetModifierAura ()
    return "manhattan_mind_trick_modifier"
end


manhattan_mind_trick_modifier = class ( {})

function manhattan_mind_trick_modifier:IsBuff()
    if self:GetAbility().team_number == self:GetParent():GetTeamNumber() then
        return true
    else
        return false
    end

end

function manhattan_mind_trick_modifier:DeclareFunctions ()
    return { MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE }
end

function manhattan_mind_trick_modifier:OnCreated()
    if IsServer() then
        if self:GetAbility():GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
            for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
                local current_ability = self:GetParent():GetAbilityByIndex(i)
                if current_ability ~= nil then
                    local current_ability_cooldown = current_ability:GetCooldownTimeRemaining()
                    ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = current_ability_cooldown * 5, damage_type = DAMAGE_TYPE_MAGICAL})
                end
            end
        end
    end
end

function manhattan_mind_trick_modifier:GetModifierPercentageCooldown()
    if self:GetAbility():GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
        return self:GetAbility():GetSpecialValueFor("cooldown_bonus")
    else
        return 0
    end
end

function manhattan_mind_trick:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

