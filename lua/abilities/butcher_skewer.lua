if butcher_skewer == nil then butcher_skewer = class({}) end

LinkLuaModifier( "modifier_butcher_skewer_caster", "abilities/butcher_skewer.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_butcher_skewer_trg", "abilities/butcher_skewer.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function butcher_skewer:GetAOERadius()
	return self:GetSpecialValueFor( "skewer_radius" )
end

--------------------------------------------------------------------------------

function butcher_skewer:OnSpellStart()
	local caster = self:GetCaster()

    EmitSoundOn("Hero_Magnataur.Skewer.Cast", caster)
    caster:AddNewModifier(caster, self, "modifier_butcher_skewer_caster", nil)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if modifier_butcher_skewer_caster == nil then modifier_butcher_skewer_caster = class({}) end

function modifier_butcher_skewer_caster:IsDebuff ()
    return false
end

function modifier_butcher_skewer_caster:IsHidden()
    return true
end

function modifier_butcher_skewer_caster:IsPurgable()
    return false
end

function modifier_butcher_skewer_caster:RemoveOnDeath ()
    return false
end


function modifier_butcher_skewer_caster:OnCreated ()
    if IsServer() then
        local caster = self:GetCaster ()
        ProjectileManager:ProjectileDodge (caster)
        self.target = caster:GetCursorPosition()
        -- Ability variables
        self.leap_direction = (self.target - caster:GetAbsOrigin()):Normalized()
        self.leap_distance = (self.target - caster:GetAbsOrigin()):Length2D()
        self.leap_speed = 1600/30
        self.leap_traveled = 0
        self.leap_z = 0


        local caster = self:GetCaster()
        local skewer_speed = self.leap_speed
        local range = self:GetAbility():GetSpecialValueFor("skewer_range")
        local point = self.target

        -- Distance and direction variables
        local vector_distance = point - caster:GetAbsOrigin()
        local distance = (vector_distance):Length2D()
        local direction = (vector_distance):Normalized()

        -- If the caster targets over the max range, sets the distance to the max
        if distance > range then
            point = caster:GetAbsOrigin() + range * direction
            distance = range
        end

        -- Total distance to travel
        self.distance = distance

        -- The direction to travel
        self.direction = direction

        self:StartIntervalThink(0.03)
    end
end

function modifier_butcher_skewer_caster:OnIntervalThink()
    local caster = self:GetParent()
	local ability = self:GetAbility()

    if self.leap_traveled < self.leap_distance then
        caster:SetAbsOrigin (caster:GetAbsOrigin () + self.leap_direction * self.leap_speed)
        self.leap_traveled = self.leap_traveled + self.leap_speed
    else
        self:OnMotionInterrupted()
    end
    GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 175, true)

	local skewer_radius = ability:GetSpecialValueFor("skewer_radius")
	local hero_offset = 200

	-- Units to be caught in the skewer
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, skewer_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	-- Loops through target
	for i,unit in ipairs(units) do
		-- Checks if the target is already affected by skewer
        -- If not, move it offset in front of the caster
        if unit ~= self:GetParent() then
            local new_position = caster:GetAbsOrigin() + hero_offset * self.direction
            unit:SetAbsOrigin(new_position)
            -- Apply the motion controller to the target
            unit:AddNewModifier(caster, ability, "modifier_butcher_skewer_trg", {duration = 0.3})
        end
	end
end

function modifier_butcher_skewer_caster:DeclareFunctions ()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end


function modifier_butcher_skewer_caster:GetOverrideAnimation (params)
    return ACT_DOTA_CAST_ABILITY_4
end


function modifier_butcher_skewer_caster:CheckState ()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end


function modifier_butcher_skewer_caster:OnMotionInterrupted ()
    if IsServer () then
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
        local nearby_units = FindUnitsInRadius (self:GetCaster():GetTeam (), self:GetCaster():GetAbsOrigin (), nil, 375,  DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for i, taget in ipairs (nearby_units) do  --Restore health and play a particle effect for every found ally.
            local damage = self:GetAbility ():GetAbilityDamage ()
            FindClearSpaceForUnit(taget, taget:GetAbsOrigin(), false)
            taget:AddNewModifier (self:GetCaster (), self:GetAbility (), "modifier_stunned", { duration = 1 })
            if taget:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
                ApplyDamage ( { attacker = self:GetAbility ():GetCaster (), victim = taget, ability = self:GetAbility (), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
            end
        end
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
        --ParticleManager:SetParticleControl( nFXIndex, 1, Vector( hAbility:GetSpecialValueFor( "aftershock_range" ), 1, 1 ) )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 275, 1, 1 ) )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_EarthShaker.Totem", self:GetCaster() )
        self:Destroy ()
    end
end


if modifier_butcher_skewer_trg == nil then modifier_butcher_skewer_trg = class({}) end

--------------------------------------------------------------------------------

function modifier_butcher_skewer_trg:IsDebuff()
	return true
end

function modifier_butcher_skewer_trg:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_butcher_skewer_trg:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_butcher_skewer_trg:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_butcher_skewer_trg:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_butcher_skewer_trg:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_butcher_skewer_trg:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_butcher_skewer_trg:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function butcher_skewer:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

