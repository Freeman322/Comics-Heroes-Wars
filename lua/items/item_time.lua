LinkLuaModifier( "item_time_gem", "items/item_time.lua", LUA_MODIFIER_MOTION_NONE )

if item_time == nil then item_time = class({}) end

function item_time:GetIntrinsicModifierName()
	return "item_time_gem"
end

function item_time:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

if item_time_gem == nil then
    item_time_gem = class({})
end

function item_time_gem:GetAttributes ()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_time_gem:IsHidden()
    return true --we want item's passive abilities to be hidden most of the times
end

function item_time_gem:DeclareFunctions() --we want to use these functions in this item
local funcs = {
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_DEATH
}

return funcs
end

function item_time_gem:GetModifierBonusStats_Strength( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_time_gem:GetModifierBonusStats_Intellect( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end
function item_time_gem:GetModifierBonusStats_Agility( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_all_stats" )
end

function item_time_gem:GetModifierConstantHealthRegen( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_attack_speed" )
end

function item_time_gem:GetModifierPreAttack_BonusDamage( params )
    local hAbility = self:GetAbility()
    return hAbility:GetSpecialValueFor( "bonus_damage" )
end

function item_time_gem:OnTime(hAttacker, hVictim)
    if IsServer() then
        if self:GetCaster() == nil then
            return false
        end

        if self:GetCaster():PassivesDisabled() then
            return false
        end

        if self:GetCaster() ~= self:GetParent() then
            return false
        end

        if self:GetAbility():IsCooldownReady() == false then 
            return false
        end

        if self:GetAbility():IsOwnersManaEnough() == false then 
            return false
        end

        if hVictim ~= nil and hAttacker ~= nil and hVictim == self:GetCaster() and hAttacker:GetTeamNumber() ~= hVictim:GetTeamNumber() then
            self:GetParent():SetAbsOrigin( self.tStates[0].pos )
            self:GetParent():SetHealth( self.tStates[0].health )
            self:GetParent():SetMana( self.tStates[0].mana )

            local nFXIndex = ParticleManager:CreateParticle( "particles/effects/time_lapse_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 2, Vector(1, 1, 1))
            ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 4, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 5, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 6, self:GetParent():GetOrigin())
            ParticleManager:SetParticleControl( nFXIndex, 10,self:GetParent():GetOrigin())
            ParticleManager:ReleaseParticleIndex( nFXIndex )

            EmitSoundOn( "Hero_Weaver.TimeLapse", self:GetParent() )

            self:GetAbility():PayManaCost()
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))

            return true
        end
    end

    return false
end

function item_time_gem:OnIntervalThink()
    if IsServer() then 
       for i = 0, #self.tStates do
            if self.tStates[i + 1] then
                self.tStates[i] = self.tStates[i + 1]
            end
        end

        local need_time = #self.tStates + 1

        if need_time > 5 then need_time = 5 end

        self.tStates[need_time]           = {}
        self.tStates[need_time].pos       = self:GetParent():GetAbsOrigin()
        self.tStates[need_time].health    = self:GetParent():GetHealth()
        self.tStates[need_time].mana      = self:GetParent():GetMana()

        for k,v in pairs(self.tStates) do
            print(k,v)
        end

        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_weaver_timelapse", {duration = 1})
    end
end

function item_time_gem:OnCreated(params)
    if IsServer() then 
        self.tStates              = self.tStates            or {}
        self.tStates[0]           = self.tStates[0]         or {}
        self.tStates[0].pos       = self.tStates[0].pos     or self:GetParent():GetAbsOrigin()
        self.tStates[0].health    = self.tStates[0].health  or self:GetParent():GetHealth()
        self.tStates[0].mana      = self.tStates[0].mana    or self:GetParent():GetMana()

        self:StartIntervalThink(1)
    end
end