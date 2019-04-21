pudge_flesh_heap_lua = class({})
LinkLuaModifier( "modifier_flesh_heap_lua", "abilities/pudge_flesh_heap_lua.lua" ,LUA_MODIFIER_MOTION_NONE )

function pudge_flesh_heap_lua:GetIntrinsicModifierName()
	return "modifier_flesh_heap_lua"
end

modifier_flesh_heap_lua = class({})

--------------------------------------------------------------------------------
function modifier_flesh_heap_lua:IsPurgable() return false end
function modifier_flesh_heap_lua:IsHidden() return true end
function modifier_flesh_heap_lua:IsPurgable() return false end
function modifier_flesh_heap_lua:RemoveOnDeath() return false end
function modifier_flesh_heap_lua:OnCreated( kv )
	if IsServer() then
		self._nKilledCreeps = 0
		self._nKilledHeroes = 0
	end
end


function modifier_flesh_heap_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_EVENT_ON_DEATH 
	}

	return funcs
end

function modifier_flesh_heap_lua:OnDeath( params )
	if IsServer() then
		if params.attacker == self:GetParent() then
			if params.unit:IsRealHero() then
				self:AddParameters(false)
			elseif params.unit:IsCreature() or params.unit:IsCreep() then
				self:AddParameters(true)
			end
		end

		if params.attacker ~= self:GetParent() and params.unit:IsRealHero() and params.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent():GetRangeToUnit(params.unit) <= self:GetAbility():GetSpecialValueFor("flesh_heap_range") then
			self:AddParameters(false)
		end
	end 
end

function modifier_flesh_heap_lua:AddParameters( bCreep )
	if bCreep then
		self._nKilledCreeps = self._nKilledCreeps + 1
	else
		self._nKilledHeroes = self._nKilledHeroes + 1
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

--------------------------------------------------------------------------------

function modifier_flesh_heap_lua:GetModifierExtraHealthBonus( params )
	return (self._nKilledCreeps * self:GetAbility():GetSpecialValueFor("flesh_heap_health_buff_creep")) + (self._nKilledHeroes * self:GetAbility():GetSpecialValueFor("flesh_heap_health_buff_hero"))
end


function modifier_flesh_heap_lua:GetModifierProcAttack_BonusDamage_Magical( params )
	return self._nKilledHeroes * self:GetAbility():GetSpecialValueFor("flesh_heap_magical_damage")
end

