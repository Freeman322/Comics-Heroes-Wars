death_eater_deaths_requiem = class({})
LinkLuaModifier( "modifier_death_eater_deaths_requiem", "abilities/death_eater_deaths_requiem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_death_eater_deaths_requiem_scepter", "abilities/death_eater_deaths_requiem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_death_eater_deaths_requiem_pull", "abilities/death_eater_deaths_requiem", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_death_eater_deaths_requiem_pull_debuff", "abilities/death_eater_deaths_requiem", LUA_MODIFIER_MOTION_NONE )

death_eater_deaths_requiem.m_hPullModifier = nil

local MAX_SLOPH_DISTANCE = 128.0
local FALL_SPEED = 60
--------------------------------------------------------------------------------
-- Ability Phase Start
function death_eater_deaths_requiem:OnAbilityPhaseStart()
    local particle_precast = "particles/units/heroes/hero_nevermore/nevermore_wings.vpcf"
	local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"

	-- Create Particles
	self.effect_precast = ParticleManager:CreateParticle( "particle_precast", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )	

	-- Play Sounds
	EmitSoundOn(sound_precast, self:GetCaster())
    
    if m_hPullModifier and not m_hPullModifier:IsNull() then m_hPullModifier:Destroy() end 

    m_hPullModifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_death_eater_deaths_requiem_pull", {duration = self:GetCastPoint()})
    
    return true 
end

function death_eater_deaths_requiem:OnAbilityPhaseInterrupted()
	-- Get Resources
	local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"

	-- Destroy Particles
	ParticleManager:DestroyParticle( self.effect_precast, true )
    	StopSoundOn(sound_precast, self:GetCaster())

	ParticleManager:ReleaseParticleIndex( self.effect_precast )
end

--------------------------------------------------------------------------------
-- Ability Start
function death_eater_deaths_requiem:OnSpellStart()
	-- get references
	local soul_per_line = self:GetSpecialValueFor("requiem_soul_conversion")

	local effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )	
	ParticleManager:SetParticleControl( effect, 0, self:GetCaster():GetAbsOrigin() )	
	ParticleManager:ReleaseParticleIndex( effect )

	-- get number of souls
	local lines = 0
	local modifier = self:GetCaster():FindModifierByNameAndCaster( "modifier_death_eater_necromastery", self:GetCaster() )
	if modifier~=nil then
		lines = math.floor(modifier:GetStackCount() / soul_per_line) 
	end

	-- explode
	self:Explode( lines )

	-- if has scepter, add modifier to implode
	if self:GetCaster():HasScepter() then
		local explodeDuration = self:GetSpecialValueFor("requiem_radius") / self:GetSpecialValueFor("requiem_line_speed")
		self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_death_eater_deaths_requiem_scepter",
			{
				lineDuration = explodeDuration,
				lineNumber = lines,
			}
		)
	end
end

--------------------------------------------------------------------------------
-- Projectile Hit
function death_eater_deaths_requiem:OnProjectileHit_ExtraData( hTarget, vLocation, params )
	if hTarget ~= nil then
		-- filter
		pass = false
		if hTarget:GetTeamNumber()~=self:GetCaster():GetTeamNumber() then
			pass = true
		end

		if pass then
			-- check if it is from explode or implode
			if params and params.scepter then

				-- reduce the damage
				damage = self.damage * (self.damage_pct/100)

				-- add to heal calculation
				if hTarget:IsHero() then
					local modifier = self:RetATValue( params.modifier )
					modifier:AddTotalHeal( damage )
				end
			end

			-- damage target
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damage )

			-- apply modifier
			hTarget:AddNewModifier(
				self:GetCaster(),
				self,
				"modifier_death_eater_deaths_requiem",
				{ duration = self.duration }
			)
		end
	end

	return false
end

--------------------------------------------------------------------------------
-- Triggers
function death_eater_deaths_requiem:OnOwnerDied()
	-- do nothing if not learned
	if self:GetLevel()<1 then return end

	-- get references
	local soul_per_line = self:GetSpecialValueFor("requiem_soul_conversion")

	-- get number of souls
	local lines = 0
	local modifier = self:GetCaster():FindModifierByNameAndCaster( "modifier_death_eater_necromastery", self:GetCaster() )
	if modifier~=nil then
		lines = math.floor(modifier:GetStackCount() / soul_per_line) 
	end

	-- explode
	self:Explode( lines/2 )
end

--------------------------------------------------------------------------------
-- Helper
function death_eater_deaths_requiem:Explode( lines )
	-- get references
	self.damage =  self:GetAbilityDamage()
	self.duration = self:GetSpecialValueFor("requiem_slow_duration")

	-- get projectile
	local particle_line = "particles/hero_demon_eater/lina_spell_dragon_slave_2.vpcf"
	local line_length = self:GetSpecialValueFor("requiem_radius")
	local width_start = self:GetSpecialValueFor("requiem_line_width_start")
	local width_end = self:GetSpecialValueFor("requiem_line_width_end")
	local line_speed = self:GetSpecialValueFor("requiem_line_speed")

	-- create linear projectile
	local initial_angle_deg = self:GetCaster():GetAnglesAsVector().y
	local delta_angle = 360/lines
	for i=0,lines-1 do
		-- Determine velocity
		local facing_angle_deg = initial_angle_deg + delta_angle * i
		if facing_angle_deg>360 then facing_angle_deg = facing_angle_deg - 360 end
		local facing_angle = math.rad(facing_angle_deg)
		local facing_vector = Vector( math.cos(facing_angle), math.sin(facing_angle), 0 ):Normalized()
		local velocity = facing_vector * line_speed

		-- create projectile
		local info = {
			Source = self:GetCaster(),
			Ability = self,
			EffectName = particle_line,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fDistance = line_length,
			vVelocity = velocity,
			fStartRadius = width_start,
			fEndRadius = width_end,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_SPELL_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bReplaceExisting = false,
			bProvidesVision = false,
		}
		ProjectileManager:CreateLinearProjectile( info )
	end

	-- Play effects
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
    local sound_cast = "Hero_Nevermore.RequiemOfSouls"

    -- Create Particles
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( lines, 0, 0 ) )	-- Lines
    ParticleManager:SetParticleControlForward( effect_cast, 2, self:GetCaster():GetForwardVector() )		-- initial direction
    ParticleManager:ReleaseParticleIndex( effect_cast )

    -- Play Sounds
    EmitSoundOn(sound_cast, self:GetCaster())
end

function death_eater_deaths_requiem:Implode( lines, modifier )
	-- get data
	self.damage_pct = self:GetSpecialValueFor("requiem_damage_pct_scepter")
	self.damage_heal_pct = self:GetSpecialValueFor("requiem_heal_pct_scepter")

	-- create identifier
	local modifierAT = self:AddATValue( modifier )
	modifier.identifier = modifierAT

	-- get projectile
	local particle_line = "particles/hero_demon_eater/lina_spell_dragon_slave_2.vpcf"
	local line_length = self:GetSpecialValueFor("requiem_radius")
	local width_start = self:GetSpecialValueFor("requiem_line_width_end")
	local width_end = self:GetSpecialValueFor("requiem_line_width_start")
	local line_speed = self:GetSpecialValueFor("requiem_line_speed")

	-- create linear projectile
	local initial_angle_deg = self:GetCaster():GetAnglesAsVector().y
	local delta_angle = 360/lines
	for i=0,lines-1 do
		-- Determine velocity
		local facing_angle_deg = initial_angle_deg + delta_angle * i
		if facing_angle_deg>360 then facing_angle_deg = facing_angle_deg - 360 end
		local facing_angle = math.rad(facing_angle_deg)
		local facing_vector = Vector( math.cos(facing_angle), math.sin(facing_angle), 0 ):Normalized()
		local velocity = facing_vector * line_speed

		
		-- create projectile
		local info = {
			Source = self:GetCaster(),
			Ability = self,
			EffectName = particle_line,
			vSpawnOrigin = self:GetCaster():GetOrigin() + facing_vector * line_length,
			fDistance = line_length,
			vVelocity = -velocity,
			fStartRadius = width_start,
			fEndRadius = width_end,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_SPELL_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bReplaceExisting = false,
			bProvidesVision = false,
			ExtraData = {
				scepter = true,
				modifier = modifierAT,
			}
		}
		ProjectileManager:CreateLinearProjectile( info )
	end
end


--------------------------------------------------------------------------------
-- Helper: Ability Table (AT)
function death_eater_deaths_requiem:GetAT()
	if self.abilityTable==nil then
		self.abilityTable = {}
	end
	return self.abilityTable
end

function death_eater_deaths_requiem:GetATEmptyKey()
	local table = self:GetAT()
	local i = 1
	while table[i]~=nil do
		i = i+1
	end
	return i
end

function death_eater_deaths_requiem:AddATValue( value )
	local table = self:GetAT()
	local i = self:GetATEmptyKey()
	table[i] = value
	return i
end

function death_eater_deaths_requiem:RetATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	return ret
end

function death_eater_deaths_requiem:DelATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	table[key] = nil
end


if not modifier_death_eater_deaths_requiem_pull then  modifier_death_eater_deaths_requiem_pull = class({}) end 

function modifier_death_eater_deaths_requiem_pull:IsAura() return true end
function modifier_death_eater_deaths_requiem_pull:IsHidden() return true end
function modifier_death_eater_deaths_requiem_pull:IsPurgable() return false end
function modifier_death_eater_deaths_requiem_pull:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("requiem_radius") end
function modifier_death_eater_deaths_requiem_pull:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_death_eater_deaths_requiem_pull:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_death_eater_deaths_requiem_pull:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_death_eater_deaths_requiem_pull:GetModifierAura() return "modifier_death_eater_deaths_requiem_pull_debuff" end

if modifier_death_eater_deaths_requiem_pull_debuff == nil then modifier_death_eater_deaths_requiem_pull_debuff = class({}) end

function modifier_death_eater_deaths_requiem_pull_debuff:IsHidden() return true end
function modifier_death_eater_deaths_requiem_pull_debuff:IsPurgable() return true end

function modifier_death_eater_deaths_requiem_pull_debuff:OnCreated(table)
     if IsServer() then
        self._vLoc = self:GetCaster():GetAbsOrigin()

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_death_eater_deaths_requiem_pull_debuff:OnIntervalThink()
	if IsServer() then
          local distance = (self._vLoc - self:GetParent():GetAbsOrigin()):Length2D()

          if distance > MAX_SLOPH_DISTANCE then
               local direction = (self._vLoc - self:GetParent():GetAbsOrigin()):Normalized()

               self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + direction * (FALL_SPEED * FrameTime()))
          end
	end
end

function modifier_death_eater_deaths_requiem_pull_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_death_eater_deaths_requiem_pull_debuff:GetOverrideAnimation( params ) return ACT_DOTA_FLAIL end
function modifier_death_eater_deaths_requiem_pull_debuff:CheckState() return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true, [MODIFIER_STATE_STUNNED] = true} end


modifier_death_eater_deaths_requiem = class({})

--------------------------------------------------------------------------------

function modifier_death_eater_deaths_requiem:IsDebuff()
	return true
end

function modifier_death_eater_deaths_requiem:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_death_eater_deaths_requiem:OnCreated( kv )
	self.reduction_ms_pct = self:GetAbility():GetSpecialValueFor("requiem_reduction_ms")
	self.reduction_damage_pct = self:GetAbility():GetSpecialValueFor("requiem_reduction_damage")
end

function modifier_death_eater_deaths_requiem:OnRefresh( kv )
	self.reduction_ms_pct = self:GetAbility():GetSpecialValueFor("requiem_reduction_ms")
	self.reduction_damage_pct = self:GetAbility():GetSpecialValueFor("requiem_reduction_damage")
end

--------------------------------------------------------------------------------

function modifier_death_eater_deaths_requiem:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_death_eater_deaths_requiem:GetModifierDamageOutgoing_Percentage()
	return self.reduction_damage_pct
end

function modifier_death_eater_deaths_requiem:GetModifierMoveSpeedBonus_Percentage()
	return self.reduction_ms_pct
end

modifier_death_eater_deaths_requiem_scepter = class({})

--------------------------------------------------------------------------------

function modifier_death_eater_deaths_requiem_scepter:IsHidden()
	return false
	-- return true
end

function modifier_death_eater_deaths_requiem_scepter:IsPurgable()
	return false
end
function modifier_death_eater_deaths_requiem_scepter:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_death_eater_deaths_requiem_scepter:OnCreated( kv )
	-- get references
	self.lines = kv.lineNumber
	self.duration = kv.lineDuration

	self.heal = 0

	-- Add timer
	if IsServer() then
		self:StartIntervalThink( self.duration )
	end
end

function modifier_death_eater_deaths_requiem_scepter:OnRefresh( kv )
end

function modifier_death_eater_deaths_requiem_scepter:OnDestroy()
	if IsServer() then
		if self.identifier then
			self:GetAbility():DelATValue( self.identifier )
		end
	end
end
--------------------------------------------------------------------------------
-- Interval
function modifier_death_eater_deaths_requiem_scepter:OnIntervalThink()
	if not self.afterImplode then
		self.afterImplode = true

		-- implode
		self:GetAbility():Implode( self.lines, self )

		-- play effects
		local sound_cast = "Hero_Nevermore.RequiemOfSouls"
		EmitSoundOn(sound_cast, self:GetParent())
	else
		-- Heal
		self:GetParent():Heal( self.heal, self:GetAbility() )
		if self.heal > 0 then
			self:PlayEffects()
		end

		-- remove references
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_death_eater_deaths_requiem_scepter:AddTotalHeal( value )
	self.heal = self.heal + value
end

--------------------------------------------------------------------------------
-- Effects
function modifier_death_eater_deaths_requiem_scepter:PlayEffects()
	local particle_cast = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end