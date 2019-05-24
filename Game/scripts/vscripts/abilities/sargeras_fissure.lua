LinkLuaModifier( "sargeras_fissure_thinker", "abilities/sargeras_fissure.lua", LUA_MODIFIER_MOTION_NONE )
if sargeras_fissure == nil then
	sargeras_fissure = class({})
end

function sargeras_fissure:GetBehavior()
	local behav = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	return behav
end

function sargeras_fissure:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()
	local nLenght = self:GetCastRange( self:GetCursorPosition(), nil)
	local vForward = self:GetCursorPosition() - hCaster:GetAbsOrigin()
	vForward = vForward:Normalized()
	local nDuration	= self:GetSpecialValueFor( "fissure_duration" )
	local nStun	= self:GetSpecialValueFor( "stun_duration" )
	local nRadius	= self:GetSpecialValueFor( "fissure_radius" )
	local vStartPos = hCaster:GetAbsOrigin()
	local vEndPos = vStartPos + vForward * nLenght
	vStartPos = vStartPos + vForward * 64

	local particle = "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_fissure_egset.vpcf"
	local sound = "Hero_EarthShaker.Fissure.Cast"

	if Util:PlayerEquipedItem(self:GetCaster():GetPlayerOwnerID(), "sargeras_devourer_of_words") then
		particle = "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9.vpcf"
		sound = "Sargeras.WD.Fissure"
	end

	EmitSoundOnLocationWithCaster(vEndPos, sound, hCaster )
	EmitSoundOnLocationWithCaster(vStartPos, sound, hCaster )

	local nFXIndex = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN, hCaster )
	ParticleManager:SetParticleControl( nFXIndex, 0, vStartPos )
	ParticleManager:SetParticleControl( nFXIndex, 0, vStartPos )
	ParticleManager:SetParticleControl( nFXIndex, 1, vEndPos )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( nDuration, 0, 0 ) )

	local numBoulder = math.floor( nLenght / (32*2) ) + 1
	local stepLength = nLenght / ( numBoulder - 1 )
	for i=1, numBoulder do
		local boulderPos = vStartPos + vForward * (i-1) * stepLength
		self:SpawnBoulder(boulderPos,nDuration)
	end
	local tVictims = FindUnitsInLine( hCaster:GetTeamNumber(), vStartPos, vEndPos , nil, nRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER  )
	local nDamageType = self:GetAbilityDamageType()
	local nDamage = self:GetAbilityDamage()
	local damage = {
		attacker = hCaster,
		damage = nDamage,
		damage_type = nDamageType,
		ability = self
	}
	for k,v in pairs(tVictims) do
		FindClearSpaceForUnit(v, v:GetAbsOrigin(), true)
		if v:GetTeam() ~= hCaster:GetTeam() then
			v:AddNewModifier( hCaster, self, "modifier_stunned", { duration = nStun } )
			damage.victim = v
			ApplyDamage( damage )
		end
	end
end

function sargeras_fissure:SpawnBoulder(vPos,nDuration)
	local hCaster = self:GetCaster()

	CreateModifierThinker(hCaster, self, "sargeras_fissure_thinker", {duration = nDuration , radius = 46}, vPos, hCaster:GetTeam(), true)
end

if sargeras_fissure_thinker == nil then
	sargeras_fissure_thinker = class({})
end

function sargeras_fissure_thinker:OnCreated( kv )
	if IsServer() then
		self:GetParent():SetHullRadius(kv.radius)
		self:StartIntervalThink(0.1)
	end
end

function sargeras_fissure_thinker:OnRefresh( kv )
	if IsServer() then
	end
end

function sargeras_fissure_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

function sargeras_fissure_thinker:OnIntervalThink()
	if IsServer() then
		local caster = self:GetParent()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 124, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i = 1, #units do
			local unit = units[i]
			if not unit:IsMagicImmune() then
				ApplyDamage({victim = unit, attacker = self:GetAbility():GetCaster(), damage = (self:GetAbility():GetSpecialValueFor("damage_per_sec")/10), damage_type = self:GetAbility():GetAbilityDamageType()})
			end
		end

		AddFOWViewer(2, self:GetCaster():GetAbsOrigin(), 10, 0.15, false) AddFOWViewer(3, self:GetCaster():GetAbsOrigin(), 10, 0.15, false)
	end
end

function sargeras_fissure_thinker:IsHidden()
	return true
end

function sargeras_fissure_thinker:IsPurgable()
	return false
end

function sargeras_fissure_thinker:IsPurgeException()
	return false
end

function sargeras_fissure_thinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function sargeras_fissure_thinker:AllowIllusionDuplicate()
	return false
end

function sargeras_fissure:GetAbilityTextureName() if self:GetCaster():HasModifier("modifier_sargeras_s7_custom") then return "custom/sargeras_fissure_custom" end return self.BaseClass.GetAbilityTextureName(self)  end 

