black_adam_storm_field = class({})
LinkLuaModifier( "black_adam_storm_field_modifier", "abilities/black_adam_storm_field.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function black_adam_storm_field:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then
        return 90
    end

    return self.BaseClass.GetCooldown( self, nLevel )
end

function black_adam_storm_field:GetChannelTime()
    return 6
end
function black_adam_storm_field:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end
--------------------------------------------------------------------------------

function black_adam_storm_field:OnSpellStart()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "black_adam_storm_field_modifier", { duration = self.channel_time } )
end


--------------------------------------------------------------------------------

function black_adam_storm_field:OnChannelFinish( bInterrupted )
    local caster = self:GetCaster()
    if caster:HasModifier("black_adam_storm_field_modifier") then
        caster:RemoveModifierByName( "black_adam_storm_field_modifier" )
    end
end

--------------------------------------------------------------------------------
black_adam_storm_field_modifier = class({})

function black_adam_storm_field_modifier:OnCreated(event)
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        local caster_pos = caster:GetAbsOrigin()
        local soundName = "Hero_Disruptor.StaticStorm"
        StartSoundEvent( soundName, caster)
        self:StartIntervalThink(0.1)
        local channel_time = 6
        local storm = ParticleManager:CreateParticle("particles/adam_static_storm.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(storm, 0, caster_pos)
        ParticleManager:SetParticleControl(storm, 1, Vector(600, 600, 0))
        ParticleManager:SetParticleControl(storm, 2, Vector(6, 6, 0))
        self:AddParticle(storm, false, false, -1, false, false)
    end
end

function black_adam_storm_field_modifier:OnIntervalThink()
    local caster = self:GetParent()
    local ability = self:GetAbility()
    local caster_pos = caster:GetAbsOrigin()
    if not caster:HasScepter() then
        local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for i = 1, #targets do
            local target = targets[i]
            local damage = self:GetAbility():GetAbilityDamage()
            if self:GetCaster():HasTalent("special_bonus_unique_black_adam") then
                damage = self:GetCaster():FindTalentValue("special_bonus_unique_black_adam") + damage
            end
            ApplyDamage({victim = target, attacker = caster, damage = damage/10, damage_type = DAMAGE_TYPE_MAGICAL})
        end
    else
        local bonus = 0
        if self:GetParent():HasModifier("black_adam_aftershock_passive") then
            bonus = self:GetParent():FindModifierByName("black_adam_aftershock_passive"):GetStackCount()
        end
        local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for i = 1, #targets do
            local target = targets[i]
            local damage = (self:GetAbility():GetAbilityDamage() + (target:GetMaxHealth()*ability:GetSpecialValueFor("damage_scepter")/100)+bonus)/10
            if self:GetCaster():HasTalent("special_bonus_unique_black_adam") then
                damage = self:GetCaster():FindTalentValue("special_bonus_unique_black_adam") + damage
            end
            ApplyDamage({victim = target, attacker = caster, damage = damage/10, damage_type = DAMAGE_TYPE_MAGICAL})
        end
    end
end

function black_adam_storm_field_modifier:OnDestroy()
    StopSoundEvent("Hero_Disruptor.StaticStorm", self:GetCaster())
end

function black_adam_storm_field_modifier:CheckState()
    if self.duration then
        return {[MODIFIER_STATE_PROVIDES_VISION] = true}
    end
    return nil
end

function black_adam_storm_field:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

