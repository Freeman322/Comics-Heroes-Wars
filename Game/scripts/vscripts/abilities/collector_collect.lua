collector_collect = class({})

orb_manager = {}
ability_manager = {}

function collector_collect:IsStealable()
	return false
end

  
function collector_collect:GetCooldown( nLevel )
    if self:GetCaster():HasScepter() then 
        return self:GetSpecialValueFor("cooldown_scepter")
    end
	return self.BaseClass.GetCooldown( self, nLevel )
end


function collector_collect:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_alma") then return "custom/alma_collect" end
  return self.BaseClass.GetAbilityTextureName(self)
end


--------------------------------------------------------------------------------
-- Invoke List and Constants
orb_manager.orb_order = "qwe"
orb_manager.invoke_list = {
	["qqq"] = "collector_cold_snap",
	["qqe"] = "collector_ice_blast",
	["qqw"] = "collector_ghost_walk",
	["www"] = "collector_sanity_eclipse",
	["qww"] = "collector_tornado",
	["wwe"] = "collector_aboriginal_power",
	["eee"] = "collector_sun_strike",
	["qee"] = "collector_astral_imprisonment",
	["wee"] = "collector_chaos_meteor",
	["qwe"] = "collector_sonic_boom",
}
orb_manager.modifier_list = {
	["q"] = "modifier_collector_quas",
	["w"] = "modifier_collector_wex",
	["e"] = "modifier_collector_exort",

	["modifier_collector_quas"] = "q",
	["modifier_collector_wex"] = "w",
	["modifier_collector_exort"] = "e",
}

function collector_collect:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- get invoked ability name
	local ability_name = self.orb_manager:GetInvokedAbility()

	-- invoke
	self.ability_manager:Invoke( ability_name )

	-- Effects
	self:PlayEffects()
end
function collector_collect:OnUpgrade()
	-- add orb manager
	self.orb_manager = orb_manager:init()

	-- add ability manager
	self.ability_manager = ability_manager:init()
	self.ability_manager.caster = self:GetCaster()
	self.ability_manager.ability = self

	-- add empty ability
	local empty1 = self:GetCaster():FindAbilityByName( "invoker_empty1" )
	local empty2 = self:GetCaster():FindAbilityByName( "invoker_empty2" )
	table.insert(self.ability_manager.ability_slot,empty1)
	table.insert(self.ability_manager.ability_slot,empty2)
end
function collector_collect:AddOrb( modifier )
	self.orb_manager:Add( modifier )
end
function collector_collect:UpdateOrb( modifer_name, level )
	updates = self.orb_manager:UpdateOrb( modifer_name, level )
	self.ability_manager:UpgradeAbilities()
end
function collector_collect:GetOrbLevel( orb_name )
	if not self.orb_manager.status[orb_name] then return 0 end
	return self.orb_manager.status[orb_name].level
end
function collector_collect:GetOrbInstances( orb_name )
	if not self.orb_manager.status[orb_name] then return 0 end
	return self.orb_manager.status[orb_name].instances
end
function collector_collect:GetOrbs()
	local ret = {}
	for k,v in pairs(self.orb_manager.status) do
		ret[k] = v.level
	end
	return ret
end
function collector_collect:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_invoke.vpcf"
	local sound_cast = "Hero_Invoker.Invoke"

	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "alma") then
		particle_cast = "particles/collector/alma_collect_cast.vpcf"
		sound_cast = "MolagBal.Maceofoblivion.Cast"

		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_6)
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function orb_manager:init()
	local ret = {}

	-- initialize fields
	ret.MAX_ORB = 3
	ret.status = {}
	ret.modifiers = {}
	ret.names = {}

	-- initialize methods and constants
	for k,v in pairs(self) do
		ret[k] = v
	end
	return ret
end
function orb_manager:Add( modifier )
	-- register new orb type if not exist
	local orb_name = self.modifier_list[modifier:GetName()]
	if not self.status[orb_name] then
		self.status[orb_name] = {
			["instances"] = 0,
			["level"] = modifier:GetAbility():GetLevel(),
		}
	end

	-- add new orb instance
	table.insert(self.modifiers,modifier)
	table.insert(self.names,orb_name)
	self.status[orb_name].instances = self.status[orb_name].instances + 1

	-- remove last orb
	if #self.modifiers>self.MAX_ORB then
		self.status[self.names[1]].instances = self.status[self.names[1]].instances - 1
		self.modifiers[1]:Destroy()

		table.remove(self.modifiers,1)
		table.remove(self.names,1)
	end
end
function orb_manager:GetInvokedAbility()
	-- check instances
	local key = ""
	for i=1,string.len(self.orb_order) do
		k = string.sub(self.orb_order,i,i)

		if self.status[k] then 
			for i=1,self.status[k].instances do
				key = key .. k
			end
		end
	end
	return self.invoke_list[key]

	-- if allows permutation
	-- return self.invoke_list[ self.names[1] .. self.names[2] .. self.names[3] ]
end
function orb_manager:UpdateOrb( modifer_name, level )
	-- refresh orb instances
	for _,modifier in pairs(self.modifiers) do
		if modifier:GetName()==modifer_name then
			modifier:ForceRefresh()
		end
	end

	-- update its level
	local orb_name = self.modifier_list[modifer_name]
	if not self.status[orb_name] then
		self.status[orb_name] = {
			["instances"] = 0,
			["level"] = level,
		}
	else
		self.status[orb_name].level = level
	end
end
function ability_manager:init()
	local ret = {}

	-- initialize fields
	ret.abilities = {}
	ret.ability_slot = {}
	ret.MAX_ABILITY = 2

	-- initialize methods and constants
	for k,v in pairs(self) do
		ret[k] = v
	end
	return ret
end
function ability_manager:Invoke( ability_name )
	if not ability_name then return end

	local ability = self:GetAbilityHandle( ability_name )
	ability.orbs = self.ability:GetOrbs()

	-- nothing to invoke
	if self.ability_slot[1] and self.ability_slot[1]==ability then
		self.ability:RefundManaCost()
		self.ability:EndCooldown()
		return
	end

	-- swap already existing
	local exist = 0
	for i=1,#self.ability_slot do
		if self.ability_slot[i]==ability then
			exist = i
		end
	end
	if exist>0 then
		self:InvokeExist( exist )
		self.ability:RefundManaCost()
		self.ability:EndCooldown()
		return
	end

	-- summon new ability
	self:InvokeNew( ability )
end
function ability_manager:InvokeExist( slot )
	for i=slot,2,-1 do
		-- swap abilities
		self.caster:SwapAbilities( 
			self.ability_slot[slot-1]:GetAbilityName(),
			self.ability_slot[slot]:GetAbilityName(),
			true,
			true
		)

		-- sync slot
		self.ability_slot[slot], self.ability_slot[slot-1] = self.ability_slot[slot-1], self.ability_slot[slot]
	end
end
function ability_manager:InvokeNew( ability )
	if #self.ability_slot<self.MAX_ABILITY then
		-- add ability at tail
		table.insert(self.ability_slot,ability)
	else
		-- swap the last ability with the summoned
		self.caster:SwapAbilities( 
			ability:GetAbilityName(),
			self.ability_slot[#self.ability_slot]:GetAbilityName(),
			true,
			false
		)

		-- sync slot
		self.ability_slot[#self.ability_slot] = ability
	end

	-- move to the front
	self:InvokeExist( #self.ability_slot )
end
function ability_manager:GetAbilityHandle( ability_name )
	-- get ability handle
	local ability = self.abilities[ability_name]

	-- if handle not exist, get one existing
	if not ability then
		ability = self.caster:FindAbilityByName( ability_name )
		self.abilities[ability_name] = ability
		
		-- if not exist, create one
		if not ability then
			ability = self.caster:AddAbility( ability_name )
			self.abilities[ability_name] = ability
		end

		-- ability:SetLevel(1)
		self:InitAbility( ability )
	end

	return ability
end
function ability_manager:InitAbility( ability )
	ability:SetLevel(1)
	ability.GetOrbSpecialValueFor = function( self, key_name, orb_name )
		if not IsServer() then return 0 end
		if not self.orbs[orb_name] then return 0 end
		return self:GetLevelSpecialValueFor( key_name, self.orbs[orb_name] )
	end
end
function ability_manager:UpgradeAbilities()
	for _,ability in pairs(self.abilities) do
		ability.orbs = self.ability:GetOrbs()
	end
end