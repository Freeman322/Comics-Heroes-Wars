collector_ghost_walk = class({})
LinkLuaModifier( "modifier_collector_ghost_walk", "abilities/collector_ghost_walk.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_collector_ghost_walk_debuff", "abilities/collector_ghost_walk.lua", LUA_MODIFIER_MOTION_NONE )
local intPack = require( "utils/intPack" )
--------------------------------------------------------------------------------
-- Ability Start
function collector_ghost_walk:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(
		caster, 
		self, 
		"modifier_collector_ghost_walk", 
		{ duration = duration } 
	)

	self:PlayEffects()
end


function collector_ghost_walk:IsStealable()
	return false
end


function collector_ghost_walk:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf"
	local sound_cast = "Hero_Invoker.GhostWalk"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetCaster() )
end

modifier_collector_ghost_walk = class({})

function modifier_collector_ghost_walk:IsHidden()
	return false
end

function modifier_collector_ghost_walk:IsDebuff()
	return false
end

function modifier_collector_ghost_walk:IsPurgable()
	return false
end

function modifier_collector_ghost_walk:IsAura()
	return true
end

function modifier_collector_ghost_walk:GetModifierAura()
	return "modifier_collector_ghost_walk_debuff"
end

function modifier_collector_ghost_walk:GetAuraRadius()
	return self.radius
end

function modifier_collector_ghost_walk:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_collector_ghost_walk:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_collector_ghost_walk:GetAuraDuration()
	return self.aura_duration
end

function modifier_collector_ghost_walk:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
		self.aura_duration = self:GetAbility():GetSpecialValueFor( "aura_fade_time" )
		self.self_slow = self:GetAbility():GetOrbSpecialValueFor( "self_slow", "w" )
		self.enemy_slow = self:GetAbility():GetOrbSpecialValueFor( "enemy_slow", "q" )
	end
end

function modifier_collector_ghost_walk:OnRefresh( kv )
	if IsServer() then
		-- references
		self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
		self.aura_duration = self:GetAbility():GetSpecialValueFor( "aura_fade_time" )
		self.self_slow = self:GetAbility():GetOrbSpecialValueFor( "self_slow", "w" )
		self.enemy_slow = self:GetAbility():GetOrbSpecialValueFor( "enemy_slow", "q" )
	end
end

function modifier_collector_ghost_walk:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_collector_ghost_walk:GetModifierMoveSpeedBonus_Percentage()
	return self.self_slow
end

function modifier_collector_ghost_walk:GetModifierInvisibilityLevel()
	return 1
end

function modifier_collector_ghost_walk:GetModifierMoveSpeed_Max()
	return 1000
end

function modifier_collector_ghost_walk:GetModifierMoveSpeed_Limit()
	return 1000
end

function modifier_collector_ghost_walk:GetModifierMoveSpeedBonus_Constant()
	return IsHasTalent(self:GetCaster():GetPlayerOwnerID(), "special_bonus_unique_collector_5") or 0 
end


function modifier_collector_ghost_walk:OnAbilityExecuted( params )
	if IsServer() then
		if params.unit~=self:GetParent() then return end

		self:Destroy()
	end
end

function modifier_collector_ghost_walk:OnAttack( params )
	if IsServer() then
		if params.attacker~=self:GetParent() then return end

		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_collector_ghost_walk:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
	}

	return state
end

modifier_collector_ghost_walk_debuff = class({})

function modifier_collector_ghost_walk_debuff:IsHidden()
	return false
end

function modifier_collector_ghost_walk_debuff:IsDebuff()
	return true
end

function modifier_collector_ghost_walk_debuff:IsPurgable()
	return false
end

function modifier_collector_ghost_walk_debuff:OnCreated( kv )
	if IsServer() then
		-- references
		self.enemy_slow = self:GetAbility():GetOrbSpecialValueFor( "enemy_slow", "q" )

		-- send to client
		local sign = 0
		if self.enemy_slow<0 then sign = 2 end
		local tbl = {
			sign,
			math.abs(self.enemy_slow),
		}
        self:SetStackCount( intPack.Pack( tbl, 60 ) )
        
        self:StartIntervalThink(0.1)
	else
		-- receive from server
		local tbl = intPack.Unpack( self:GetStackCount(), 2, 60 )
		self.enemy_slow = (1-tbl[1])*tbl[2]
		self:SetStackCount( 0 )
	end
end

function modifier_collector_ghost_walk_debuff:OnRefresh( kv )
	if IsServer() then
		-- references
		self.enemy_slow = self:GetAbility():GetOrbSpecialValueFor( "enemy_slow", "q" )

		-- send to client
		local sign = 0
		if self.enemy_slow<0 then sign = 2 end
		local tbl = {
			sign,
			math.abs(self.enemy_slow),
		}
		self:SetStackCount( intPack.Pack( tbl, 60 ) )
	else
		-- receive from server
		local tbl = intPack.Unpack( self:GetStackCount(), 2, 60 )
		self.enemy_slow = (1-tbl[1])*tbl[2]
		self:SetStackCount( 0 )
	end
end

function modifier_collector_ghost_walk_debuff:OnIntervalThink()
	if IsServer() then
        local damage = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self:GetAbility():GetOrbSpecialValueFor( "damage", "q" ) / 10,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        }

        ApplyDamage( damage )
	end
end

function modifier_collector_ghost_walk_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_collector_ghost_walk_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.enemy_slow
end

function modifier_collector_ghost_walk_debuff:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end

function modifier_collector_ghost_walk_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end