if overvoid_void == nil then overvoid_void = class({}) end

LinkLuaModifier( "overvoid_void_modifier", "abilities/overvoid_void.lua", LUA_MODIFIER_MOTION_NONE )

function overvoid_void:GetChannelTime()
    return self:GetSpecialValueFor("void_duration")
end
function overvoid_void:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function overvoid_void:OnSpellStart()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "overvoid_void_modifier", { duration = self:GetChannelTime() } )
end

function overvoid_void:OnChannelFinish( bInterrupted )
    local caster = self:GetCaster()
    if caster:HasModifier("overvoid_void_modifier") then
        caster:RemoveModifierByName( "overvoid_void_modifier" )
    end
end

--------------------------------------------------------------------------------
overvoid_void_modifier = class({})

function overvoid_void_modifier:OnCreated(event)
    if IsServer() then
        local caster = self:GetParent()
        local ability = self:GetAbility()
        local caster_pos = caster:GetAbsOrigin()
        local soundName = "Hero_Disruptor.StaticStorm"
        StartSoundEvent( soundName, caster)
        EmitSoundOn("Hero_AbyssalUnderlord.PitOfMalice", caster)
        self:StartIntervalThink(0.1)

        local EntIndex = ParticleManager:CreateParticle("particles/hero_overvoid/overvoid_void.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(EntIndex, 0, caster_pos)
        ParticleManager:SetParticleControl(EntIndex, 1, Vector(450, 1, 1))
        ParticleManager:SetParticleControl(EntIndex, 2, caster_pos)
        ParticleManager:SetParticleControl(EntIndex, 3, caster_pos)
        ParticleManager:SetParticleControl(EntIndex, 5, caster_pos)
        self:AddParticle(EntIndex, false, false, -1, false, false)
    end
end

function overvoid_void_modifier:OnIntervalThink()
    local caster = self:GetParent()
    local ability = self:GetAbility()
    local caster_pos = caster:GetAbsOrigin()
    local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for i = 1, #targets do
        local target = targets[i]
        local damage = ability:GetAbilityDamage()/10
        ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

function overvoid_void_modifier:OnDestroy()
    StopSoundEvent("Hero_Disruptor.StaticStorm", self:GetCaster())
    EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Aftershock", self:GetCaster())
end

function overvoid_void_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}

	return funcs
end


function overvoid_void_modifier:GetModifierConstantHealthRegen( params )
  	local regen = self:GetCaster():GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("hp_regen")/100)
	return regen
end

function overvoid_void_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

function overvoid_void:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

