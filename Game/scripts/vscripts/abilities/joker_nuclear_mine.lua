LinkLuaModifier( "modifier_joker_nuclear_mine", "abilities/joker_nuclear_mine.lua", LUA_MODIFIER_MOTION_NONE )

joker_nuclear_mine = class({})

function joker_nuclear_mine:OnInventoryContentsChanged()
    self:SetHidden(not self:GetCaster():HasScepter())
    self:SetLevel(1)
end


function joker_nuclear_mine:OnSpellStart()
	local caster = self:GetCaster()
	local loc = caster:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	if IsServer() then
		--local nuclear_mine = CreateUnitByName( "npc_dota_joker_nuclear_mine", loc, false, nil, nil, caster:GetTeamNumber())
		--nuclear_mine:FindAbilityByName("joker_nuclear_mine"):SetLevel(1)
		local land_mine = CreateUnitByName("npc_dota_joker_nuclear_mine", loc, false, nil, nil, caster:GetTeamNumber())
		land_mine:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
		land_mine:AddNewModifier(caster, self, "modifier_joker_nuclear_mine", nil)
		land_mine:AddNewModifier(caster, self, "modifier_invisible", nil)
	end
end


modifier_joker_nuclear_mine = class({})

function modifier_joker_nuclear_mine:IsHidden()
	return false
end

function modifier_joker_nuclear_mine:OnCreated()
	if IsServer() then
		self.damage = self:GetAbility():GetSpecialValueFor("damage")/100

		self:StartIntervalThink(0.1)
	end
end

function modifier_joker_nuclear_mine:OnIntervalThink()
	if IsServer() then
		local caster = self:GetParent()
		local target_location = caster:GetAbsOrigin()
		local ability = self:GetAbility()

		-- Ability variables
		local speed = 8
		local radius = ability:GetSpecialValueFor("radius")

		-- Targeting variables
		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
		local target_types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
		local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

		-- Units to be caught in the black hole
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)

		-- Calculate the position of each found unit in relation to the center
		for i,unit in ipairs(units) do
			local unit_location = unit:GetAbsOrigin()
			local vector_distance = target_location - unit_location
			local distance = (vector_distance):Length2D()
			local direction = (vector_distance):Normalized()
			-- If the target is greater than 40 units from the center, we move them 40 units towards it, otherwise we move them directly to the center
			if distance >= 40 then
				unit:SetAbsOrigin(unit_location + direction * speed)
			else
				unit:SetAbsOrigin(unit_location + direction * distance)
			end
			if distance < 180 then
				self:StartParcticles(unit, ability, self:GetCaster())
				self:GetParent():Destroy()
			end
		end
	end
end

function modifier_joker_nuclear_mine:StartParcticles(unit, ability, caster)
	EmitSoundOn( "Hero_EarthShaker.EchoSlam", unit )
	EmitSoundOn( "Hero_EarthShaker.EchoSlamEcho", unit )
	EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", unit )
	EmitSoundOn( "PudgeWarsClassic.echo_slam", unit )
	local explosion1 = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_call_down_explosion_impact_a.vpcf", PATTACH_WORLDORIGIN, unit)
	ParticleManager:SetParticleControl(explosion1, 0, unit:GetAbsOrigin() + Vector(0, 0, 1))
	ParticleManager:SetParticleControl(explosion1, 1, unit:GetAbsOrigin() + Vector(0, 0, 1))
	ParticleManager:SetParticleControl(explosion1, 2, unit:GetAbsOrigin() + Vector(0, 0, 1))
	ParticleManager:SetParticleControl(explosion1, 3, Vector(300, 300, 1))
	local explosion2 = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion.vpcf", PATTACH_WORLDORIGIN, unit)
	ParticleManager:SetParticleControl(explosion2, 0, unit:GetAbsOrigin() + Vector(0, 0, 1))
	ParticleManager:SetParticleControl(explosion2, 3, unit:GetAbsOrigin() + Vector(0, 0, 1))
	ParticleManager:SetParticleControl(explosion2, 5, Vector(600, 600, 1))
	GridNav:DestroyTreesAroundPoint( unit:GetAbsOrigin(), 600, false)
	local radius = 700
		-- Targeting variables
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local units = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, radius, target_teams, target_types, 0, 0, false)
	for i,unit in ipairs(units) do
		local damage_table = {attacker = caster, victim = unit, ability = ability, damage = unit:GetMaxHealth()*self.damage, damage_type = DAMAGE_TYPE_MAGICAL}
		
		unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = 1})
		FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

		ApplyDamage(damage_table)
	end
end