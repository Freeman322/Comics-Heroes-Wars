palpatine_wormhole = class({})

local hTagret;

LinkLuaModifier("modifier_palpatine_wormhole", "abilities/palpatine_wormhole.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_palpatine_wormhole_effect", "abilities/palpatine_wormhole.lua", LUA_MODIFIER_MOTION_NONE)

function palpatine_wormhole:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function palpatine_wormhole:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function palpatine_wormhole:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	if hTarget:IsCreep() and ( not self:GetCaster():HasScepter() ) then
		return "#dota_hud_error_cant_cast_on_creep"
	end

	return ""
end

function palpatine_wormhole:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end

function palpatine_wormhole:OnSpellStart()
    hTagret = self:GetCursorTarget()
    local caster = self:GetCaster()

    EmitSoundOn("Hero_Dark_Seer.Vacuum", caster)
    caster:AddNewModifier(caster, self, "modifier_palpatine_wormhole", {duration = self:GetSpecialValueFor("teleport_delay")})
end

modifier_palpatine_wormhole = class({})

function modifier_palpatine_wormhole:IsPurgable()
	return false
end

function modifier_palpatine_wormhole:IsHidden()
	return true
	-- body
end

function modifier_palpatine_wormhole:OnCreated(table)
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/hero_palpatine/palpatine_wormhole.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 1) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), 1) )
		ParticleManager:SetParticleControl( nFXIndex, 3, self:GetParent():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex );


		EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Cast", self:GetParent())
		EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Target", self:GetParent())
        self:StartIntervalThink(0.03)
        self.start_time = GameRules:GetGameTime()
	end
end

function modifier_palpatine_wormhole:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local target = self:GetParent()
        local target_location = target:GetAbsOrigin()
        local ability = self:GetAbility()
        local ability_level = ability:GetLevel()

        -- Ability variables
        local duration = 1
        local radius = 650
        local remaining_duration = duration - (GameRules:GetGameTime() - self.start_time)

        -- Targeting variables
        local target_teams = ability:GetAbilityTargetTeam()
        local target_types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
        local target_flags = ability:GetAbilityTargetFlags()

        local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

        -- Calculate the position of each found unit
        for _,unit in ipairs(units) do
            local unit_location = unit:GetAbsOrigin()
            local vector_distance = target_location - unit_location
            local distance = (vector_distance):Length2D()
            local direction = (vector_distance):Normalized()

            -- Apply the stun and no collision modifier then set the new location
            unit:AddNewModifier(unit, caster, "modifier_palpatine_wormhole_effect", {duration = 0.1})
            unit:SetAbsOrigin(unit_location + direction * (distance * 1/duration * 1/30))
        end
    end
end

function modifier_palpatine_wormhole:OnDestroy()
	if IsServer() then
        local vPoint = hTagret:GetAbsOrigin()
		local direction = (vPoint - self:GetParent():GetAbsOrigin()):Normalized()
		local nFXIndex2 = ParticleManager:CreateParticle( "particles/hero_medivh/dark_rift_end.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		ParticleManager:SetParticleControlEnt(nFXIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", vPoint, true)
		ParticleManager:SetParticleControl(nFXIndex2, 2, vPoint)
		ParticleManager:SetParticleControlOrientation(nFXIndex2, 2, direction, Vector(0,1,0), Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(nFXIndex2)

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/hero_medivh/dark_rift_end.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		ParticleManager:SetParticleControlEnt(nFXIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(nFXIndex2, 2,  self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(nFXIndex2, 2, direction, Vector(0,1,0), Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(nFXIndex2)


		local nearby_units = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		for _, units in pairs(nearby_units) do
			units:SetAbsOrigin(self:GetParent():GetAbsOrigin())
		end
        local caster = self:GetAbility():GetCaster()
        local ability = self:GetAbility()
        local damage = ability:GetSpecialValueFor( "enemy_damage" )/100
		Timers:CreateTimer(0.1, function()
			for _, units in pairs(nearby_units) do
				if not units:IsAncient() then 
					units:SetAbsOrigin(vPoint)
					FindClearSpaceForUnit(units, vPoint, false)
				end
				EmitSoundOn("Hero_ObsidianDestroyer.EssenceAura", units)
                if units:GetTeamNumber() ~= caster:GetTeamNumber() then
                    ApplyDamage({attacker = caster, victim = units, ability = ability, damage = (damage * units:GetMaxHealth()) + 300, damage_type = DAMAGE_TYPE_PURE})
                end
				ParticleManager:CreateParticle ("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_POINT_FOLLOW, units)
			end
			return nil
		end)
		EmitSoundOn( "Hero_AbyssalUnderlord.DarkRift.Complete", self:GetCaster() )
		GridNav:DestroyTreesAroundPoint(vPoint, 550, false)
	end
end

if modifier_palpatine_wormhole_effect == nil then modifier_palpatine_wormhole_effect = class({}) end

function modifier_palpatine_wormhole_effect:IsHidden()
	return true
	-- body
end

function modifier_palpatine_wormhole_effect:IsPurgable()
	return false
	-- body
end

function modifier_palpatine_wormhole_effect:GetEffectName()
	return "particles/units/heroes/hero_chaos_knight/chaos_knight_phantasm.vpcf"
	-- body
end

function modifier_palpatine_wormhole_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
	-- body
end
--------------------------------------------------------------------------------

function modifier_palpatine_wormhole_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_palpatine_wormhole_effect:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_palpatine_wormhole_effect:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function palpatine_wormhole:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

