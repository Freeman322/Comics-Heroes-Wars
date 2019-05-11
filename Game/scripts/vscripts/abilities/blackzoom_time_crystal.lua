blackzoom_time_crystal = class({})

LinkLuaModifier("modifiers_blackzoom_time_crystal", "abilities/blackzoom_time_crystal.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifiers_blackzoom_time_crystal_enemy", "abilities/blackzoom_time_crystal.lua", LUA_MODIFIER_MOTION_NONE)

function blackzoom_time_crystal:GetAOERadius()
	return self:GetSpecialValueFor( "mana_void_aoe_radius" )
end

function blackzoom_time_crystal:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function blackzoom_time_crystal:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end


function blackzoom_time_crystal:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	hTarget:AddNewModifier(hCaster, self, "modifiers_blackzoom_time_crystal", {duration = self:GetSpecialValueFor("duration")})

	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hCaster )
	EmitSoundOn( "Hero_FacelessVoid.TimeLockImpact", hTarget )

	hCaster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )
end

if modifiers_blackzoom_time_crystal == nil then modifiers_blackzoom_time_crystal = class({}) end

function modifiers_blackzoom_time_crystal:IsPurgable()
	return false
end

function modifiers_blackzoom_time_crystal:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end

function modifiers_blackzoom_time_crystal:StatusEffectPriority()
	return 1000
end

function modifiers_blackzoom_time_crystal:GetEffectName()
	return "particles/hero_zoom/time_crystal.vpcf"
end

function modifiers_blackzoom_time_crystal:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifiers_blackzoom_time_crystal:OnCreated( kv )
	if IsServer() then
    		self:StartIntervalThink(1)
  	end
end

function modifiers_blackzoom_time_crystal:OnIntervalThink()
	if IsServer() then
		local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), self:GetAbility():GetSpecialValueFor("mana_void_aoe_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #units > 0 then
			for _,target in pairs(units) do
				ApplyDamage({attacker = self:GetCaster(), victim = target, damage = self:GetAbility():GetSpecialValueFor("damage_per_sec"), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PURE})
			end
		end
	end
end

function modifiers_blackzoom_time_crystal:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end


function modifiers_blackzoom_time_crystal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}

	return funcs
end

function modifiers_blackzoom_time_crystal:GetDisableHealing()
	return 1
end

function modifiers_blackzoom_time_crystal:GetAbsoluteNoDamagePure()
	return 1
end

function modifiers_blackzoom_time_crystal:GetAbsoluteNoDamageMagical()
	return 1
end

function modifiers_blackzoom_time_crystal:GetAbsoluteNoDamagePhysical()
	return 1
end

function blackzoom_time_crystal:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

