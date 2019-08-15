if not mod_mirror_in_glass then mod_mirror_in_glass = class({}) end
LinkLuaModifier ("modifier_mod_mirror_in_glass", "abilities/mod_mirror_in_glass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_mod_mirror_in_glass_target", "abilities/mod_mirror_in_glass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_mod_mirror_in_glass_return", "abilities/mod_mirror_in_glass.lua", LUA_MODIFIER_MOTION_NONE)

function mod_mirror_in_glass:GetIntrinsicModifierName() return "modifier_mod_mirror_in_glass" end

function mod_mirror_in_glass:IsRefreshable()
    return false
end

local MINI_STUN_DURATION = 0.03
local EF_DMG_CAP = 500
local EF_RADIUS = 500

function mod_mirror_in_glass:GetCooldown( nLevel )
    return self.BaseClass.GetCooldown( self, nLevel )
end

function mod_mirror_in_glass:IncrementSouls()
    local mod = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())

     if mod then
          local max = self:GetSpecialValueFor("max_souls")
          if self:GetCaster():HasTalent("special_bonus_unique_mod_5") then max = 999 end 
          if mod:GetStackCount() < max then mod:IncrementStackCount() end 
     end 
end
 
function mod_mirror_in_glass:GetSouls()
     return self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):GetStackCount()
end
 
function mod_mirror_in_glass:ResetSouls()
     self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):SetStackCount(1)
end

function mod_mirror_in_glass:ResetSoulsOnUse()
     local mod = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
     if mod then
          mod:SetStackCount(mod:GetStackCount() / 2)
     end
end

function mod_mirror_in_glass:GetAT()
	if self.abilityTable==nil then
		self.abilityTable = {}
	end
	return self.abilityTable
end

function mod_mirror_in_glass:GetATEmptyKey()
	local table = self:GetAT()
	local i = 1
	while table[i]~=nil do
		i = i+1
	end
	return i
end

function mod_mirror_in_glass:AddATValue( value )
	local table = self:GetAT()
	local i = self:GetATEmptyKey()
	table[i] = value
	return i
end

function mod_mirror_in_glass:RetATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	return ret
end

function mod_mirror_in_glass:DelATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	table[key] = nil
end

function mod_mirror_in_glass:OnAbilityPhaseStart()
     local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"
     
     EmitSoundOn(sound_precast, self:GetCaster())
     
	return true 
end
function mod_mirror_in_glass:OnAbilityPhaseInterrupted()
	local sound_precast = "Hero_Nevermore.RequiemOfSoulsCast"

	
	if not success then
		StopSoundOn(sound_precast, self:GetCaster())
	end
end

--------------------------------------------------------------------------------
-- Ability Start
function mod_mirror_in_glass:OnSpellStart()
	-- get references
	local soul_per_line = self:GetSpecialValueFor("requiem_soul_conversion")

	-- get number of souls
	local lines = 0
     local modifier = self:GetCaster():FindModifierByNameAndCaster( "modifier_mod_mirror_in_glass", self:GetCaster() )
     
	if modifier ~= nil then
		lines = math.floor(modifier:GetStackCount() / soul_per_line) 
	end

	-- explode
	self:Explode( lines )

	-- if has scepter, add modifier to implode
	local explodeDuration = self:GetSpecialValueFor("requiem_radius") / self:GetSpecialValueFor("requiem_line_speed")
     self:GetCaster():AddNewModifier(
          self:GetCaster(),
          self,
          "modifier_mod_mirror_in_glass_return",
          {
               lineDuration = explodeDuration,
               lineNumber = lines,
          }
     )

     --- Prevent cda-red for this ability 
     self:EndCooldown() self:StartCooldown(self:GetCooldown(self:GetLevel()))
end

--------------------------------------------------------------------------------
-- Projectile Hit
function mod_mirror_in_glass:OnProjectileHit_ExtraData( hTarget, vLocation, params )
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
				damage = self.damage + (self:GetSpecialValueFor("damage_per_soul") * self:GetSouls()),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damage )

			-- apply modifier
			hTarget:AddNewModifier(
				self:GetCaster(),
				self,
				"modifier_nevermore_requiem",
				{ duration = self.duration }
			)
		end
	end

	return false
end

--------------------------------------------------------------------------------
-- Triggers
function mod_mirror_in_glass:OnOwnerDied()
	-- do nothing if not learned
	if self:GetLevel()<1 then return end

	-- get references
	local soul_per_line = self:GetSpecialValueFor("requiem_soul_conversion")

	-- get number of souls
	local lines = 0
	local modifier = self:GetCaster():FindModifierByNameAndCaster( "modifier_mod_mirror_in_glass", self:GetCaster() )
	if modifier~=nil then
		lines = math.floor(modifier:GetStackCount() / soul_per_line) 
     end
     
     self:ResetSoulsOnUse()

	-- explode
	self:Explode( lines/2 )
end

--------------------------------------------------------------------------------
-- Helper
function mod_mirror_in_glass:Explode( lines )
	-- get references
	self.damage =  self:GetAbilityDamage()
	self.duration = self:GetSpecialValueFor("requiem_slow_duration")

	-- get projectile
	local particle_line = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf"
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

function mod_mirror_in_glass:Implode( lines, modifier )
	-- get data
	self.damage_pct = self:GetSpecialValueFor("requiem_damage_pct_scepter")
	self.damage_heal_pct = self:GetSpecialValueFor("requiem_heal_pct_scepter")

	-- create identifier
	local modifierAT = self:AddATValue( modifier )
	modifier.identifier = modifierAT

	-- get projectile
	local particle_line = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf"
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

if modifier_mod_mirror_in_glass == nil then modifier_mod_mirror_in_glass = class({}) end

function modifier_mod_mirror_in_glass:IsAura()
	return true
end

function modifier_mod_mirror_in_glass:IsHidden()
	return false
end

function modifier_mod_mirror_in_glass:IsPurgable()
	return false
end

function modifier_mod_mirror_in_glass:GetAuraRadius()
	return EF_RADIUS
end

function modifier_mod_mirror_in_glass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_mod_mirror_in_glass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_mod_mirror_in_glass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_mod_mirror_in_glass:GetModifierAura()
	return "modifier_mod_mirror_in_glass_target"
end

function modifier_mod_mirror_in_glass:DeclareFunctions()
     local funcs = {
         MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
     }
     return funcs
end
 
function modifier_mod_mirror_in_glass:GetModifierPreAttack_BonusDamage()
     local damage = self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "preattack_damage_per_soul" )

     if (damage > EF_DMG_CAP) then damage = 250 end 

     return damage
end

 
modifier_mod_mirror_in_glass_target = class({})

function modifier_mod_mirror_in_glass_target:IsHidden() return true end
function modifier_mod_mirror_in_glass_target:IsPurgable() return false end

function modifier_mod_mirror_in_glass_target:DeclareFunctions()
     local funcs = {
          MODIFIER_EVENT_ON_DEATH
     }
 
     return funcs
 end
 
 function modifier_mod_mirror_in_glass_target:OnDeath(params)
     if IsServer() then
          if params.unit == self:GetParent() then
               self:GetAbility():IncrementSouls()
          end 
     end 
 end

 modifier_mod_mirror_in_glass_return = class({})

--------------------------------------------------------------------------------

function modifier_mod_mirror_in_glass_return:IsHidden()
	return false
	-- return true
end

function modifier_mod_mirror_in_glass_return:IsPurgable()
	return false
end
function modifier_mod_mirror_in_glass_return:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_mod_mirror_in_glass_return:OnCreated( kv )
	-- get references
	self.lines = kv.lineNumber
	self.duration = kv.lineDuration

	self.heal = 0

	-- Add timer
	if IsServer() then
		self:StartIntervalThink( self.duration )
	end
end

function modifier_mod_mirror_in_glass_return:OnRefresh( kv )
end

function modifier_mod_mirror_in_glass_return:OnDestroy()
	if IsServer() then
		if self.identifier then
			self:GetAbility():DelATValue( self.identifier )
		end
	end
end
--------------------------------------------------------------------------------
-- Interval
function modifier_mod_mirror_in_glass_return:OnIntervalThink()
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
function modifier_mod_mirror_in_glass_return:AddTotalHeal( value )
	self.heal = self.heal + value
end

--------------------------------------------------------------------------------
-- Effects
function modifier_mod_mirror_in_glass_return:PlayEffects()
	local particle_cast = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end