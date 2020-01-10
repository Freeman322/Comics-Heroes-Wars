LinkLuaModifier( "jaina_overvoid_thinker", "abilities/jaina_overvoid.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "jaina_overvoid_modifier", "abilities/jaina_overvoid.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "jaina_overvoid_modifier_jump", "abilities/jaina_overvoid.lua", LUA_MODIFIER_MOTION_NONE )

jaina_overvoid = class ( {})

function jaina_overvoid:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local team_id = caster:GetTeamNumber()
    local thinker = CreateModifierThinker(caster, self, "jaina_overvoid_thinker", {duration = 4}, point, team_id, false)
end

------------------------------------------------------------------------------------------------------------------------------------------

jaina_overvoid_thinker = class ({})

function jaina_overvoid_thinker:OnCreated(event)
    if IsServer() then
        local thinker = self:GetParent()
        local ability = self:GetAbility()
        local target = self:GetAbility():GetCaster():GetCursorPosition()
        self.damage = ability:GetSpecialValueFor("damage")/100
        self.radius = ability:GetSpecialValueFor("radius")

        self:StartIntervalThink(0.1)

        local nFXIndex = ParticleManager:CreateParticle( "particles/hero_jaina/jaina_overvoid_effect.vpcf", PATTACH_CUSTOMORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex, 0, target + Vector(0, 0, 67))
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(500, 1, 1))
        ParticleManager:SetParticleControl( nFXIndex, 2, target + Vector(0, 0, 67))
        ParticleManager:SetParticleControl( nFXIndex, 3, target + Vector(0, 0, 67))
        ParticleManager:SetParticleControl( nFXIndex, 5, target + Vector(0, 0, 67))
        ParticleManager:SetParticleControl( nFXIndex, 6, target + Vector(0, 0, 67))
        ParticleManager:SetParticleControl( nFXIndex, 20, target + Vector(0, 0, 67))

        self:AddParticle( nFXIndex, false, false, -1, false, true )

        EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Cast", thinker)
        EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Target", thinker)
        EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Complete", thinker)
        EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Cancel", thinker)
        AddFOWViewer( thinker:GetTeam(), target, 1500, 5, false)
        GridNav:DestroyTreesAroundPoint(target, 1500, false)

        if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "rat") then EmitSoundOn("Rat.Cast", self:GetCaster()) end
    end
end

function jaina_overvoid_thinker:OnIntervalThink()
    local caster = self:GetAbility():GetCaster()
	local target = self:GetParent()
	local target_location = target:GetAbsOrigin()
	local ability = self:GetAbility()

	-- Takes note of the point entity, so we know what to remove the thinker from when the channel ends
	ability.point_entity = target

	-- Ability variables
	local speed = 4
	local radius = self.radius

	-- Targeting variables
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

	-- Units to be caught in the black hole
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, 0, 0, false)

	-- Calculate the position of each found unit in relation to the center
	for i,unit in ipairs(units) do
		local unit_location = unit:GetAbsOrigin()
		local vector_distance = target_location - unit_location
		local distance = (vector_distance):Length2D()
		local direction = (vector_distance):Normalized()
		-- If the target is greater than 40 units from the center, we move them 40 units towards it, otherwise we move them directly to the center
		if distance >= 80 then
			unit:SetAbsOrigin(unit_location + direction * speed)
		else
			unit:SetAbsOrigin(Vector(math.random(-4000, 4000), math.random(-4000, 4000), unit:GetAbsOrigin().z))
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Aftershock", unit)
			unit:AddNewModifier(unit, self:GetAbility(), "jaina_overvoid_modifier_jump", {duration = 0.4})
			EmitSoundOn("Hero_ObsidianDestroyer.EssenceAura", unit)
			ParticleManager:CreateParticle ("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_POINT_FOLLOW, unit)
			ApplyDamage({victim = unit, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = unit:GetMaxHealth()*(self:GetAbility():GetSpecialValueFor("hp_loss")/100), damage_type = DAMAGE_TYPE_PURE})
		end
	    ApplyDamage({victim = unit, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage")*0.3, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function jaina_overvoid_thinker:OnDestroy()
    if IsServer() then
	    local thinker =  self:GetParent()
	    EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Aftershock", thinker)
	end
end

function jaina_overvoid_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function jaina_overvoid_thinker:IsAura()
    return true
end

function jaina_overvoid_thinker:GetAuraRadius()
    return self.radius
end

function jaina_overvoid_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function jaina_overvoid_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function jaina_overvoid_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function jaina_overvoid_thinker:GetModifierAura()
    return "jaina_overvoid_modifier"
end

jaina_overvoid_modifier = class ( {})

function jaina_overvoid_modifier:IsDebuff ()
    return true
end

function jaina_overvoid_modifier:OnCreated (event)
    local ability = self:GetAbility ()
end

function jaina_overvoid_modifier:DeclareFunctions ()
    return { MODIFIER_PROPERTY_MISS_PERCENTAGE, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function jaina_overvoid_modifier:GetModifierMiss_Percentage()
    return 100
end

function jaina_overvoid_modifier:GetModifierMoveSpeedBonus_Percentage()
    return -50
end

function jaina_overvoid_modifier:GetEffectName()
    return "particles/items2_fx/radiance.vpcf"
end

function jaina_overvoid_modifier:GetEffectAttachType ()
    return PATTACH_ABSORIGIN_FOLLOW
end

if jaina_overvoid_modifier_jump == nil then jaina_overvoid_modifier_jump = class({}) end

function jaina_overvoid_modifier_jump:IsHidden()
	return true
	-- body
end

function jaina_overvoid_modifier_jump:GetEffectName()
	return "particles/units/heroes/hero_chaos_knight/chaos_knight_phantasm.vpcf"
	-- body
end

function jaina_overvoid_modifier_jump:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
	-- body
end

function jaina_overvoid:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

