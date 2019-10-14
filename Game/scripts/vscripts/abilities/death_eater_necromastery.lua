death_eater_necromastery = class({})
LinkLuaModifier( "modifier_death_eater_necromastery", "abilities/death_eater_necromastery", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function death_eater_necromastery:GetIntrinsicModifierName()
	return "modifier_death_eater_necromastery"
end

modifier_death_eater_necromastery = class({})

--------------------------------------------------------------------------------

function modifier_death_eater_necromastery:IsHidden()
	return false
end

function modifier_death_eater_necromastery:IsDebuff()
	return false
end

function modifier_death_eater_necromastery:IsPurgable()
	return false
end

function modifier_death_eater_necromastery:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_death_eater_necromastery:OnCreated( kv )
	-- get references
    self.soul_max = self:GetAbility():GetSpecialValueFor("necromastery_max_souls")
	self.soul_max_scepter = self:GetAbility():GetSpecialValueFor("necromastery_max_souls_scepter")
	self.soul_release = self:GetAbility():GetSpecialValueFor("necromastery_soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("necromastery_damage_per_soul")
	self.soul_hero_bonus = self:GetAbility():GetSpecialValueFor("necromastery_souls_hero_bonus")

	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_death_eater_necromastery:OnRefresh( kv )
	-- get references
	self.soul_max = self:GetAbility():GetSpecialValueFor("necromastery_max_souls")
	self.soul_max_scepter = self:GetAbility():GetSpecialValueFor("necromastery_max_souls_scepter")
	self.soul_release = self:GetAbility():GetSpecialValueFor("necromastery_soul_release")
	self.soul_damage = self:GetAbility():GetSpecialValueFor("necromastery_damage_per_soul")
	self.soul_hero_bonus = self:GetAbility():GetSpecialValueFor("necromastery_souls_hero_bonus")
end

--------------------------------------------------------------------------------

function modifier_death_eater_necromastery:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------
-- soul release
function modifier_death_eater_necromastery:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
		self:KillLogic( params )
	end
end

function modifier_death_eater_necromastery:GetModifierPreAttack_BonusDamage( params )
	if not self:GetParent():IsIllusion() then
		local max_stack = self.soul_max
		if self:GetParent():HasScepter() then
			return self:GetStackCount() * (self.soul_damage + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_death_eater_2") or 1))
		else
			return math.min(self.soul_max,self:GetStackCount()) * (self.soul_damage + (IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_death_eater_2") or 1))
		end
	end
end

--------------------------------------------------------------------------------
function modifier_death_eater_necromastery:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent() and params.reincarnate==false then
		pass = true
	end

	-- logic
	if pass then
		local after_death = math.floor(self:GetStackCount() * self.soul_release)
		self:SetStackCount(math.max(after_death,1))
	end
end

function modifier_death_eater_necromastery:KillLogic( params )
	-- filter
	local target = params.unit
	local attacker = params.attacker
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

	-- logic
	if pass and (not self:GetParent():PassivesDisabled()) then
		self:AddStack(1)
		-- check if it is a hero
		if target:IsRealHero() then
			self:AddStack(11)
		end

		self:PlayEffects( target )
	end
end

function modifier_death_eater_necromastery:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
	if not self:GetParent():HasScepter() then
		if after > self.soul_max then
			after = self.soul_max
		end
	else
		if after > self.soul_max_scepter then
			after = self.soul_max_scepter
		end
	end
	self:SetStackCount( after )
end

function modifier_death_eater_necromastery:PlayEffects( target )
	-- Get Resources
	local projectile_name = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"

	-- CreateProjectile
	local info = {
		Target = self:GetParent(),
		Source = target,
		EffectName = projectile_name,
		iMoveSpeed = 400,
		vSourceLoc= target:GetAbsOrigin(),                -- Optional
		bDodgeable = false,                                -- Optional
		bReplaceExisting = false,                         -- Optional
		flExpireTime = GameRules:GetGameTime() + 5,      -- Optional but recommended
		bProvidesVision = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
