LinkLuaModifier( "modifier_death_eater_deathraze", "abilities/death_eater_deathraze.lua", LUA_MODIFIER_MOTION_NONE)

death_eater_deathraze = {}

--------------------------------------------------------------------------------
---Default classes declaration
--------------------------------------------------------------------------------
death_eater_deathraze1 = class({})
death_eater_deathraze2 = class({})
death_eater_deathraze3 = class({})


function death_eater_deathraze1:OnUpgrade()
	local abil1 = self:GetCaster():FindAbilityByName("death_eater_deathraze2")
	local abil2 = self:GetCaster():FindAbilityByName("death_eater_deathraze3")

	if abil1:GetLevel() ~= self:GetLevel() then abil1:SetLevel(self:GetLevel()) end 
	if abil2:GetLevel() ~= self:GetLevel() then abil2:SetLevel(self:GetLevel()) end 
end

function death_eater_deathraze2:OnUpgrade()
	local abil1 = self:GetCaster():FindAbilityByName("death_eater_deathraze1")
	local abil2 = self:GetCaster():FindAbilityByName("death_eater_deathraze3")

	if abil1:GetLevel() ~= self:GetLevel() then abil1:SetLevel(self:GetLevel()) end 
	if abil2:GetLevel() ~= self:GetLevel() then abil2:SetLevel(self:GetLevel()) end 
end

function death_eater_deathraze3:OnUpgrade()
	local abil1 = self:GetCaster():FindAbilityByName("death_eater_deathraze1")
	local abil2 = self:GetCaster():FindAbilityByName("death_eater_deathraze2")

	if abil1:GetLevel() ~= self:GetLevel() then abil1:SetLevel(self:GetLevel()) end 
	if abil2:GetLevel() ~= self:GetLevel() then abil2:SetLevel(self:GetLevel()) end 
end

local function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

function death_eater_deathraze1:OnSpellStart()
	death_eater_deathraze.OnSpellStart( self )
end
function death_eater_deathraze2:OnSpellStart()
	death_eater_deathraze.OnSpellStart( self )
end
function death_eater_deathraze3:OnSpellStart()
	death_eater_deathraze.OnSpellStart( self )
end
--------------------------------------------------------------------------------


----Custom class declaration
function death_eater_deathraze.OnSpellStart( this )
	-- get references
	local distance = this:GetSpecialValueFor("shadowraze_range")
	local front = this:GetCaster():GetForwardVector():Normalized()
	local target_pos = this:GetCaster():GetOrigin() + front * distance
	local target_radius = this:GetSpecialValueFor("shadowraze_radius")
	local base_damage = this:GetSpecialValueFor("shadowraze_damage")
	local stack_damage = this:GetSpecialValueFor("stack_bonus_damage")
	local stack_duration = this:GetSpecialValueFor("duration")


    if this:GetCaster():HasTalent("special_bonus_unique_death_eater") then
        base_damage = base_damage + this:GetCaster():FindTalentValue("special_bonus_unique_death_eater")
    end 

	-- get affected enemies
	local enemies = FindUnitsInRadius(
		this:GetCaster():GetTeamNumber(),
		target_pos,
		nil,
		target_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- for each affected enemies
	for _,enemy in pairs(enemies) do
		-- Get Stack
		local modifier = enemy:FindModifierByNameAndCaster("modifier_death_eater_deathraze", this:GetCaster())
		local stack = 0
		if modifier~=nil then
			stack = modifier:GetStackCount()
		end

		enemy:AddNewModifier(this:GetCaster(), this, "modifier_stunned", {duration = 0.1})

		-- Apply damage
		local damageTable = {
			victim = enemy,
			attacker = this:GetCaster(),
			damage = base_damage + stack*stack_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = this,
		}
		ApplyDamage( damageTable )

		-- Add stack
		if modifier==nil then
			enemy:AddNewModifier(
				this:GetCaster(),
				this,
				"modifier_death_eater_deathraze",
				{duration = stack_duration}
			)
		else
			modifier:IncrementStackCount()
			modifier:ForceRefresh()
		end
	end

	-- Effects
	death_eater_deathraze.PlayEffects( this, target_pos, target_radius )
end

function death_eater_deathraze.PlayEffects( this, position, radius )
	-- get resources
	local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local sound_cast = "Hero_Nevermore.Shadowraze"

	-- create particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, position )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
	-- create sound
	EmitSoundOnLocationWithCaster( position, sound_cast, this:GetCaster() )
end

modifier_death_eater_deathraze = class({})

--------------------------------------------------------------------------------

function modifier_death_eater_deathraze:IsHidden()
	return false
end

function modifier_death_eater_deathraze:IsDebuff()
	return true
end

function modifier_death_eater_deathraze:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_death_eater_deathraze:OnCreated( kv )
	self:SetStackCount(1)
end

function modifier_death_eater_deathraze:OnRefresh( kv )

end

--------------------------------------------------------------------------------

function modifier_death_eater_deathraze:GetEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_shadowraze_debuff.vpcf"
end

function modifier_death_eater_deathraze:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
--------------------------------------------------------------------------------