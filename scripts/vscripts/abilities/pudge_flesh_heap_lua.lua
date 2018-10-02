pudge_flesh_heap_lua = class({})
LinkLuaModifier( "modifier_flesh_heap_lua", "abilities/pudge_flesh_heap_lua.lua" ,LUA_MODIFIER_MOTION_NONE )

--[[Author: Valve
	Date: 26.09.2015.
	Passive modifier which increases strength based on the number of kills made]]
--------------------------------------------------------------------------------

function pudge_flesh_heap_lua:GetIntrinsicModifierName()
	return "modifier_flesh_heap_lua"
end

--------------------------------------------------------------------------------

function pudge_flesh_heap_lua:OnHeroDiedNearby( hVictim, hKiller, kv )
	if hVictim == nil or hKiller == nil then
		return
	end

	if hVictim:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCaster():IsAlive() then
		self.flesh_heap_range = self:GetSpecialValueFor( "flesh_heap_range" )
		local vToCaster = self:GetCaster():GetOrigin() - hVictim:GetOrigin()
		local flDistance = vToCaster:Length2D()
		if hKiller == self:GetCaster() or self.flesh_heap_range >= flDistance then
			if self.nKills == nil then
				self.nKills = 0
			end

			self.nKills = self.nKills + 1

			local hBuff = self:GetCaster():FindModifierByName( "modifier_flesh_heap_lua" )
			if hBuff ~= nil then
				hBuff:SetStackCount( self.nKills )
				self:GetCaster():CalculateStatBonus()
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end

--------------------------------------------------------------------------------

function pudge_flesh_heap_lua:GetFleshHeapKills()
	if self.nKills == nil then
		self.nKills = 0
	end
	return self.nKills
end

--------------------------------------------------------------------------------

modifier_flesh_heap_lua = class({})

--------------------------------------------------------------------------------
function modifier_flesh_heap_lua:IsPurgable(  )
	return false
end

function modifier_flesh_heap_lua:OnCreated( kv )
	self.flesh_heap_magic_resist = self:GetAbility():GetSpecialValueFor( "flesh_heap_magic_resist" )
	self.flesh_heap_strength_buff_amount = self:GetAbility():GetSpecialValueFor( "flesh_heap_strength_buff_amount" )
	if IsServer() then
		self:SetStackCount( self:GetAbility():GetFleshHeapKills() )
		self:GetParent():CalculateStatBonus()
	end
end

--------------------------------------------------------------------------------

function modifier_flesh_heap_lua:OnRefresh( kv )
	self.flesh_heap_magic_resist = self:GetAbility():GetSpecialValueFor( "flesh_heap_magic_resist" )
	self.flesh_heap_strength_buff_amount = self:GetAbility():GetSpecialValueFor( "flesh_heap_strength_buff_amount" )
	if IsServer() then
		self:GetParent():CalculateStatBonus()
	end
end

--------------------------------------------------------------------------------

function modifier_flesh_heap_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_flesh_heap_lua:GetModifierMagicalResistanceBonus( params )
	return self.flesh_heap_magic_resist
end

--------------------------------------------------------------------------------

function modifier_flesh_heap_lua:GetModifierBonusStats_Strength( params )
	return self:GetStackCount() * self.flesh_heap_strength_buff_amount
end
--------------------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_flesh_heap_lua:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount() * self.flesh_heap_strength_buff_amount
end
------
--------------------------------------------------------------------------------

function modifier_flesh_heap_lua:GetModifierBonusStats_Agility( params )
	return self:GetStackCount() * self.flesh_heap_strength_buff_amount
end
------

function pudge_flesh_heap_lua:GetAbilityTextureName() return self.BaseClass.GetAbilityTextureName(self)  end 

